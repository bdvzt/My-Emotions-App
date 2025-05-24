//
//  FakeLoginController.swift
//  MyEmotions
//
//  Created by Zayata Budaeva on 23.05.2025.
//

import WebKit

final class FakeWebViewController: UIViewController {

    private let completion: () -> Void
    private let webView = WKWebView()

    init(completion: @escaping () -> Void) {
        self.completion = completion
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
        simulateLoginDelay()
    }

    private func setupWebView() {
        view.addSubview(webView)
        webView.snp.makeConstraints { $0.edges.equalToSuperview() }

        let url = URL(string: "https://ibb.co/KcFN223Q")!
        webView.load(URLRequest(url: url))
    }

    private func simulateLoginDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
            self.dismiss(animated: true) {
                self.completion()
            }
        }
    }
}
