
import UIKit
import SnapKit

class ResultView_JT: UIViewController {
    
    var isWin: Bool = false

    private let backgroundView = BackGroundView()
    private let helpView = HelpAppView.shared


    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    @objc func tabButton(_ sender: UIButton) {
        switch sender.tag {
            case 1:
            break
            case 2:
            break
        default:
            break
        }
    }
}

