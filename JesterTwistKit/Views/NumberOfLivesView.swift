
import UIKit
import SnapKit

final class NumberOfLivesView: UIView {
    
    var countLive: Int = 0 {
        didSet {
            switch countLive {
            case 0:
                setStackView([createImageView("no_live_image"), createImageView("no_live_image"), createImageView("no_live_image")])
            case 1:
                setStackView([createImageView("live_image"), createImageView("no_live_image"), createImageView("no_live_image")])
            case 2:
                setStackView([createImageView("live_image"), createImageView("live_image"), createImageView("no_live_image")])
            case 3:
                setStackView([createImageView("live_image"), createImageView("live_image"), createImageView("live_image")])
            default:
                break
            }
        }
    }
    init() {
        super.init(frame: .zero)
        setStackView([createImageView("live_image"), createImageView("live_image"), createImageView("live_image")])
    }
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setStackView(_ data: [UIImageView]) {
        let view = UIStackView(arrangedSubviews: data)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.distribution = .fillEqually
        view.axis = .horizontal
        view.spacing = 3
        
        addSubview(view)
        view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    private func createImageView(_ named: String) -> UIImageView {
        let view = UIImageView()
        view.image = UIImage(named: named)
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        return view
    }
}
