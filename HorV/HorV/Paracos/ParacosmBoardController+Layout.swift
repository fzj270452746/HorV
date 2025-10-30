import UIKit

extension ParacosmBoardController {

    func configureBackdrop() {
        let bg = backdropView
        bg.contentMode = .scaleAspectFill
        bg.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bg)
        veilView.backgroundColor = UIColor.black.withAlphaComponent(0.28)
        veilView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(veilView)
        NSLayoutConstraint.activate([
            bg.topAnchor.constraint(equalTo: view.topAnchor),
            bg.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bg.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bg.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            veilView.topAnchor.constraint(equalTo: view.topAnchor),
            veilView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            veilView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            veilView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func configureHeader() {
        scoreLabel.textColor = .white
        scoreLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 18, weight: .bold)
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreValue = 0
        view.addSubview(scoreLabel)
        countdownLabel.textColor = .white
        countdownLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 18, weight: .bold)
        countdownLabel.translatesAutoresizingMaskIntoConstraints = false
        countdownLabel.text = "60s"
        view.addSubview(countdownLabel)
        let g = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: g.topAnchor, constant: 8),
            scoreLabel.centerXAnchor.constraint(equalTo: g.centerXAnchor),
            countdownLabel.centerYAnchor.constraint(equalTo: scoreLabel.centerYAnchor),
            countdownLabel.trailingAnchor.constraint(equalTo: g.trailingAnchor, constant: -16)
        ])
    }

    func configureGrid() {
        let tiles = suit.tiles
        let grid = UIStackView()
        grid.axis = .vertical
        grid.spacing = 12
        grid.alignment = .center
        grid.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(grid)

        let g = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            grid.centerXAnchor.constraint(equalTo: g.centerXAnchor),
            grid.centerYAnchor.constraint(equalTo: g.centerYAnchor)
        ])

        tileMatrix.removeAll()
        for _ in 0..<gridSize {
            let row = UIStackView()
            row.axis = .horizontal
            row.spacing = 12
            row.alignment = .center
            grid.addArrangedSubview(row)

            var rowArray: [UIButton] = []
            for _ in 0..<gridSize {
                let button = UIButton(type: .system)
                button.translatesAutoresizingMaskIntoConstraints = false
                let sample = tiles.randomElement() ?? tiles[0]
                button.setBackgroundImage(sample.horvimage, for: .normal)
                button.layer.cornerRadius = 10
                button.layer.masksToBounds = true
                button.widthAnchor.constraint(equalTo: button.heightAnchor, multiplier: 0.72).isActive = true
                button.heightAnchor.constraint(equalToConstant: idealTileSide()).isActive = true
                button.tag = sample.horValueInt
                row.addArrangedSubview(button)
                rowArray.append(button)
            }
            tileMatrix.append(rowArray)
        }
    }

    func idealTileSide() -> CGFloat {
        let base: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 130 : 92
        return gridSize == 4 ? base * 0.88 : base
    }

    func configureSelectors() {
        // Create individual buttons so they can align with rows/cols
        rowButtons.forEach { $0.removeFromSuperview() }
        colButtons.forEach { $0.removeFromSuperview() }
        rowButtons.removeAll()
        colButtons.removeAll()

        // For each row: vertically align button centerY with the row's first tile
        for i in 0..<gridSize {
            guard let anchorTile = tileMatrix[i].first else { continue }
            let rb = selectorButton(title: "Row \(i+1)")
            rb.tag = 1_000 + i
            rb.addTarget(self, action: #selector(selectRow(_:)), for: .touchUpInside)
            rb.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(rb)
            NSLayoutConstraint.activate([
                rb.centerYAnchor.constraint(equalTo: anchorTile.centerYAnchor),
                rb.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
            ])
            rowButtons.append(rb)
        }

        // For each column: horizontally align button centerX with that column's tile, and move closer to grid (below header)
        for j in 0..<gridSize {
            guard let anchorTile = tileMatrix.first?[j] else { continue }
            let cb = selectorButton(title: "Col \(j+1)")
            cb.tag = 2_000 + j
            cb.addTarget(self, action: #selector(selectCol(_:)), for: .touchUpInside)
            cb.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(cb)
            NSLayoutConstraint.activate([
                cb.centerXAnchor.constraint(equalTo: anchorTile.centerXAnchor),
                cb.bottomAnchor.constraint(equalTo: anchorTile.topAnchor, constant: -15)
            ])
            colButtons.append(cb)
        }
    }

    func rerollTiles() {
        let tiles = suit.tiles
        for r in 0..<gridSize {
            for c in 0..<gridSize {
                let sample = tiles.randomElement() ?? tiles[0]
                let btn = tileMatrix[r][c]
                btn.setBackgroundImage(sample.horvimage, for: .normal)
                btn.tag = sample.horValueInt
            }
        }
    }

    func selectorButton(title: String) -> UIButton {
        let b = UIButton(type: .system)
        b.setTitle(title, for: .normal)
        b.setTitleColor(.white, for: .normal)
        b.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.22)
        b.layer.cornerRadius = 10
        b.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        b.contentEdgeInsets = UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 10)
        return b
    }
}


