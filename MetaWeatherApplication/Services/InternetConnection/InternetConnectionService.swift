//
//  InternetConnectionService.swift
//  MetaWeatherApplication
//
//  Created by bora on 21.09.2021.
//

import UIKit

class InternetConnectionControlService {
    
    static let shared = InternetConnectionControlService()
    
    private let reachability: Reachability = try! Reachability(hostname: "google.com")
    private let alertService = AlertService()
    
    init() {
        setReachability()
    }
    
    private func setReachability() {
        do {
            try reachability.startNotifier()
        } catch {
            assertionFailure("Unable to start\nnotifier")
        }
        setListiningWhenUnReachable()
    }

    private func setListiningWhenUnReachable() {
        reachability.whenUnreachable = { reachability in
            if self.reachability.connection == .unavailable {
                self.showAlert()
            }
        }
    }
    
    private func checkInternetStatus() {
        if self.reachability.connection == .unavailable {
            self.showAlert()
        }
    }
    
    func getInternetAvaliable() -> Bool {
        if self.reachability.connection == .unavailable {
            return false
        }
        return true
    }
    
    private func showAlert() {
        let alertActionCloseApp = UIAlertAction(title: "Exit", style: .default) { _ in
            exit(0)
        }
        
        self.alertService.showNativeAlert(title: "Error", description: "You have lost internet connection. Please try again later.", style: .alert, actions: [alertActionCloseApp]) {
            self.checkInternetStatus()
        }
    }
}
