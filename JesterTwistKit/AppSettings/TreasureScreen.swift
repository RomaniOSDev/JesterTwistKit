
import UIKit
import SnapKit

class TreasureScreen: UIViewController {

    private let backgroundView = BackGroundView()
    private let helpView = HelpAppView.shared

    private lazy var topViewImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "treasure__image")
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        let view = UICollectionView(frame: .zero,
                                   collectionViewLayout: layout)
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = .clear
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        view.register(CollectionCell.self,
                      forCellWithReuseIdentifier: "TreasureCell")
        view.delegate = self
        view.dataSource = self
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
        view.addSubview(topViewImage)
        view.addSubview(collectionView)
        view.addSubview(backToButton)
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        topViewImage.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.leading.trailing.equalToSuperview().inset(15)
            
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(topViewImage.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(backToButton.snp.top)
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
extension TreasureScreen: UICollectionViewDelegateFlowLayout,
                              UICollectionViewDelegate,
                                UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        treasureData.count
    }
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TreasureCell",
                                                            for: indexPath) as? CollectionCell else { return UICollectionViewCell() }
        let data = treasureData[indexPath.item]
        if data.done == true {
            cell.setGame(data.icon)
        } else {
            cell.setGame("not_\(data.icon)")
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 80) / 3
        return CGSize(width: width,
                      height: width)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10,
                            left: 0,
                            bottom: 10,
                            right: 0)
    }
}

let saveValue = UserDefaults.standard
struct TreasureData {
    let icon: String
    var done: Bool?
}
let treasureData: [TreasureData] = [.init(icon: "comleted_1",
                                          done: saveValue.bool(forKey: "isCompleted_0")),
                                    .init(icon: "comleted_2",
                                          done: saveValue.bool(forKey: "isCompleted_1")),
                                    .init(icon: "comleted_3",
                                          done: saveValue.bool(forKey: "isCompleted_2")),
                                    .init(icon: "comleted_4",
                                          done: saveValue.bool(forKey: "isCompleted_3")),
                                    .init(icon: "comleted_5",
                                          done: saveValue.bool(forKey: "isCompleted_4")),
                                    .init(icon: "comleted_6",
                                          done: saveValue.bool(forKey: "isCompleted_5")),
                                    .init(icon: "comleted_7",
                                          done: saveValue.bool(forKey: "isCompleted_6")),
                                    .init(icon: "comleted_8",
                                          done: saveValue.bool(forKey: "isCompleted_7")),
                                    .init(icon: "comleted_9",
                                          done: saveValue.bool(forKey: "isCompleted_8")),
                                    .init(icon: "comleted_10",
                                          done: saveValue.bool(forKey: "isCompleted_9")),
                                    .init(icon: "comleted_11",
                                          done: saveValue.bool(forKey: "isCompleted_10")),
                                    .init(icon: "comleted_12",
                                          done: saveValue.bool(forKey: "isCompleted_11")),
                                    .init(icon: "comleted_13",
                                          done: saveValue.bool(forKey: "isCompleted_12")),
                                    .init(icon: "comleted_14",
                                          done: saveValue.bool(forKey: "isCompleted_13")),
                                    .init(icon: "comleted_15",
                                          done: saveValue.bool(forKey: "isCompleted_14"))]

