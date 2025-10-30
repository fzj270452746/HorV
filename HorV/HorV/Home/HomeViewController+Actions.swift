import UIKit

extension HomeViewController {

    func pushBoard(size: Int) {
        let controller = ParacosmBoardController(grid: size, suit: currentSuit, ledger: ledger)
        navigationController?.pushViewController(controller, animated: true)
    }

    func presentRules() {
        let guide = RuleCompendiumViewController()
        let nav = UINavigationController(rootViewController: guide)
        nav.modalPresentationStyle = UIModalPresentationStyle.formSheet
        present(nav, animated: true)
    }

    func cycleSuit() {
        let all = SuitariumKind.allCases
        if let idx = all.firstIndex(of: currentSuit) {
            let next = all[(idx + 1) % all.count]
            currentSuit = next
        }
    }

    func showHistory() {
        let vc = ChronicleViewController(ledger: ledger)
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = UIModalPresentationStyle.pageSheet
        present(nav, animated: true)
    }
}


