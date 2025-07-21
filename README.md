# RandomReminder

A macOS menu bar app built with SwiftUI that randomly reminds you to do things. 
It is a non-generic take on a reminders app that is spontaneous in nature and highly customisable.

## Screenshots
<p align="center">
    <img src="docs/reminders.png" alt="Reminders" width="700">
    <img src="docs/create_new_reminder.png" alt="Create new reminder" width="700">
</p>

## Features in development
- [x] A proper settings panel with icons
- [x] Model serialisation via JSON and `AppStorage` for application preferences
- [x] A view for creating reminders
- [x] A view for editing existing reminders
- [x] Reminder deletion
- [x] Display reminders in preferences
- [x] Configuration of notifications and a window to guide the user to select the appropriate options
- [x] An option for launching the application at login
- [x] Default preferences for dates/times selected
- [x] SwiftLint for in-editor linting
- [x] SwiftFormat for code formatting
- [x] Pre-commit hooks for SwiftLint
- [ ] Non UI testing, potentially via Docker
- [ ] Xcode build testing
- [ ] `CONTRIBUTING.md` post-release
- [ ] GitHub actions
- [x] SwiftGen for strongly typed localisations
- [ ] English (American), English (Australian) and Italian localisations
- [ ] App and menu bar icons
- [ ] A interactive, high fidelity Figma prototype

## Acknowledgements
RandomReminder is possible thanks to OSS. SwiftUI tutorials and guides for macOS development are very limited compared to resources for iOS development, thus RandomReminder is only possible because of the people who willingly and voluntarily share open-source macOS software from which I can learn how to use SwiftUI. More proper acknowledgements will be added later.

A very special thank you goes to a particular conversation I had with someone important which resulted in this app's conception.

> [!WARNING]
> RandomReminder is incomplete in its functionality and documentation and is still being developed. 
> Features—especially UI designs—are subject to change and screenshots may not accurately represent the current state of the app.
