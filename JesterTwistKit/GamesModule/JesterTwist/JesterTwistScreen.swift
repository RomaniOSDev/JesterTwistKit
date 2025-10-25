
import UIKit
import SnapKit

class JesterTwistScreen: UIViewController {

    private let backgroundView = BackGroundView()
    private let helpView = HelpAppView.shared
    private let numberOfLivesView = NumberOfLivesView()
    
    private var numberOfLives = 3
    private var score = 0
    private var isGameRunning = false
    private var fallingImageViews: [UIImageView] = []
    private var displayLink: CADisplayLink?

    private lazy var closeoButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tag = 1
        view.setBackgroundImage(UIImage(named: "close_image"), for: .normal)
        view.addTarget(self, action: #selector(tabButton), for: .touchUpInside)
        return view
    }()
    private lazy var scoreImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "scrore_image")
        return view
    }()
    private lazy var scoreTitle: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .black
        view.textAlignment = .center
        view.font = UIFont.systemFont(ofSize: 37, weight: .bold)
        return view
    }()
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(backgroundView)
        view.addSubview(closeoButton)
        view.addSubview(scoreImage)
        scoreImage.addSubview(scoreTitle)
        
        view.addSubview(numberOfLivesView)
        numberOfLivesView.countLive = numberOfLives
        
        
        view.addSubview(contentView)
        
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        closeoButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.equalTo(15)
            make.width.equalTo(45)
            make.height.equalTo(40)
        }
        scoreImage.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(-10)
            make.centerX.equalToSuperview()
            make.height.equalTo(100)
            make.width.equalTo(230)
        }
