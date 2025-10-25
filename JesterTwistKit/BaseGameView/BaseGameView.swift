
import UIKit
import SnapKit

class BaseGameView: UIViewController {

    private let backgroundView = BackGroundView()
    private let helpView = HelpAppView.shared
    
    private let appImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "name_logo_app")
        return view
    }()
    private lazy var settingsButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tag = 1
        view.setBackgroundImage(UIImage(named: "settinga_image"), for: .normal)
        view.addTarget(self, action: #selector(tabButton), for: .touchUpInside)
        return view
    }()
    private lazy var playButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tag = 2
        view.setBackgroundImage(UIImage(named: "play_button_image"), for: .normal)
        view.addTarget(self, action: #selector(tabButton), for: .touchUpInside)
        return view
    }()
    private lazy var quizButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tag = 3
        view.setBackgroundImage(UIImage(named: "quiz_image"), for: .normal)
        view.addTarget(self, action: #selector(tabButton), for: .touchUpInside)
        return view
    }()
    private lazy var twistButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tag = 4
        view.setBackgroundImage(UIImage(named: "twist_image"), for: .normal)
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
        view.addSubview(settingsButton)
        settingsButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.right.equalToSuperview().inset(15)
            make.width.equalTo(47)
            make.height.equalTo(61)
        }
        
        view.addSubview(appImageView)
        appImageView.alpha = 0.0
        appImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
        view.addSubview(playButton)
        playButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(260)
            make.height.equalTo(120)
            make.bottomMargin.equalToSuperview().inset(-200)
        }
        
        view.addSubview(quizButton)
        view.addSubview(twistButton)
        twistButton.alpha = 0.0
        quizButton.alpha = 0.0
        
        quizButton.snp.makeConstraints { make in
            make.top.equalTo(twistButton.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(200)
        }
        twistButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(260)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            UIView.animate(withDuration: 0.5) {
                self.appImageView.alpha = 1.0
                self.playButton.snp.updateConstraints { make in
                    make.centerX.equalToSuperview()
                    make.width.equalTo(260)
                    make.height.equalTo(120)
                    make.bottomMargin.equalToSuperview().inset(15)
                }
                self.view.layoutIfNeeded()
            }
        }
    }
    @objc func tabButton(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            helpView.quickAnimation(settingsButton)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                let screen = AppSettingsView()
                self.navigationController?.pushViewController(screen, animated: false)
            }
        case 2:
            helpView.quickAnimation(playButton)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                UIView.animate(withDuration: 0.5) {
                    self.appImageView.alpha = 0.0
                    self.twistButton.alpha = 1.0
                    self.quizButton.alpha = 1.0
                    self.playButton.snp.updateConstraints { make in
                        make.centerX.equalToSuperview()
                        make.width.equalTo(260)
                        make.height.equalTo(120)
                        make.bottomMargin.equalToSuperview().inset(-300)
                    }
                    self.view.layoutIfNeeded()
                }
            }
        case 3:
            helpView.quickAnimation(quizButton)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                let creen = SelectQuizScreen()
                self.navigationController?.pushViewController(creen, animated: false)
            }
        case 4:
            helpView.quickAnimation(twistButton)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                let creen = JesterTwistScreen()
                self.navigationController?.pushViewController(creen, animated: false)
            }
        default: break
        }
    }
}
