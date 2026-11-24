<p align="center">
  <img src="assets/logo.png" width="72" alt="Nescroll logo">
</p>

<h1 align="center">Nescroll</h1>

<p align="center">
  <b>Social browser without endless feeds, with a screen-time lock (SwiftUI, iOS).</b>
</p>

<p align="center">
  <a href="https://nescroll.mikodes.com/docs/"><b>Docs</b></a> ·
  <a href="https://nescroll.mikodes.com/"><b>Website</b></a> ·
  <a href="https://store.mikodes.com/p/nescroll/"><b>Get the full source code</b></a>
</p>

<p align="center">
  <img alt="Swift" src="https://img.shields.io/badge/Swift-F05138?logo=swift&logoColor=white">
  <img alt="Version" src="https://img.shields.io/badge/version-1.0.0-111">
</p>

<p align="center">
  <img src="assets/hero.gif" width="100%" alt="Nescroll">
</p>

> **This repository is a showcase.** It holds screenshots, documentation pointers and a real excerpt
> from the code. The full application is sold as source code at
> **[store.mikodes.com/p/nescroll](https://store.mikodes.com/p/nescroll/)**: one payment, instant ZIP download, free setup help.

---

## What it is

A native iPhone and iPad app that opens social sites in calm browser tabs with the endless feeds removed, plus daily limits and a lock that keeps scrolling in check.

## Screens

<p align="center"><img src="assets/lock.png" width="49%" alt="Lock"> <img src="assets/what.png" width="49%" alt="What"></p>
<p align="center"><img src="assets/rules.png" width="49%" alt="Rules"> <img src="assets/stack.png" width="49%" alt="Stack"></p>

## Features

- **iOS only: native SwiftUI app for iPhone and iPad, no Android version**
- **Three social sites in calm browser tabs**
- **10 switchable feed filters**
- **Redirect, selector and label filter engine**
- **Autoplay off and Up next removed**
- **Screen Time lock of native apps**
- **Timed lock**
- **Daily quiet hours**
- **DeviceActivity monitor extension**
- **Custom shield screen**
- **Three-screen onboarding**
- **7-day statistics chart**

## A look at the code

**Safe remote filter updates**: [`snippets/RemoteRules.swift`](snippets/RemoteRules.swift). When a social site changes its pages, the app can pick up new filter rules from a plain JSON file. Each rule is validated on the device (length limits, no CSS blocks, only same-site redirects, valid regexes), so a bad file can never break the app.

## Requirements (full version)

- iOS only, no Android version: iPhone and iPad with iOS 17 or newer
- A Mac with Xcode 26 or newer
- Apple Developer Program membership
- A real iPhone with iOS 17 or newer for the Screen Time lock
- Apple's Family Controls
- Optional: XcodeGen 2.x

Not included: Apple Developer Program membership; Apple Family Controls; App Store publishing and review outcome; Hosting for the optional rules.json; Any affiliation with or permission from Instagram, Facebook, Meta, YouTube or Google.

## Get the full source code

<p align="center">
  <a href="https://store.mikodes.com/p/nescroll/"><img src="https://img.shields.io/badge/Get%20the%20full%20source%20code-store.mikodes.com-4F2BFF?style=for-the-badge" alt="Get the full source code"></a>
</p>

One payment, full licence, instant ZIP download and free setup help.
Questions: [mikodes.com/support](https://mikodes.com/support).

---

<p align="center">
  Made by <a href="https://mikodes.com"><b>MIKODES</b></a> · <a href="https://github.com/Mikodesteam">more projects</a>
</p>
