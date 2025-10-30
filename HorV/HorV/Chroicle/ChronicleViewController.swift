import UIKit

final class ChronicleViewController: UITableViewController {
    private let ledger: LedgerVault
    private var data: [LedgerEntry] = []
    private let emptyLabel = UILabel()

    init(ledger: LedgerVault) {
        self.ledger = ledger
        super.init(style: .insetGrouped)
        title = "History"
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ledger.reloadFromDisk()
        data = ledger.all()
        tableView.reloadData()
        updateEmptyState()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(tapClear))
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.rightBarButtonItem?.tintColor = .systemRed
        // Gradient background for the table
        let bg = SiroccoGradientView(frame: tableView.bounds)
        bg.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.backgroundView = bg
        tableView.separatorColor = UIColor.white.withAlphaComponent(0.15)

        // Empty state label
        emptyLabel.text = "No records yet\nPlay a game to create history"
        emptyLabel.textColor = UIColor.white.withAlphaComponent(0.9)
        emptyLabel.numberOfLines = 0
        emptyLabel.textAlignment = .center
        emptyLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        bg.addSubview(emptyLabel)
        NSLayoutConstraint.activate([
            emptyLabel.centerXAnchor.constraint(equalTo: bg.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: bg.centerYAnchor),
            emptyLabel.leadingAnchor.constraint(greaterThanOrEqualTo: bg.leadingAnchor, constant: 20),
            emptyLabel.trailingAnchor.constraint(lessThanOrEqualTo: bg.trailingAnchor, constant: -20)
        ])
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { data.count }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "c") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "c")
        let e = data[indexPath.row]
        let sign = e.delta >= 0 ? "+" : ""
        cell.textLabel?.text = "Grid \(e.grid)x\(e.grid)  \(sign)\(e.delta)"
        cell.textLabel?.textColor = .white
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .short
        cell.detailTextLabel?.text = df.string(from: e.timestamp)
        cell.detailTextLabel?.textColor = UIColor.white.withAlphaComponent(0.8)
        cell.backgroundColor = UIColor.white.withAlphaComponent(0.08)
        return cell
    }

    @objc private func tapClear() {
        let alert = UIAlertController(title: "Delete All Records?", message: "This action cannot be undone.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
            guard let self = self else { return }
            self.ledger.clearAll()
            self.data.removeAll()
            self.tableView.reloadData()
            self.updateEmptyState()
        }))
        present(alert, animated: true)
    }

    private func updateEmptyState() {
        emptyLabel.isHidden = !data.isEmpty
    }
}


