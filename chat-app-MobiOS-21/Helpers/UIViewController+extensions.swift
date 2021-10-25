//
//  UIViewController+extensions.swift
//  chat-app-MobiOS-21
//
//  Created by Александр Дергилёв on 27.09.2021.
//

import UIKit
import AVKit

extension UIViewController {
    
    // Global Alert
    // Define Your number of buttons, styles and completion
    public func openAlert(title: String? = nil,
                          message: String? = nil,
                          alertStyle: UIAlertController.Style = .alert,
                          actionTitles: [String] = [],
                          actionStyles: [UIAlertAction.Style] = [],
                          actions: [((UIAlertAction) -> Void)] = [],
                          autoDismiss: Bool = false,
                          from sourceView: UIView? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: alertStyle)
        for(index, indexTitle) in actionTitles.enumerated() {
            let action = UIAlertAction(title: indexTitle, style: actionStyles[index], handler: actions[index])
            alertController.addAction(action)
        }
        self.present(alertController, animated: true) {
            if autoDismiss {
                _ = Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { (_) in
                    alertController.dismiss(animated: true, completion: nil)
                })
            }
        }
    }
    
    public func canOpenCamera() -> Bool {
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch authStatus {
        case .restricted, .denied:
            let yesAction: (UIAlertAction) -> Void = { _ in
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
            }
            let noAction: (UIAlertAction) -> Void = { _ in }
            openAlert(title: "No access to the camera", alertStyle: .alert,
                      actionTitles: ["No", "Yes"],
                      actionStyles: [.default, .default], actions: [noAction, yesAction])
            return false
        case .authorized, .notDetermined:
            return true
        @unknown default:
            fatalError()
        }
    }
}
