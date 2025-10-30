import Foundation

struct LedgerEntry: Codable {
    let timestamp: Date
    let grid: Int
    let delta: Int
    let note: String?
}

final class LedgerVault {
    private let key = "ledger.entries.key.paracosm"
    private var entries: [LedgerEntry] = []

    init() {
        load()
    }

    func record(scoreDelta: Int, grid: Int) {
        let entry = LedgerEntry(timestamp: Date(), grid: grid, delta: scoreDelta, note: nil)
        entries.append(entry)
        save()
    }

    func recordRound(scoreTotal: Int, grid: Int) {
        let entry = LedgerEntry(timestamp: Date(), grid: grid, delta: scoreTotal, note: "round")
        entries.append(entry)
        save()
    }

    func all() -> [LedgerEntry] { entries.sorted { $0.timestamp > $1.timestamp } }

    func clearAll() {
        entries.removeAll()
        UserDefaults.standard.removeObject(forKey: key)
    }

    func reloadFromDisk() {
        entries.removeAll()
        load()
    }

    private func save() {
        let enc = JSONEncoder()
        enc.dateEncodingStrategy = .iso8601
        if let data = try? enc.encode(entries) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: key) else { return }
        let dec = JSONDecoder()
        dec.dateDecodingStrategy = .iso8601
        if let arr = try? dec.decode([LedgerEntry].self, from: data) {
            entries = arr
        }
    }
}


