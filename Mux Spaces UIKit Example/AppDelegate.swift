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
    static var spacesJwt: String = "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoicHVibGlzaGVyIiwia2lkIjoibGN0NDAwajRGZFR6enViTVFkb2lZMjAyazdnTlBlUVRoSkh5aFJrbGlCa0FVIiwiZXhwIjoxNjczNTYyMTQ4LCJhdWQiOiJydCIsInN1YiI6Ijd1RDAwZmRndklta0RwVW1vQkFiOVIzUG82dWhVRGZiOVlHUW00YXZCbnQ4In0.iLABN-tPMmmWj0phK2p5VKW_XNr-NC73CB1d6VZBLObGkjLSqlDMk26dironO2NdsMg_dgrplp022gQt8XzgmCRhNydJOmiNFciPBTXwfNNMC4kkuxjdAtsWiFxB8btRPN_yzUGLmZnWmbZR9aDiQnUQfhbkIhft1Ejzu2kzJO8DATG6KG9C_JzYY2k2yQgD6C5rDt-kn6VagaZ18NQWqzU8e3AXN89YFWeiEQVAHVyKIRaUbfXDASHnV9MPizIGf-pHYdPc0K96e5-cOynIocTIHbgFxxBu7eUMz1isA4W0Ax4_CqDMeKDR6AbEB9z_n63sh5NYeTTsezesDlJonQ"
    
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
