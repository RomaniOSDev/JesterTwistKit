
import UIKit
import SnapKit

final class BackGroundView: UIView {

    private var backgroundView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.image = UIImage(named: "viewBackgroundImage")
        return view
    }()
    init() {
        super.init(frame: .zero)
        addSubview(backgroundView)
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    func setImage(_ image: UIImage?) {
        UIView.transition(with: backgroundView,
                          duration: 1.0,
                          options: .transitionCrossDissolve,
                          animations: {
            self.backgroundView.image = image
        })
    }
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
