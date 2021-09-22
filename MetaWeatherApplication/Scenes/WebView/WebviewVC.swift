//
//  WebviewVC.swift
//  MetaWeatherApplication
//
//  Created by bora on 18.09.2021.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    var weburl: String?
    private var url: URL?
    let screen = UIScreen.main.bounds
    
    private let webview: WKWebView = {
        let preferences = WKWebpagePreferences()
        preferences.allowsContentJavaScript = true
        let configuration = WKWebViewConfiguration()
        configuration.defaultWebpagePreferences = preferences
        let webview = WKWebView(frame: .zero, configuration: configuration)
        return webview
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        url = URL(string: weburl ?? "")
        webview.load(URLRequest(url: url!))
        configureButtons()
        view.backgroundColor = .white
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        view.addSubview(webview)
        webview.frame = CGRect(x: 0, y: 50, width: screen.width , height: screen.height)
    }
    
    private func configureButtons() {
        navigationItem.rightBarButtonItem =  UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(didTapRefresh))
    }
    
    @objc func didTapRefresh() {
        webview.load(URLRequest(url: url!))
    }
}
