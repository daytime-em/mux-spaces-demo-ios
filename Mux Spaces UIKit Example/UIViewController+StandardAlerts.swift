//
//  UIViewController+StandardAlerts.swift
//  Mux Spaces UIKit Example
//
//  Created by Emily Dixon on 1/5/23.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showErrorAlertOk(title: String, message: String, inParent: UIViewController) {
        let alert = makeErrorAlertOk(title: title, message: message)
        inParent.present(alert, animated: true)
    }
    
    func makeErrorAlertOk(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "OK Dialog Confirm"), style: .default))
        return alert
    }
}
