import UIKit

extension ParacosmBoardController {

    @objc func selectRow(_ sender: UIButton) {
        let rowIndex = sender.tag - 1_000
        var sum = 0
        for k in 0..<gridSize { sum += tileMatrix[rowIndex][k].tag }
        evaluateSelection(sum: sum, isRow: true, ordinal: rowIndex)
        rerollTiles()
    }

    @objc func selectCol(_ sender: UIButton) {
        let colIndex = sender.tag - 2_000
        var sum = 0
        for r in 0..<gridSize { sum += tileMatrix[r][colIndex].tag }
        evaluateSelection(sum: sum, isRow: false, ordinal: colIndex)
        rerollTiles()
    }

    func evaluateSelection(sum: Int, isRow: Bool, ordinal: Int) {
        let best = computeBestLineSum()
        if sum >= best {
            scoreValue += gridSize == 3 ? 5 : 8
            transientToast(text: "+\(gridSize == 3 ? 5 : 8)", isPositive: true)
            ledger.record(scoreDelta: gridSize == 3 ? 5 : 8, grid: gridSize)
        } else {
            scoreValue -= gridSize == 3 ? 3 : 5
            transientToast(text: "-\(gridSize == 3 ? 3 : 5)", isPositive: false)
            ledger.record(scoreDelta: -(gridSize == 3 ? 3 : 5), grid: gridSize)
        }
    }

    func computeBestLineSum() -> Int {
        var best = 0
        // rows
        for r in 0..<gridSize {
            var s = 0
            for c in 0..<gridSize { s += tileMatrix[r][c].tag }
            best = max(best, s)
        }
        // cols
        for c in 0..<gridSize {
            var s = 0
            for r in 0..<gridSize { s += tileMatrix[r][c].tag }
            best = max(best, s)
        }
        return best
    }

    func transientToast(text: String, isPositive: Bool) {
        let label = UILabel()
        label.text = text
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 40, weight: .heavy)
        label.textColor = isPositive ? .systemGreen : .systemRed
        label.alpha = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        UIView.animate(withDuration: 0.2, animations: { label.alpha = 1 }) { _ in
            UIView.animate(withDuration: 0.6, delay: 0.3, options: [.curveEaseIn], animations: {
                label.alpha = 0
                label.transform = CGAffineTransform(translationX: 0, y: -30)
            }) { _ in
                label.removeFromSuperview()
            }
        }
    }

    func configureBackButton() {
        let back = UIButton(type: .system)
        back.setTitle("‹ Back", for: .normal)
        back.setTitleColor(.white, for: .normal)
        back.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        back.backgroundColor = UIColor.white.withAlphaComponent(0.12)
        back.layer.cornerRadius = 12
        back.contentEdgeInsets = UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 10)
        back.addTarget(self, action: #selector(tapBack), for: .touchUpInside)
        let item = UIBarButtonItem(customView: back)
        navigationItem.leftBarButtonItem = item
    }

    @objc func tapBack() {
        stopCountdown()
        navigationController?.popViewController(animated: true)
    }

    override  func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startCountdown()
    }

    override  func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParent { stopCountdown() }
    }

    private func startCountdown() {
        stopCountdown()
        remainingSeconds = 60
        updateCountdownLabel()
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.remainingSeconds -= 1
            self.updateCountdownLabel()
            if self.remainingSeconds <= 0 {
                self.stopCountdown()
                self.ledger.recordRound(scoreTotal: self.scoreValue, grid: self.gridSize)
                self.promptNewRound()
            }
        }
        RunLoop.main.add(countdownTimer!, forMode: .common)
    }

    private func stopCountdown() {
        countdownTimer?.invalidate()
        countdownTimer = nil
    }

    private func updateCountdownLabel() {
        countdownLabel.text = "\(max(0, remainingSeconds))s"
    }

    private func promptNewRound() {
        let alert = UIAlertController(title: "Time's up", message: "Start a new game?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            self.scoreValue = 0
            self.rerollTiles()
            self.startCountdown()
        }))
        present(alert, animated: true)
    }
}


