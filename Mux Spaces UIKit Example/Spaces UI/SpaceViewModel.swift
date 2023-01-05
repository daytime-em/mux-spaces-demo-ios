//
//  SpaceViewModel.swift
//  Mux Spaces UIKit Example
//
//  Created by Emily Dixon on 1/5/23.
//

import Foundation
import Combine
import UIKit

import MuxSpaces

// MARK: - Space View Model

class SpaceViewModel {
    /// For more about the @Published property wrapper
    /// see [here](https://developer.apple.com/documentation/combine/published)

    // MARK: Join Button
    @Published var isJoinSpaceButtonHidden: Bool = false

    // MARK: Participants Snapshot
    @Published var snapshot: ParticipantsSnapshot

    // MARK: Participants View
    @Published var isParticipantsViewHidden: Bool = true

    // MARK: Display Error
    @Published var shouldDisplayError: Error? = nil

    // MARK: Space
    /// The space the app is joining
    var space: Space

    // MARK: Published Tracks
    /// If the app publishes audio or video tracks,
    /// they will be set here
    var publishedAudioTrack: AudioTrack?
    var publishedVideoTrack: VideoTrack?

    // MARK: Initialization
    init(space: Space) {
        self.space = space
        self.snapshot = ParticipantsSnapshot.makeEmpty()
    }

    // MARK: Setup Snapshot Updates
    func setupSnapshotUpdates(
        for dataSource: ParticipantsDataSource
    ) -> AnyCancellable {
        return $snapshot
            .sink { dataSource.apply($0) }
    }

    // MARK: Fetch Most Recent Participant State
    func participant(
        from participantID: Participant.ID
    ) -> Participant? {
        if let localParticipant = space.localParticipant {
            return (
                [localParticipant] + space.remoteParticipants
            ).filter { $0.id == participantID }.first
        } else {
            return space.remoteParticipants
                .filter { $0.id == participantID }.first
        }
    }

    // MARK: Update Participant Cell
    func configureSpaceParticipantVideo(
        _ cell: SpaceParticipantVideoCell,
        indexPath: IndexPath,
        participantID: Participant.ID
    ) {
        guard let participant = participant(
            from: participantID
        ) else {
            print("No Participant!")
            return
        }

        cell.update(
            participantID: participant.id,
            videoTrack: participant.videoTracks.values.first
        )
    }
    
}

extension SpaceViewModel {
    var audioCaptureOptions: MuxSpaces.AudioCaptureOptions? {
        return AudioCaptureOptions()
    }

    var cameraCaptureOptions: MuxSpaces.CameraCaptureOptions? {
        return CameraCaptureOptions()
    }

    // MARK: - Setup Observers on Space State Updates

    func setupEventHandlers() -> Set<AnyCancellable> {

        var cancellables: Set<AnyCancellable> = []

        /// Setup observers that will update your views state
        /// based on events that are produced by the space
        space
            .events
            .joinSuccess.map { _ in return false }
            .assign(to: \.isParticipantsViewHidden, on: self)
            .store(in: &cancellables)

        space
            .events
            .joinSuccess.map { _ in return true }
            .assign(to: \.isJoinSpaceButtonHidden, on: self)
            .store(in: &cancellables)

        space
            .events
            .joinFailure
            .map { _ in return nil }
            .assign(to: \.shouldDisplayError, on: self)
            .store(in: &cancellables)

        space
            .events
            .joinSuccess
            .sink { [weak self] _ in
                guard let self = self else {
                    return
                }

                self.handleJoinSuccess()
            }
            .store(in: &cancellables)

        Combine.Publishers.Merge6(
            /// Joining a space successfully triggers a
            /// placeholder cell to be added for the local participant
            space.events
                .joinSuccess
                .map(\.localParticipant.id),
            /// Participant joined events trigger a new
            /// cell to be added for each new participant
            space.events
                .participantJoined
                .map(\.participant.id),
            /// When the SDK subscribes to a new video track,
            /// the participants video becomes available to display
            space.events
                .videoTrackSubscribed
                .map(\.participant.id),
            /// When the SDK unsubscribes from a video track,
            /// the participants video should be taken down
            /// this update is handled in ParticipantsViewModel
            space.events
                .videoTrackUnsubscribed
                .map(\.participant.id),
            // We only want to know when our own tracks are
            // published
            space.events
                .videoTrackPublished
                .filter { $0.participant.isLocal }
                .map(\.participant.id),
            // We only want to know when our own tracks are
            // published
            space.events
                .videoTrackUnpublished
                .filter { $0.participant.isLocal }
                .map(\.participant.id)
        )
        .sink(receiveValue: { [weak self] (id: Participant.ID) in
            guard let self = self else { return }

            self.upsertParticipant(
                id
            )
        })
        .store(in: &cancellables)

        /// Each participant leaving will cause the applicable cell
        /// to be removed.
        space.events
            .participantLeft
            .map(\.participant.id)
            .sink(receiveValue: { [weak self] (id: Participant.ID) in
                guard let self = self else { return }

                self.removeParticipant(
                    id
                )
            })
            .store(in: &cancellables)

        return cancellables
    }

    func joinSpace() -> Set<AnyCancellable> {
        let cancellables = setupEventHandlers()

        space.join()

        return cancellables
    }

    func handleJoinSuccess() {
        #if !targetEnvironment(simulator)
        publishAudio()
        publishVideo()
        #endif
    }

    func publishAudio() {

        /// We'll use the default options to setup
        /// audio capture from the device mic
        let options = AudioCaptureOptions()

        /// Construct an audio track
        let micTrack = space.makeMicrophoneCaptureAudioTrack(
            options: options
        )

        /// Publish the audio track
        space.publishTrack(
            micTrack
        ) { [weak self] (error: AudioTrack.PublishError?) in
            guard error == nil else { return }

            guard let self = self else { return }

            self.publishedAudioTrack = micTrack
        }
    }

    func publishVideo() {

        /// We'll use the default options to setup
        /// camera capture from the device's front camera
        let options = CameraCaptureOptions()

        /// Publish the camera track
        let cameraTrack = space.makeCameraCaptureVideoTrack(
            options: options
        )

        /// Publish the video track
        space.publishTrack(
            cameraTrack
        ) { [weak self] (error: VideoTrack.PublishError?) in
            guard error == nil else { return }

            guard let self = self else { return }

            self.publishedVideoTrack = cameraTrack
        }
    }

    func upsertParticipant(
        _ participantID: Participant.ID
    ) {
        self.snapshot.upsertParticipant(
            participantID
        )
    }

    func removeParticipant(
        _ participantID: Participant.ID
    ) {
        self.snapshot.removeParticipant(
            participantID
        )
    }

    func resetSnapshot() {
        self.snapshot = ParticipantsSnapshot.makeEmpty()
    }
}
