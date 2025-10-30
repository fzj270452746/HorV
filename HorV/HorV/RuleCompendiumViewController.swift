import UIKit

final class RuleCompendiumViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Gradient background to match the game's look
        let bg = SiroccoGradientView()
        bg.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bg)
        NSLayoutConstraint.activate([
            bg.topAnchor.constraint(equalTo: view.topAnchor),
            bg.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bg.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bg.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        title = "How to Play"
        // 设置导航栏标题颜色为白色
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeSelf))
        
        let text = UITextView()
        text.isEditable = false
        text.backgroundColor = UIColor.white.withAlphaComponent(0.06)
        text.textColor = .white
        text.font = UIFont.systemFont(ofSize: 16)
        text.text = """
        Welcome to Mahjong — H & V!
        
        Goal:
        Pick the row or column whose three or four tiles sum to the maximum.
        
        Modes:
        - 3x3 grid (3 tiles per line)
        - 4x4 grid (4 tiles per line)
        
        Rules:
        1) Tap Row/Col buttons to choose one line.
        2) Correct choice: gain points. Wrong choice: lose points.
        3) Use Suit button to switch among Bamboo, Dots, Characters.
        """
        text.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(text)
        NSLayoutConstraint.activate([
            text.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            text.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            text.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            text.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12)
        ])
    }
    
    @objc private func closeSelf() {
        dismiss(animated: true)
    }
}


