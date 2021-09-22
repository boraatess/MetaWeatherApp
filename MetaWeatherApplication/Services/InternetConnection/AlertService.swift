//
//  AlertService.swift
//  MetaWeatherApplication
//
//  Created by bora on 21.09.2021.
//

import UIKit

class AlertService {
    
    private var alertWindow: UIWindow = UIWindow(frame: UIScreen.main.bounds)
    
    init() {
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindow.Level.alert + 1;
        alertWindow.makeKeyAndVisible()
        alertWindow.isHidden = true
    }
    
    func showNativeAlert(title: String,
                         description: String,
                         style: UIAlertController.Style? = nil,
                         actions: [UIAlertAction]? = nil, completion: (() -> ())?) {
        var preferredStyle = style
        if UIDevice.current.userInterfaceIdiom == .pad {
            preferredStyle = .alert
        }
        let alert = AppAlertController(title: title, message: description, preferredStyle: preferredStyle ?? .alert)
        
        if let actions = actions {
            for action in actions {
                alert.addAction(action)
            }
        } else {
            let action = UIAlertAction(title: "OK", style: .default)
            alert.addAction(action)
        }
        
        alertWindow.isHidden = false
        alertWindow.rootViewController?.present(alert, animated: true, completion: nil)
        alert.dismissHandler = {
            completion?()
            self.alertWindow.isHidden = true
        }
    }
}

class AppAlertController : UIAlertController {
    var dismissHandler : (()->())?
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        dismissHandler?()
    }
}
