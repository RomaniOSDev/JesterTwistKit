
import UIKit
import SnapKit

enum QuizHardMode {
    case easy
    case medium
    case hard
}

class QuizAcreen: UIViewController {

    private let backgroundView = BackGroundView()
    private let helpView = HelpAppView.shared
    var mode: QuizHardMode = .easy
    private var result = 0
    private var indexQuestion: Int = 0
    private var data: [Items] = []
    
    private lazy var closeoButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tag = 1
        view.setBackgroundImage(UIImage(named: "close_image"), for: .normal)
        view.addTarget(self, action: #selector(tabButton), for: .touchUpInside)
        return view
    }()
    private lazy var topQuizImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "joker_image")
        return view
    }()
    private lazy var quizHeaderTitle: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .white
        view.textAlignment = .center
        view.numberOfLines = 0
        view.font = .systemFont(ofSize: 30, weight: .black)
        return view
    }()

    private var buttonStack: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.distribution = .fillEqually
        view.axis = .vertical
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        print(mode)
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(backgroundView)
        view.addSubview(topQuizImage)
        view.addSubview(closeoButton)
        view.addSubview(quizHeaderTitle)
        
        view.addSubview(buttonStack)
        
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        closeoButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.equalTo(15)
            make.width.equalTo(45)
            make.height.equalTo(40)
        }
        topQuizImage.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    
        quizHeaderTitle.snp.makeConstraints { make in
            make.top.equalTo(topQuizImage.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.greaterThanOrEqualTo(20)
        }
        
        buttonStack.snp.makeConstraints { make in
            make.top.equalTo(quizHeaderTitle.snp.bottom).offset(20)
            make.left.equalTo(10)
            make.right.equalToSuperview().inset(20)
            make.height.greaterThanOrEqualTo(100)
            make.bottomMargin.equalToSuperview().inset(20)
        }
        
        
        let quizData = helpView.setQuizBaseData()?.quize
        switch mode {
        case .easy:
            data = quizData?.easy ?? []
        case .medium:
            data = quizData?.medium ?? []
        case .hard:
            data = quizData?.hard ?? []
        }
        
        // Проверяем, что массив данных не пустой
        guard !data.isEmpty, indexQuestion < data.count else {
            print("Ошибка: Нет данных для викторины или неверный индекс")
            // Можно показать алерт или вернуться назад
            navigationController?.popViewController(animated: true)
            return
        }
        
        quizHeaderTitle.text = data[indexQuestion].question
        setupeAnswerButtonView()
    }
    private func setupeAnswerButtonView() {
        // Проверяем границы массива перед обращением
        guard indexQuestion < data.count else {
            print("Ошибка: Индекс вопроса выходит за границы массива")
            return
        }
        
        let answer = data[indexQuestion].answers
        buttonStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        answer.enumerated().forEach { index, data in
            let view = AnswerButtons()
            view.buttonView.isUserInteractionEnabled = true
            view.buttonView.tag = index
            view.configureButton(text: data,
                                 index: self.data[indexQuestion].correctIndex)
            
            view.didSelectAnswer = { [weak self] answerID in
                view.buttonView.isUserInteractionEnabled = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5 ) { [weak self] in
                    guard let self else { return }
                    
                    // Проверяем правильность ответа для текущего вопроса
                    if indexQuestion < self.data.count, answerID == self.data[indexQuestion].correctIndex {
                        result += 1
                    }
                    
                    if indexQuestion < self.data.count - 1 {
                        indexQuestion += 1
                        // Дополнительная проверка после увеличения индекса
                        guard indexQuestion < self.data.count else {
                            showResult()
                            return
                        }
                        quizHeaderTitle.text = self.data[indexQuestion].question
                        setupeAnswerButtonView()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5 ) {
                            view.stackView.isUserInteractionEnabled = true
                        }
                    } else {
                        showResult()
                    }
                    
                }
            }
            buttonStack.addArrangedSubview(view.buttonView)
        }
    }
    func showResult() {
        let controller = ResultQuizScreen()
        controller.result = result
        navigationController?.pushViewController(controller, animated: false)
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

