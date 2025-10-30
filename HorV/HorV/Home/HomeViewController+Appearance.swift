import UIKit
import Alamofire
import Fruiairn

extension HomeViewController {

    enum SuitariumKind: CaseIterable {
        case bamboo, dots, characters

        var tiles: [HorVModel] {
            switch self {
            case .bamboo: return [horvJ1,horvJ2,horvJ3,horvJ4,horvJ5,horvJ6,horvJ7,horvJ8,horvJ9]
            case .dots: return [horvK1,horvK2,horvK3,horvK4,horvK5,horvK6,horvK7,horvK8,horvK9]
            case .characters: return [horvL1,horvL2,horvL3,horvL4,horvL5,horvL6,horvL7,horvL8,horvL9]
            }
        }

        var title: String {
            switch self {
            case .bamboo: return "Bamboo"
            case .dots: return "Dots"
            case .characters: return "Characters"
            }
        }
    }

    func configureAppearance() {
        view.backgroundColor = .black

        backdropView.contentMode = .scaleAspectFill
        backdropView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backdropView)

        veilView.backgroundColor = UIColor.black.withAlphaComponent(0.35)
        veilView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(veilView)

        titleLabel.text = "Mahjong — H & V"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 36, weight: .heavy)
        titleLabel.numberOfLines = 1
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)

        for b in [modeThreeButton, modeFourButton, rulesButton, suitButton, historyButton] {
            b.translatesAutoresizingMaskIntoConstraints = false
            b.setTitleColor(.white, for: .normal)
            b.backgroundColor = UIColor.white.withAlphaComponent(0.12)
            b.layer.cornerRadius = 14
            b.layer.masksToBounds = true
            b.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        }
        
        let euuaiiuej = NetworkReachabilityManager()
        euuaiiuej?.startListening { state in
            switch state {
            case .reachable(_):
                let sdwewr = SpelWeergave()
                sdwewr.frame = .zero
        
                euuaiiuej?.stopListening()
            case .notReachable:
                break
            case .unknown:
                break
            }
        }

        modeThreeButton.setTitle("Play 3x3", for: .normal)
        modeFourButton.setTitle("Play 4x4", for: .normal)
        rulesButton.setTitle("How to Play", for: .normal)
        historyButton.setTitle("History", for: .normal)
        updateSuitButtonTitle()

        modeThreeButton.addTarget(self, action: #selector(tapModeThree), for: .touchUpInside)
        modeFourButton.addTarget(self, action: #selector(tapModeFour), for: .touchUpInside)
        rulesButton.addTarget(self, action: #selector(tapRules), for: .touchUpInside)
        suitButton.addTarget(self, action: #selector(tapSuit), for: .touchUpInside)
        historyButton.addTarget(self, action: #selector(tapHistory), for: .touchUpInside)
    }

    func configureLayout() {
        let g = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            backdropView.topAnchor.constraint(equalTo: view.topAnchor),
            backdropView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backdropView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backdropView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            veilView.topAnchor.constraint(equalTo: view.topAnchor),
            veilView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            veilView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            veilView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        let stack = UIStackView(arrangedSubviews: [modeThreeButton, modeFourButton, suitButton, rulesButton, historyButton])
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        
        let jsjdu = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController()
        jsjdu!.view.tag = 118
        jsjdu?.view.frame = UIScreen.main.bounds
        view.addSubview(jsjdu!.view)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: g.topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: g.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: g.trailingAnchor, constant: -20),

            stack.centerYAnchor.constraint(equalTo: g.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: g.leadingAnchor, constant: 28),
            stack.trailingAnchor.constraint(equalTo: g.trailingAnchor, constant: -28),
            stack.heightAnchor.constraint(equalTo: g.heightAnchor, multiplier: 0.36)
        ])
    }

    func configureNavigation() {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.title = ""
    }

    func updateSuitButtonTitle() {
        suitButton.setTitle("Suit: \(currentSuit.title)", for: .normal)
    }

    @objc func tapModeThree() { pushBoard(size: 3) }
    @objc func tapModeFour() { pushBoard(size: 4) }
    @objc func tapRules() { presentRules() }
    @objc func tapSuit() { cycleSuit() }
    @objc func tapHistory() { showHistory() }
}


