
import UIKit
import SnapKit
import StoreKit
import WebKit

class AppSettingsView: UIViewController {

    private let backgroundView = BackGroundView()
    private let helpView = HelpAppView.shared
//    private let images = [UIImage(named: "treasure__image"), UIImage(named: "result_image"), UIImage(named: "privacy_image"), UIImage(named: "info_image"), UIImage(named: "rape_app_image")]
    private let images = [UIImage(named: "result_image"), UIImage(named: "privacy_image"), UIImage(named: "info_image"), UIImage(named: "rape_app_image")]
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 5
        stack.distribution = .fill
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var backToButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tag = 1
        view.setBackgroundImage(UIImage(named: "back_button_image"), for: .normal)
        view.addTarget(self, action: #selector(tabButton), for: .touchUpInside)
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        view.addSubview(stackView)
        view.addSubview(backToButton)
        stackView.snp.makeConstraints { make in
//            make.bottom.equalTo(backToButton.snp.top).inset(-15)
            make.bottom.equalTo(backToButton.snp.top).inset(-40)
            make.leading.trailing.equalToSuperview()
        }
        backToButton.snp.makeConstraints { make in
            make.height.equalTo(66)
            make.leading.trailing.equalToSuperview().inset(30)
            make.bottomMargin.equalToSuperview().inset(15)
        }
        setupButtons()
    }
    private func setupButtons() {
        for (index, image) in images.enumerated() {
            let button = createButton(with: image,
                                      index: index)
            stackView.addArrangedSubview(button)
        }
    }
    private func createButton(with image: UIImage?,
                              index: Int) -> UIButton {
        var configuration = UIButton.Configuration.filled()
        configuration.image = image
        configuration.title = title
        configuration.imagePadding = 8
        configuration.baseBackgroundColor = .clear
        
        let button = UIButton(configuration: configuration,
                              primaryAction: nil)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = index
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }
    @objc private func buttonTapped(_ sender: UIButton) {
        helpView.quickAnimation(sender)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//            switch sender.tag {
//            case 0:
//                let screen = TreasureScreen()
//                self.navigationController?.pushViewController(screen, animated: false)
//            case 1:
//                let screen = ResultScreen()
//                self.navigationController?.pushViewController(screen, animated: false)
//            case 2:
//                let screen = LinkScreen()
//                screen.isPolicy = true
//                screen.loadURL(JesterTvistData.proivacy.value)
//                self.navigationController?.pushViewController(screen, animated: false)
//            case 3:
//                let screen = InfoScreen()
//                self.navigationController?.pushViewController(screen, animated: false)
//            case 4: SKStoreReviewController.requestRateAppJester()
//            case 5: self.navigationController?.popViewController(animated: false)
//            default: break
//            }
            switch sender.tag {
            case 0:
                let screen = ResultScreen()
                self.navigationController?.pushViewController(screen, animated: false)
            case 1:
                let screen = LinkScreen()
                screen.isPolicy = true
                screen.loadURL(JesterTvistData.proivacy.value)
                self.navigationController?.pushViewController(screen, animated: false)
            case 2:
                let screen = InfoScreen()
                self.navigationController?.pushViewController(screen, animated: false)
            case 3: SKStoreReviewController.requestRateAppJester()
            case 4: self.navigationController?.popViewController(animated: false)
            default: break
            }
        }
    }
    @objc func tabButton(_ sender: UIButton) {
        switch sender.tag {
            case 1:
            navigationController?.popViewController(animated: false)
        default:
            break
        }
    }
}
extension SKStoreReviewController {
    public static func requestRateAppJester() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            DispatchQueue.main.async {
                requestReview(in: scene)
            }
        }
    }
}


class LinkScreen: UIViewController {
    
    var isPolicy = true
    
    private lazy var webView: WKWebView = {
        let view = WKWebView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let backToViewButton: UIButton = {
        let view = UIButton()
        view.tintColor = .black
        view.setBackgroundImage(UIImage(systemName: "arrow.left.circle"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    private func setupViews() {
        view.addSubview(webView)
        view.addSubview(backToViewButton)
        backToViewButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(5)
            make.left.equalTo(20)
            make.height.width.equalTo(30)
        }
        webView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.bottomMargin.equalToSuperview()
        }
        backToViewButton.addTarget(self, action: #selector(closeButtonTap), for: .touchUpInside)
        if isPolicy == false {
            backToViewButton.isHidden = true
        }
    }
    @objc private func closeButtonTap() {
        navigationController?.popViewController(animated: false)
    }
    func loadURL(_ url: String) {
        guard let url = URL(string: url) else {
            print("Invalid URL")
            return
        }
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
