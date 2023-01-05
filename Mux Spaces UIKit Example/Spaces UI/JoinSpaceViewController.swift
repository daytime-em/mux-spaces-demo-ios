//
//  SpaceViewController.swift
//  Mux Spaces UIKit Example
//
//  Created by Emily Dixon on 1/4/23.
//

import Foundation
import Combine
import UIKit

import MuxSpaces

class JoinSpaceViewController: UIViewController {
    
    // MARK: IBOutlets for Storyboard
    @IBOutlet var participantsView: UICollectionView!
    
    @IBOutlet var joinSpaceButton: UIButton!
    
    // MARK: IBAction for Storyboard
    @IBAction @objc func joinSpaceButtonDidTouchUpInside(
        _ sender: UIButton
    ) {
        guard joinSpaceButton == sender else {
            print("Unexpected sender received by join space handler. This should be the join space UIButton.")
            return
        }
        
        joinSpaceButton.isEnabled = false
        joinSpace()
    }
    
    // MARK: Subscription related state
    var cancellables: Set<AnyCancellable> = []
    
    // MARK: View Model
    lazy var viewModel = SpaceViewModel(
        space: AppDelegate.space
    )
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        /// Setup participants view with a custom layout and
        /// configure its backing data source
        setupParticipantsView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        /// Tear down
        cancellables.forEach { $0.cancel() }
        super.viewWillDisappear(animated)
    }
    
    // MARK: UI Setup
    lazy var dataSource: ParticipantsDataSource = setupParticipantsDataSource()
    
    func setupParticipantsDataSource() -> ParticipantsDataSource {
        let participantVideoCellRegistration = UICollectionView
            .CellRegistration<
                SpaceParticipantVideoCell,
                Participant.ID
        >(
            handler: viewModel.configureSpaceParticipantVideo(_:indexPath:participantID:)
        )
        
        let dataSource = ParticipantsDataSource(
            collectionView: participantsView
        ) { (collectionView: UICollectionView, indexPath: IndexPath, item: Participant.ID) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(
                using: participantVideoCellRegistration,
                for: indexPath,
                item: item
            )
        }
        
        participantsView.dataSource = dataSource
        
        viewModel
            .setupSnapshotUpdates(for: dataSource)
            .store(in: &cancellables)
        
        return dataSource
    }
    
    func setupParticipantsView() {
        participantsView.isHidden = true
        self.dataSource = setupParticipantsDataSource()
    }
}

// MARK: - Trigger button to call to join Space

extension JoinSpaceViewController {
    func joinSpace() {
        // Setup an event handler for joining the space
        // successfully
        viewModel.$isParticipantsViewHidden
            .assign(
                to: \.isHidden,
                on: participantsView
            )
            .store(in: &cancellables)

        viewModel.$isJoinSpaceButtonHidden
            .assign(
                to: \.isHidden,
                on: joinSpaceButton
            )
            .store(in: &cancellables)

        // Setup an event handler in case there is an error
        // when joining the space
        viewModel.$shouldDisplayError
            .compactMap { $0 }
            .sink { [weak self] joinError in
                guard let self = self else { return }
                let msg = String.localizedStringWithFormat("Error Joining Space!\n\t%@", joinError.localizedDescription)
                NSLog(msg)
                self.showErrorAlertOk(title: NSLocalizedString("Join Error", comment: "Join Space error title"), message: msg, inParent: self)
            }
            .store(in: &cancellables)

        // We're all setup, lets join the space!
        let dataSourceCancellables = viewModel.joinSpace()

        cancellables.formUnion(dataSourceCancellables)
    }
    
}
