// Excerpt from Nescroll (app/NoReels/RemoteRules.swift). Shown for illustration only.
// The full source code is available at https://store.mikodes.com/p/nescroll/
//
// Lets the app receive new feed-filter rules from the owner's own HTTPS server
// without an App Store release. Everything fetched is size-limited and sanitised:
// bad selectors, unsafe redirects and broken regexes are dropped, and older versions are ignored.

// Platform, Filter, Redirect, AppConfig and Notification.Name.nrFiltersChanged are defined elsewhere in the app.

import Foundation

/// Filter updates without an App Store release. When Instagram, YouTube or Facebook change their pages,
/// you publish a new rules.json on your own HTTPS server and every installed app picks it up on next launch.
/// Off by default: set `AppConfig.rulesURL` to turn it on. Nothing about the user is sent; it is a plain GET.
struct RemoteRules: Codable, Equatable {
    struct Rules: Codable, Equatable {
        var selectors: [String] = []
        var labels: [String] = []
        var redirects: [RedirectRule] = []

        init(selectors: [String] = [], labels: [String] = [], redirects: [RedirectRule] = []) {
            self.selectors = selectors; self.labels = labels; self.redirects = redirects
        }
        /// Every list is optional in the file.
        init(from decoder: Decoder) throws {
            let c = try decoder.container(keyedBy: CodingKeys.self)
            selectors = try c.decodeIfPresent([String].self, forKey: .selectors) ?? []
            labels = try c.decodeIfPresent([String].self, forKey: .labels) ?? []
            redirects = try c.decodeIfPresent([RedirectRule].self, forKey: .redirects) ?? []
        }
    }
    struct RedirectRule: Codable, Equatable { let pattern: String; let target: String }

    var version: Int
    var platforms: [String: Rules]

    /// Drops anything unsafe or broken instead of failing the whole file.
    func sanitized() -> RemoteRules {
        var out = RemoteRules(version: version, platforms: [:])
        for (key, rules) in platforms where Platform(rawValue: key) != nil {
            let selectors = rules.selectors.filter { !$0.isEmpty && $0.count <= 300 && !$0.contains("{") && !$0.contains("}") }.prefix(200)
            let labels = rules.labels.filter { !$0.isEmpty && $0.count <= 40 }.prefix(100)
            let redirects = rules.redirects.filter {
                $0.pattern.count <= 200 && $0.target.hasPrefix("/") && !$0.target.contains("//")
                    && (try? NSRegularExpression(pattern: $0.pattern)) != nil
            }.prefix(50)
            out.platforms[key] = Rules(selectors: Array(selectors), labels: Array(labels), redirects: Array(redirects))
        }
        return out
    }

    /// The extra filter for one site, or nil when the file has nothing for it.
    func filter(for platform: Platform) -> Filter? {
        guard let r = platforms[platform.rawValue], !(r.selectors.isEmpty && r.labels.isEmpty && r.redirects.isEmpty) else { return nil }
        return Filter(id: "\(platform.rawValue).remote", title: String(localized: "Updated rules"),
                      detail: String(localized: "Fixes published after this version of the app."),
                      redirects: r.redirects.map { Redirect(pattern: $0.pattern, target: $0.target) },
                      selectors: r.selectors, labels: r.labels)
    }
}

@MainActor
enum RemoteRulesStore {
    private static let key = "rules.remote"

    static var current: RemoteRules? {
        guard let data = UserDefaults.standard.data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(RemoteRules.self, from: data)
    }

    /// Fetches once per launch; keeps the last good file when offline or when the new one is older.
    static func refresh(session: URLSession = .shared) async {
        guard let url = AppConfig.rulesURL, url.scheme == "https" else { return }
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        guard let (data, response) = try? await session.data(for: request),
              (response as? HTTPURLResponse)?.statusCode == 200, data.count < 256_000,
              let rules = try? JSONDecoder().decode(RemoteRules.self, from: data) else { return }
        let clean = rules.sanitized()
        if let old = current, old.version >= clean.version { return }
        UserDefaults.standard.set(try? JSONEncoder().encode(clean), forKey: key)
        NotificationCenter.default.post(name: .nrFiltersChanged, object: nil)
    }
}
