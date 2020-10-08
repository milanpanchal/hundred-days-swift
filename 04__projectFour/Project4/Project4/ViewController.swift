//
//  ViewController.swift
//  Project4
//
//  Created by Jamie Brannan on 24/09/2020.
//  Copyright © 2020 Jamie Brannan. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {

  var webView: WKWebView!
  var progressView: UIProgressView!

  override func loadView() {
      webView = WKWebView()
      webView.navigationDelegate = self
      view = webView
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupWebView()
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
    createToolbar()
  }

  private func setupWebView() {
    let url = URL(string: "https://www.hackingwithswift.com")!
    webView.load(URLRequest(url: url))
    webView.allowsBackForwardNavigationGestures = true
  }

  private func createToolbar() {
    let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
    progressView = UIProgressView(progressViewStyle: .default)
    progressView.sizeToFit()
    let progressButton = UIBarButtonItem(customView: progressView)

    webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)

    toolbarItems = [progressButton, spacer, refresh]
    navigationController?.isToolbarHidden = false
  }

  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
      if keyPath == "estimatedProgress" {
          progressView.progress = Float(webView.estimatedProgress)
      }
  }

  // MARK: - WebView Navigation
  @objc func openTapped() {
      let ac = UIAlertController(title: "Open page…", message: nil, preferredStyle: .actionSheet)
      ac.addAction(UIAlertAction(title: "apple.com", style: .default, handler: openPage))
      ac.addAction(UIAlertAction(title: "hackingwithswift.com", style: .default, handler: openPage))
      ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
      ac.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
      present(ac, animated: true)
  }
  
  func openPage(action: UIAlertAction) {
      let url = URL(string: "https://" + action.title!)!
      webView.load(URLRequest(url: url))
  }

  // MARK: - Custom Callbacks
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
      title = webView.title
  }
}

