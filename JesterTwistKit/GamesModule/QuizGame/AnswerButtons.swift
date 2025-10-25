
import UIKit
import SnapKit

final class AnswerButtons: UIView {
    
    let helpView = HelpAppView.shared
    var answerIndex = 0
    var didSelectAnswer: ((Int) -> Void)?
    
   var stackView: UIStackView = {
       let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.isUserInteractionEnabled = true
        return view
    }()
    lazy var buttonView: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitleColor(.black,
                           for: .normal)
        view.titleLabel?.font = .systemFont(ofSize: 27,
                                            weight: .bold)
        view.titleLabel?.adjustsFontSizeToFitWidth = true
        view.titleLabel?.minimumScaleFactor = 0.2
        view.titleLabel?.textAlignment = .center
        view.addTarget(self,  action: #selector(tapButton), for: .touchUpInside)
        return view
    }()
    var correctImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "yes_image")
        return view
    }()
    init() {
        super.init(frame: .zero)
        self.addSubview(stackView)
        stackView.addSubview(buttonView)
        buttonView.alpha = 0.0
        buttonView.addSubview(correctImage)
        correctImage.isHidden = true
        
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalToSuperview().inset(20)
            make.left.equalTo(20)
            make.bottom.equalToSuperview()
        }
        buttonView.snp.makeConstraints { make in
            make.height.equalTo(120)
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(40)
        }
        buttonView.titleLabel?.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
        }
        correctImage.snp.makeConstraints { make in
            make.centerY.equalTo(buttonView)
            make.right.equalTo(buttonView.snp.right).inset(-10)
            make.width.height.equalTo(61)
        }
    }
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configureButton(text: String,
                         index: Int) {
        self.answerIndex = index
        buttonView.setBackgroundImage(UIImage(named: "gef_answer_image"),
                                        for: .normal)
        buttonView.setTitle(text, for: .normal)
        switch buttonView.tag {
        case 0:
            buttonView.alpha = 1.0
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2 ) { [weak self] in
                guard let self else { return }
                buttonView.setTitle(text, for: .normal)
            }
        case 1:
            buttonView.alpha = 1.0
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3 ) { [weak self] in
                guard let self else { return }
                buttonView.setTitle(text, for: .normal)
            }
        case 2:
            buttonView.alpha = 1.0
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4 ) { [weak self] in
                guard let self else { return }
                buttonView.setTitle(text, for: .normal)
            }
        default:
            break
        }
    }
    @objc func tapButton(_ sender: UIButton) {
        helpView.quickAnimation(buttonView)
        buttonView.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2 ) { [weak self] in
            guard let self else { return }
            correctImage.isHidden = false
            if answerIndex == sender.tag {
                correctImage.image = UIImage(named: "yes_image")
            } else {
                correctImage.image = UIImage(named: "no_image")
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5 ) { [weak self] in
                guard let self else { return }
                correctImage.isHidden = true
            }
        }
        didSelectAnswer?(sender.tag)
        stackView.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0 ) { [weak self] in
            guard let self else { return }
            buttonView.setBackgroundImage(UIImage(named: "gef_answer_image"), for: .normal) // def
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0 ) { [weak self] in
            guard let self else { return }
            buttonView.isUserInteractionEnabled = true
        }
    }
}
