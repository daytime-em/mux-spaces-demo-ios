//
//  AppDelegate.swift
//  Mux Spaces UIKit Example
//
//  Created by Emily Dixon on 1/3/23.
//

import UIKit
import MuxSpaces

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // TODO: This should be like a YOUR JWT HERE kind of thing, link to the docs, explain how to use the CLI (and update explain the web UI later if necessary)
    /// Generated via the Mux CLI: https://github.com/muxinc/cli#mux-spacessign-space-id
    static var spacesJwt: String = "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoicHVibGlzaGVyIiwia2lkIjoibGN0NDAwajRGZFR6enViTVFkb2lZMjAyazdnTlBlUVRoSkh5aFJrbGlCa0FVIiwiZXhwIjoxNjczNDgyOTg5LCJhdWQiOiJydCIsInN1YiI6Ill6eVBPdnM2eVpKUUw0TlMwMXRXZmpHMDJ5RW11SklHOUZQUUlnYWlGdnZwdyJ9.fbVXSTEV-wDc-LOhkiODCjJVRnkMS_ze9gnsH8OXZpmlBRXg2CByyqg84MHIh9W4g_ozG7OrjQpvTk9k2dFSoWmYKwxQdO0w5i6lwwoamBR8TFIlA8gbSUN9V3fWJzi8tfLMPJBkun1afHJYZ9R-PwmvbZd6evnZDQ14-0j5Q0zvQEGAd0LeO4vdFEpJNuMGWmTgUT2m9PCp1gGrR2aGx-2ts_f-wSVCapi7OF6bvWqzAp3YiQVszrZ7b0bM_pTnShbjzUll2oR4kiIMFkRPLqWAa1fq1nIGkDD_g9Wh90f-jY_bTvszTA8WEGyiXhg9yx-ToW_QdKlg1j6EMURG_w"
    
    /// Initialize a Space using the defined token
    static var space: Space = {
        precondition(
            !spacesJwt.isEmpty,
            "Please set a valid JWT token before initializing a space"
        )
        
        return try! Space(token: spacesJwt)
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}
