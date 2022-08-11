//
//  ApplicationsListRouter.swift
//  GNS Secure Login
//
//  Created Peter Bassem on 02/08/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//

import UIKit
import SafariServices
import WebKit
import CoreBluetooth
import SmartCardIO

// MARK: ApplicationsList Router -

class ApplicationsListRouter: BaseRouter, ApplicationsListRouterProtocol {
    
    static func createModule() -> UIViewController {
        let view =  ApplicationsListViewController()

        let interactor = ApplicationsListInteractor(
            useCase: ApplicationsListUseCase(
                applicationsListRepository: ApplicationsListRepositryImp()
            )
        )
        let router = ApplicationsListRouter()
        let presenter = ApplicationsListPresenter(view: view, interactor: interactor, router: router)
        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view
        return view
    }

    func openURL(withUrl urlString: String, javascript: String) {
        guard let url = URL(string: urlString) else { return }
//        let safariViewController = SFSafariViewController(url: url)
//        viewController?.present(safariViewController, animated: true)
        
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        
        let script =  "document.getElementById('login_field').value = 'username'; document.getElementById('password').value='password'; document.forms[0].submit();"
        let webView = WKWebView(frame: viewController?.view.bounds ?? .zero, configuration: configuration)
        webView.evaluateJavaScript(script) { (result, error) in
            if let result = result {
                print("Label is updated with mer ssage: \(result)")
            } else if let error = error {
                print("An error occurred: \(error)")
            }
        }
//        webView.navigationDelegate = self
        
        let urlRequest = URLRequest(url: url)
        webView.load(urlRequest)
        webView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        let vc = UIViewController()
        vc.view.addSubview(webView)
        viewController?.present(vc, animated: true)
    }
    
    func navigateToEditApplicationCredentialsViewController(card: Card, mifareDesfireHelper: MiFareDesfireHelper, application: SitesInfo, sites: [SiteVM]) {
        let editApplicationCredentialsViewController = EditApplicationCredentialsRouter.createModule(card: card, mifareDesfireHelper: mifareDesfireHelper, application: application, sites: sites)
        viewController?.navigationController?.pushViewController(editApplicationCredentialsViewController, animated: true)
    }
    
//    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//            if navigationAction.navigationType == .linkActivated  {
//                if let url = navigationAction.request.url,
//                    let host = url.host, !host.hasPrefix("www.google.com"),
//                    UIApplication.shared.canOpenURL(url) {
//                    UIApplication.shared.open(url)
//                    print(url)
//                    print("Redirected to browser. No need to open it locally")
//                    decisionHandler(.cancel)
//                } else {
//                    print("Open it locally")
//                    decisionHandler(.allow)
//                }
//            } else {
//                print("not a user click")
//                decisionHandler(.allow)
//            }
//        }
}
