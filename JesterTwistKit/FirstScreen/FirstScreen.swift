
import UIKit
import SnapKit

class FirstScreen: UIViewController {

    private let backgroundView = BackGroundView()
    private let helpView = HelpAppView.shared
    
    private let loadImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "comleted_14")
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(backgroundView)
        helpView.getQuizBaseData()
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        view.addSubview(loadImageView)
        loadImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(80)
        }
        if firstLaunch == false {
            UserDefaults.standard.setValue(true, forKey: JesterTvistData.firstLaunch.value)
            UserDefaults.standard.setValue(0, forKey: JesterTvistData.resultTwist.value)
            UserDefaults.standard.setValue(0, forKey: JesterTvistData.quiz_easy.value)
            UserDefaults.standard.setValue(0, forKey: JesterTvistData.quiz_medium.value)
            UserDefaults.standard.setValue(0, forKey: JesterTvistData.quiz_hard.value)
        }
        startLoader()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.stopLoader()
            let screen = BaseGameView()
            self.navigationController?.viewControllers = [screen]
        }
    }
    private func startLoader() {
        let rotation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.fromValue = 0.0
        rotation.toValue = CGFloat.pi * 2.0
        rotation.duration = 1.0
        rotation.repeatCount = .infinity
        loadImageView.layer.add(rotation, forKey: "rotationAnimation")
    }
    private func stopLoader() {
        loadImageView.layer.removeAnimation(forKey: "rotationAnimation")
    }
}
