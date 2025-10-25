
import UIKit
import SnapKit

class ResultQuizScreen: UIViewController {

    private let backgroundView = BackGroundView()
    private let helpView = HelpAppView.shared
    var result: Int = 0
    var mode: QuizHardMode = .easy

    private lazy var completedViewImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
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
        view.addSubview(backToButton)
        view.addSubview(completedViewImage)
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        completedViewImage.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.leading.trailing.equalToSuperview().inset(15)
            make.bottom.equalTo(backToButton.snp.top).inset(-20)
        }
        backToButton.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.leading.trailing.equalToSuperview().inset(30)
            make.bottomMargin.equalToSuperview().inset(15)
        }
        print(result)
        switch mode {
        case .easy:
            UserDefaults.standard.setValue(result, forKey: JesterTvistData.quiz_easy.value)
            completedViewImage.image = UIImage(named: "easy_completed_image")
        case .medium:
            UserDefaults.standard.setValue(result, forKey: JesterTvistData.quiz_medium.value)
            completedViewImage.image = UIImage(named: "medium_completed_image")
        case .hard:
            UserDefaults.standard.setValue(result, forKey: JesterTvistData.quiz_hard.value)
            completedViewImage.image = UIImage(named: "harrd_completed_image")
        }
    }
    @objc func tabButton(_ sender: UIButton) {
        switch sender.tag {
            case 1:
            navigationController?.popToRootViewController(animated: false)
        default:
            break
        }
    }
}
