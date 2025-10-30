import UIKit

final class HomeViewController: UIViewController {

    let backdropView = UIImageView(image: UIImage(named: "hvImage"))
    let veilView = UIView()

    let titleLabel = UILabel()
    let modeThreeButton = UIButton(type: .system)
    let modeFourButton = UIButton(type: .system)
    let rulesButton = UIButton(type: .system)
    let suitButton = UIButton(type: .system)
    let historyButton = UIButton(type: .system)

    var currentSuit: SuitariumKind = .bamboo {
        didSet { updateSuitButtonTitle() }
    }

    let ledger = LedgerVault()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureAppearance()
        configureLayout()
        configureNavigation()
    }
}


