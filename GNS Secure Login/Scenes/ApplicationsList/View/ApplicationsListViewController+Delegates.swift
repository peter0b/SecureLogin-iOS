//
//  ApplicationsListViewController+Delegates.swift
//  GNS Secure Login
//
//  Created Peter Bassem on 02/08/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//

import UIKit
import WebKit

extension ApplicationsListViewController: ApplicationsListViewProtocol {
    
    func refreshViewController() {
        collectionView.reloadData()
    }
    
    func saveSitesCodesToCard(_ sitesCodes: [String]) {
        let bluetoothManager = BluetoothManager.getInstance()
        let cardChannel = bluetoothManager.getChardChannel()
        if cardChannel != nil {
            card = cardChannel!.card
            mifareDesfireHelper = MiFareDesfireHelper(card: card, mifareNFCCardManager: ApduCommandExecuter())
            
            mifareDesfireHelper.syncSitesDictionaryFromConfigFile(sitesCodes: sitesCodes) { apduResponse, exception in
                print(self.mifareDesfireHelper.nFCSitesDictionary)
            }
        }
    }
    
    func readApplicationCredentials(sites: [SiteVM]) {
        mifareDesfireHelper.readSitesFromCard(cardChannel: card, sites: sites) { response, error in
            if let error = error {
                print("Failed to read site \(sites[0].code ?? ""):", error)
                return
            }
//            dump(response)
            print("username:", sites[0].username)
            print("password:", sites[0].password)
        }
    }
    
    func writeApplicationCredentials(sites: [SiteVM]) {
        mifareDesfireHelper.writeSitesToCard(card, sites: sites) { response, error in
            if let error = error {
                print("Failed to read site \(sites[0].code ?? ""):", error)
                return
            }
//            dump(response)
            print("username:", sites[0].username)
            print("password:", sites[0].password!.dropLast(11).map { String($0) })
        }
    }
    
    func showWebPage(withUrl urlString: String, javascript: String) {
        guard let url = URL(string: urlString) else { return }
        
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        
        let webView = WKWebView(frame: view.bounds, configuration: configuration)
        
        webView.navigationDelegate = self
                
        let urlRequest = URLRequest(url: url)
        webView.load(urlRequest)
        webView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        applicationWebViewController = UIViewController()
        applicationWebViewController?.view.addSubview(webView)
        webView.fillSuperview()
        let navController = UINavigationController(rootViewController: applicationWebViewController!)
        navController.modalPresentationStyle = .fullScreen
//        navigationController?.pushViewController(vc, animated: true)
//        keyWindow?.rootViewController?.navigationController?.pushViewController(vc, animated: true)
        let cancelBarButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(cancelButtonDidPressed(_:)))
        applicationWebViewController?.navigationItem.rightBarButtonItem = cancelBarButton
        keyWindow?.rootViewController?.present(navController, animated: true)
    }
    
    @objc
    private func cancelButtonDidPressed(_ sender: UIBarButtonItem) {
        applicationWebViewController?.dismiss(animated: true)
    }
}

extension ApplicationsListViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Finished navigating to url \(webView.url)")
        
        let script =  "document.getElementById('login_field').value = 'username'; document.getElementById('password').value='password'; document.forms[0].sudebmit();"
        
        webView.evaluateJavaScript(script) { (result, error) in
            if let result = result {
                print("Label is updated with mer ssage: \(result)")
            } else if let error = error {
                print("An error occurred: \(error)")
            }
        }
    }
}
