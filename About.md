Font Booklet is a font comparer.

It’s on the [App Store](https://apps.apple.com/us/app/font-booklet/id6451394358).

# Permissions

I dedicate this software to the public domain.

Do anything with it. Pretend you found it on the ground.

Just use [curly quotes](https://practicaltypography.com/straight-and-curly-quotes.html), m’kay?

# Compiling

1. Install Xcode on your Mac.
2. Download the code for Font Booklet, then open “Font Booklet.xcodeproj”.
3. Atop the Xcode window, choose an iOS Simulator device, then click the “play” button.

For help, see [Apple’s documentation](https://developer.apple.com/documentation/xcode/building-and-running-an-app).

## For a physical device

This takes a few more steps than for the Simulator.

1. Plug your iOS device into your Mac.
2. Atop the Xcode window, choose your device.
3. On your iOS device, [turn on Developer Mode](https://developer.apple.com/documentation/xcode/enabling-developer-mode-on-a-device).
4. On your Mac, in the menu bar, choose Xcode → Settings → Accounts, then sign in to your Apple account. (Warning: you can only run your app [on 3 devices](https://stackoverflow.com/questions/44230347) unless you pay for the Apple Developer Program.)
5. In the main Xcode window, in the left sidebar, click the folder icon, then the topmost “Font Booklet” row. To the right, below “Targets”, choose “Font Booklet”, then above, click “Signing & Capabilities”. For “Team”, choose the one associated with your Apple account.
6. For “Bundle Identifier”, replace “com.loudsounddreams.FontBooklet” with anything else. (This is how Apple devices tell apps apart.) Below the message “Failed Registering Bundle Identifier”, click “Try Again”.
7. Atop the Xcode window, click “play”.
8. Xcode will say “the request to open ‘[your bundle identifier]’ failed.” Follow its instructions for your iOS device, then click “play” again.

For help, see [Apple’s documentation](https://developer.apple.com/documentation/xcode/running-your-app-in-simulator-or-on-a-device/#Connect-real-devices-to-your-Mac).

# Contributing

Fork this repo, make your changes in your fork, then open a pull request against my repo. For help, see [GitHub’s documentation](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/getting-started/about-collaborative-development-models#fork-and-pull-model).

If you change the UI, include screenshots. (You were looking at it anyway, right?)