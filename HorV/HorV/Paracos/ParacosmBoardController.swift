import UIKit

final class ParacosmBoardController: UIViewController {

    let gridSize: Int
    let suit: HomeViewController.SuitariumKind

    let backdropView = UIImageView(image: UIImage(named: "hvImage"))
    let veilView = UIView()

    var tileMatrix: [[UIButton]] = []
    var rowButtons: [UIButton] = []
    var colButtons: [UIButton] = []

    let scoreLabel = UILabel()
    var scoreValue: Int = 0 { didSet { scoreLabel.text = "Score: \(scoreValue)" } }

    let ledger: LedgerVault

     var countdownLabel = UILabel()
     var countdownTimer: Timer?
     var remainingSeconds: Int = 60

    init(grid: Int, suit: HomeViewController.SuitariumKind, ledger: LedgerVault = .init()) {
        self.gridSize = grid
        self.suit = suit
        self.ledger = ledger
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        configureBackdrop()
        configureHeader()
        configureGrid()
        configureSelectors()
        configureBackButton()
    }
}


