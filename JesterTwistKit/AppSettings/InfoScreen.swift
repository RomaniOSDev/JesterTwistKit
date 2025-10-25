
import UIKit
import SnapKit

class InfoScreen: UIViewController {

    private let backgroundView = BackGroundView()
    private let helpView = HelpAppView.shared

    private lazy var infoViewImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "info_view_image")
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
        view.addSubview(infoViewImage)
        view.addSubview(backToButton)
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        infoViewImage.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.leading.trailing.equalToSuperview().inset(15)
            make.bottom.equalTo(backToButton.snp.top).inset(-20)
        }
        backToButton.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.leading.trailing.equalToSuperview().inset(30)
            make.bottomMargin.equalToSuperview().inset(15)
        }
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
