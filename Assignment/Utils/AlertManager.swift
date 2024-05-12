//
//  AlertManager.swift
//  Assignment
//
//  Created by Pramod Shukla on 12/05/24.
//

import Foundation
import UIKit

struct AlertManager {
    
    static func showErrorAlert(title: String,withMessage message: String) {
        guard let rootViewController = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .compactMap({$0 as? UIWindowScene})
            .first?.windows
            .filter({$0.isKeyWindow})
            .first?
            .rootViewController
             else { return }
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        rootViewController.present(alertController, animated: true, completion: nil)
    }
}
