// Excerpt from Nescroll (app/Shared/LockShared.swift). Shown for illustration only.
// The full source code is available at https://store.mikodes.com/p/nescroll/
//
// Quiet hours and lock timing. A daily window may cross midnight (22:00 to 07:00), and the
// shield stays up while either a timed lock or the quiet window is active. The window math is
// a pure function of the clock, so it is easy to unit test.

enum LockShared {
    // …
    static func isInsideQuietHours(_ date: Date = .init()) -> Bool {
        let q = quietHours
        guard q.on else { return false }
        let c = Calendar.current.dateComponents([.hour, .minute], from: date)
        return LockMath.contains(minute: (c.hour ?? 0) * 60 + (c.minute ?? 0), from: q.from, to: q.to)
    }

    /// True while either a timed lock or quiet hours want the shield up.
    static var shouldShield: Bool {
        (lockedUntil.map { $0 > Date() } ?? false) || isInsideQuietHours()
    }
}

/// Pure helpers, unit-tested.
enum LockMath {
    static func contains(minute: Int, from: Int, to: Int) -> Bool {
        from <= to ? (minute >= from && minute < to) : (minute >= from || minute < to)
    }
    /// DeviceActivity refuses windows under 15 minutes.
    static let minimumMinutes = 15
    static func clampedMinutes(_ m: Int) -> Int { max(minimumMinutes, min(m, 24 * 60)) }
}
