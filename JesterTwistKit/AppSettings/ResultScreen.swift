
import UIKit
import SnapKit

class ResultScreen: UIViewController {

    private let backgroundView = BackGroundView()
    private let helpView = HelpAppView.shared


    private lazy var twistResultImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "TWIST_RESULT_image")
        return view
    }()
    private lazy var twistResultTitle: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .black
        view.textAlignment = .center
        view.font = .systemFont(ofSize: 60, weight: .black)
        return view
    }()
    
    private lazy var quizResultImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "quiz_result_image")
        return view
    }()
    private lazy var quiz_E_ResultTitle: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .black
        view.textAlignment = .center
        view.font = .systemFont(ofSize: 30, weight: .black)
        return view
    }()
    private lazy var quiz_M_ResultTitle: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .black
        view.textAlignment = .center
        view.font = .systemFont(ofSize: 30, weight: .black)
        return view
    }()
    private lazy var quiz_H_ResultTitle: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .black
        view.textAlignment = .center
        view.font = .systemFont(ofSize: 30, weight: .black)
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
        view.addSubview(twistResultImage)
        twistResultImage.addSubview(twistResultTitle)
        view.addSubview(quizResultImage)
        quizResultImage.addSubview(quiz_E_ResultTitle)
        quizResultImage.addSubview(quiz_M_ResultTitle)
        quizResultImage.addSubview(quiz_H_ResultTitle)
        
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        twistResultImage.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.leading.trailing.equalToSuperview().inset(30)
            make.bottom.equalTo(quizResultImage.snp.top).inset(-15)
        }
//        twistResultTitle.backgroundColor = .green
//        twistResultTitle.alpha = 0.5
        twistResultTitle.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(50)
            make.height.greaterThanOrEqualTo(35)
            make.centerY.equalToSuperview().offset(75)
        }
        
        quizResultImage.snp.makeConstraints { make in
            make.top.equalTo(backgroundView.snp.centerY).offset(-50)
            make.leading.trailing.equalToSuperview().inset(30)
            make.bottom.equalTo(backToButton.snp.top).inset(-15)
        }
        backToButton.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.leading.trailing.equalToSuperview().inset(30)
            make.bottomMargin.equalToSuperview().inset(15)
        }
        
//        quiz_E_ResultTitle.backgroundColor = .green
//        quiz_E_ResultTitle.alpha = 0.5
        quiz_E_ResultTitle.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(50)
            make.left.equalTo(backgroundView.snp.centerX)
            make.height.greaterThanOrEqualTo(20)
            make.centerY.equalToSuperview()
        }
//        quiz_M_ResultTitle.backgroundColor = .green
//        quiz_M_ResultTitle.alpha = 0.5
        quiz_M_ResultTitle.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(50)
            make.left.equalTo(backgroundView.snp.centerX)
            make.height.greaterThanOrEqualTo(20)
            make.top.equalTo(quiz_E_ResultTitle.snp.bottom).offset(30)
        }
        
//        quiz_H_ResultTitle.backgroundColor = .green
//        quiz_H_ResultTitle.alpha = 0.5
        quiz_H_ResultTitle.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(50)
            make.left.equalTo(backgroundView.snp.centerX)
            make.height.greaterThanOrEqualTo(20)
            make.top.equalTo(quiz_M_ResultTitle.snp.bottom).offset(30)
        }
        
        
        if helpView.isNewDevice() == false {
            twistResultTitle.snp.updateConstraints { make in
                make.centerY.equalToSuperview().offset(65)
            }
            quiz_M_ResultTitle.snp.updateConstraints { make in
                make.top.equalTo(quiz_E_ResultTitle.snp.bottom).offset(18)
            }
            quiz_H_ResultTitle.snp.updateConstraints { make in
                make.top.equalTo(quiz_M_ResultTitle.snp.bottom).offset(18)
            }
        }
        
        twistResultTitle.text = String(UserDefaults.standard.integer(forKey: JesterTvistData.resultTwist.value))
        quiz_E_ResultTitle.text = "\(UserDefaults.standard.integer(forKey: JesterTvistData.quiz_easy.value))/10"
        quiz_M_ResultTitle.text = "\(UserDefaults.standard.integer(forKey: JesterTvistData.quiz_medium.value))/10"
        quiz_H_ResultTitle.text = "\(UserDefaults.standard.integer(forKey: JesterTvistData.quiz_hard.value))/10"
    }
    @objc func tabButton(_ sender: UIButton) {
        switch sender.tag {
            case 1:
            navigationController?.popViewController(animated: false)
            case 2:
            break
        default:
            break
        }
    }
}

