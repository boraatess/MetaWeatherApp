//
//  SplashViewController.swift
//  MetaWeatherApplication
//
//  Created by bora on 15.09.2021.
//

import UIKit
import CoreLocation

class SplashViewController: UIViewController {
    
    var manager: CLLocationManager?
    public static var userDefaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()

        print("splash")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        manager = CLLocationManager()
        manager?.delegate = self
        manager?.desiredAccuracy = kCLLocationAccuracyBest
        manager?.requestWhenInUseAuthorization()
        manager?.startUpdatingLocation()
        showHome()
    }
    
    private func fetchData() {
        let params = SearchCityRequest(query: "ist")
        HomeApi().fetchSearchedCity(query: params).done { [unowned self] response in
            print(response as Any)
            if response?.isEmpty == false {
                self.showHome()
            } else {
                self.showAlert()
            }
        }.catch { error in
            print(error.localizedDescription)
        }
    }
    
    private func showHome() {
        DispatchQueue.main.asyncAfter(deadline: .now()+3) {
            let vc =  UINavigationController(rootViewController: HomeViewController())
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Network Connection Error", message: "Please check your wifi/cellular connection", preferredStyle: .alert)
        let action = UIAlertAction(title: "Go Settings", style: .default) { (action) in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)")
                })
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
            }
        }
        alert.addAction(cancel)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}

extension SplashViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let first = locations.first else {
            return
        }
        let lat = first.coordinate.latitude
        let long = first.coordinate.longitude
        SplashViewController.userDefaults.setValue(lat, forKey: "latt")
        SplashViewController.userDefaults.setValue(long, forKey: "long")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