//        scoreTitle.backgroundColor = .green
//        scoreTitle.alpha = 0.5
        scoreTitle.snp.makeConstraints { make in
            make.left.equalTo(scoreImage.snp.centerX)
            make.right.equalToSuperview().inset(15)
            make.height.equalTo(40)
            make.centerY.equalToSuperview().offset(10)
        }
        numberOfLivesView.snp.makeConstraints { make in
            make.top.equalTo(closeoButton.snp.bottom).offset(15)
            make.left.equalTo(15)
            make.right.equalTo(scoreImage.snp.left).inset(-5)
            make.height.equalTo(25)
        }
        contentView.snp.makeConstraints { make in
            make.top.equalTo(scoreImage.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview()
            make.bottomMargin.equalToSuperview()
        }
        
        
        scoreTitle.text = "0"
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        startGame()
    }
    private func startGame() {
        isGameRunning = true
        setupDisplayLink()
    }
    private func stopGame() {
        isGameRunning = false
        displayLink?.invalidate()
        displayLink = nil
        fallingImageViews.forEach { $0.removeFromSuperview() }
        fallingImageViews.removeAll()
    }
    private func setupDisplayLink() {
        displayLink = CADisplayLink(target: self, selector: #selector(update))
        displayLink?.add(to: .main, forMode: .common)
    }
    @objc private func update() {
        if Int.random(in: 0...100) < 10 {
            createFallingImage()
        }
        updateFallingImages()
    }
        
    private func createFallingImage() {
        guard let randomData = jesterTwistData.randomElement() else { return }
        let imageView = UIImageView()
        imageView.image = UIImage(named: randomData.imageString)
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.tag = randomData.access ? 1 : 0
        let size: CGFloat = randomData.access ? 60 : 70
        imageView.frame = CGRect(
            x: CGFloat.random(in: 0...(view.bounds.width - size)),
            y: -size,
            width: size,
            height: size
        )
        if !randomData.access {
//            imageView.layer.borderWidth = 3
//            imageView.layer.borderColor = UIColor.red.cgColor
            imageView.layer.cornerRadius = imageView.frame.width / 2
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
        imageView.addGestureRecognizer(tapGesture)
        view.addSubview(imageView)
        fallingImageViews.append(imageView)
    }
        
    private func updateFallingImages() {
        var indicesToRemove: [Int] = []
        for (index, imageView) in fallingImageViews.enumerated() {
            imageView.frame.origin.y += 5
            if imageView.frame.origin.y > view.bounds.height {
                indicesToRemove.append(index)
                imageView.removeFromSuperview()
            }
        }
        for index in indicesToRemove.reversed() {
            fallingImageViews.remove(at: index)
        }
    }
    @objc private func imageTapped(_ sender: UITapGestureRecognizer) {
        guard let imageView = sender.view as? UIImageView else { return }
        let hasAccess = imageView.tag == 1
        
        if hasAccess {
            handleCorrectTap(on: imageView)
        } else {
            handleWrongTap(on: imageView)
        }
        scoreTitle.text = String(score)
    }
        
    private func handleCorrectTap(on imageView: UIImageView) {
        score += 1
        if score > 0 {
            UserDefaults.standard.setValue(score, forKey: JesterTvistData.resultTwist.value)
        }
        UIView.animate(withDuration: 0.2, animations: {
            imageView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            imageView.alpha = 0
        }) { _ in
            self.removeImageView(imageView)
        }
    }
        
    private func handleWrongTap(on imageView: UIImageView) {
        score = 0
        UserDefaults.standard.setValue(score, forKey: JesterTvistData.resultTwist.value)
        numberOfLives -= 1
        scoreTitle.textColor = .systemRed
        numberOfLivesView.countLive = numberOfLives
        UIView.animate(withDuration: 0.3) {
            self.scoreTitle.transform = CGAffineTransform(scaleX: 1.7, y: 1.7)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.scoreTitle.textColor = .black
            UIView.animate(withDuration: 0.3) {
                self.scoreTitle.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
        }
        if numberOfLives == 0 {
            self.fallingImageViews.forEach { image in
                self.createExplosionEffect(at: image.center)
                self.pushNearbyImages(from: image.center)
                UIView.animate(withDuration: 0.3, animations: {
                    image.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                    image.alpha = 0
                }) { _ in
                    self.removeImageView(image)
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.navigationController?.popViewController(animated: false)
//                let vc = ResultView_JT()
//                vc.isWin = false
//                self.navigationController?.pushViewController(vc, animated: false)
            }
        }
        
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
    
        UIView.animate(withDuration: 0.1, animations: {
            imageView.transform = CGAffineTransform(scaleX: 2,
                                                    y: 2)
        }) { _ in
            // Эффект разлетающихся частиц
            self.createExplosionEffect(at: imageView.center)
            self.pushNearbyImages(from: imageView.center)
            UIView.animate(withDuration: 0.3, animations: {
                imageView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                imageView.alpha = 0
            }) { _ in
                self.removeImageView(imageView)
            }
        }
    }
    private func pushNearbyImages(from explosionCenter: CGPoint) {
        let explosionRadius: CGFloat = 150
        let explosionForce: CGFloat = 30
        for nearbyImageView in fallingImageViews {
            let distance = hypot(
                nearbyImageView.center.x - explosionCenter.x,
                nearbyImageView.center.y - explosionCenter.y
            )
            if distance < explosionRadius && nearbyImageView.superview != nil {
                let dx = nearbyImageView.center.x - explosionCenter.x
                let dy = nearbyImageView.center.y - explosionCenter.y
                let distance = max(1, distance)
                let force = explosionForce * (1 - distance/explosionRadius)
                let velocityX = (dx / distance) * force
                let velocityY = (dy / distance) * force
                UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                    nearbyImageView.center.x += velocityX
                    nearbyImageView.center.y += velocityY
                    nearbyImageView.transform = nearbyImageView.transform.rotated(by: .pi / 4 * (velocityX > 0 ? 1 : -1))
                })
            }
        }
    }
    private func createExplosionEffect(at center: CGPoint) {
        let particleCount = 15
        for _ in 0..<particleCount {
            let particle = UIView()
            particle.backgroundColor = .red
            particle.frame = CGRect(x: center.x, y: center.y, width: 8, height: 8)
            particle.layer.cornerRadius = 4
            view.addSubview(particle)
            let angle = CGFloat.random(in: 0...(2 * .pi))
            let distance = CGFloat.random(in: 20...80)
            let duration = Double.random(in: 0.5...1.0)
            
            UIView.animate(withDuration: duration, animations: {
                particle.center.x += cos(angle) * distance
                particle.center.y += sin(angle) * distance
                particle.alpha = 0
                particle.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            }) { _ in
                particle.removeFromSuperview()
            }
        }
    }
    private func removeImageView(_ imageView: UIImageView) {
        imageView.removeFromSuperview()
        if let index = fallingImageViews.firstIndex(of: imageView) {
            fallingImageViews.remove(at: index)
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
