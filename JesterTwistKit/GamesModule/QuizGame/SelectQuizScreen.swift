
import UIKit
import SnapKit

class SelectQuizScreen: UIViewController {

    private let backgroundView = BackGroundView()
    private let helpView = HelpAppView.shared
    private let images = [UIImage(named: "ease_image"), UIImage(named: "medium_image"), UIImage(named: "hard_image")]

    private lazy var topQuizImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "select_level_image")
        return view
    }()
    
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
        view.tag = 4
        view.setBackgroundImage(UIImage(named: "back_button_image"), for: .normal)
        view.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(backgroundView)
        view.addSubview(topQuizImage)
        view.addSubview(stackView)
        view.addSubview(backToButton)
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        topQuizImage.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        stackView.snp.makeConstraints { make in
            make.top.equalTo(topQuizImage.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
        }
        backToButton.snp.makeConstraints { make in
            make.height.equalTo(60)
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
//        configuration.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 15, bottom: 10, trailing: 15)
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
            switch sender.tag {
            case 0:
                let screen = QuizAcreen()
                screen.mode = .easy
                self.navigationController?.pushViewController(screen, animated: false)
            case 1:
                let screen = QuizAcreen()
                screen.mode = .medium
                self.navigationController?.pushViewController(screen, animated: false)
            case 2:
                let screen = QuizAcreen()
                screen.mode = .hard
                self.navigationController?.pushViewController(screen, animated: false)
            case 4:
                self.navigationController?.popViewController(animated: false)
            default:
                break
            }
        }
    }
}
