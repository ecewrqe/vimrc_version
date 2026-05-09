---
Order: 7
name: language
---

# Example Extension for VS Code

A sample VS Code extension demonstrating code VS Code Extension API features including commanding, user input, notifications, and text editor manipulation.

## Features :sparkles:

This extension provides several commands to demonstrate VS Code API capabilities:

### Notification Commands :eyes:

- **Hello World** - Shows an information message
- **Show Warning** - Displays a warning notification
- **Show Error** - Shows an error notification

### User Interaction Commands :clipboard:

- **Get User INput** - Opens an input box to collect user text
- **Show Quick Pick** - Displays a dropdown menu with selectable options

### Editor Commands :heart:

- **Work with Editor** - Shows the currently selected text in the active editor
- **Insert Text** - Inserts "Hello from extension" at the cursor position

## Requirements :bug:

- VS Code version 1.102.0 or higher
- Node.js and npm installed

## Installation :test_tube

### Development Setup ::

1. Clone the repository:

    ``` bash
    git clone <repository-url>
    cd example-ext
    ```

2. Install dependencies:

    ``` bash
    npm install
    ```

3. Compile the TypeScript code:

    ``` bash
    npm run compile
    ```

### Running the Extension

1. Open the project in VS Code
2. Press `F5` to open a new VS Code window with the extension loaded
3. Open the Command Palette (`Cmd+Shift+P` on macOS or `Ctrl+Shift+P` on windows/Linux)
4. Type any of the command names listed above

## Available Commands

| Command | Description | Command ID |
|---------|-------------|------------|
| Hello World | Shows a hello message | `example-ext.helloWorld` |
| Show Warning | Displays a warning | `example-ext.showWarning` |
| Show Error | Shows an error message | `example-ext.showError` |
| Get User Input | Prompts for user input | `example-ext.getUserInput` |
| Show Quick Pick | Shows a selection menu | `example-ext.showQuickPick` |
| Work with Editor | Displays selected text | `example-ext.workWithEditor` |
| Insert Text | Inserts text at cursor | `example-ext.insertText` |

## Development

### Build Commands

``` bash
npm run compile

npm run watch

npm run lint

npm test
```

### Project Structure

``` bash
tree -I 'node_modules|*.vsix|.git' --dirsfirst
tree -I 'node_modules|*.vsix|.git' --dirsfirst -L 3
tree -I 'node_modules|*.vsix|.git' --dirsfirst -a
```

``` text
.
├── out
│   ├── test
│   │   ├── extension.test.js     # comments
│   │   └── extension.test.js.map
│   ├── extension.js
│   └── extension.js.map
├── src
│   ├── test
│   │   └── extension.test.ts
│   └── extension.ts
├── CHANGELOG.md
├── eslint.config.mjs
├── package-lock.json
├── package.json
├── README.md
├── tsconfig.json
└── vsc-extension-quickstart.md
```

## Testing

The extenssion includes a test suite that verifies:

- Extension activation
- Command registration
- Command execution
- Text insertion functionality

Run tests with:

``` bash
npm test
```

## Packaging

TO package the extension for distribution:

1. Install vsce (Visual Studio Code Extension manager):

    ```bash
    npm install -g @vscode/vsce
    ```

2. Package the extension:

    ``` bash
    vsce package
    ```

The creates a `.vsix` file that can be installed in VS Code.

## Known Issues

- User input and quick pick commands will timeout in automated tests as they wait for user interaction

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature_amazing-feature`)
5. Open a Pull Request

## License

The project is licensed under the MIT License - see the License file for details.
(MIT: Massachusetts Institute of Technology)

## Acknowledgments

- Build with the [VS Code Extension API](https://code.visualstudio.com/api)
- TypeScript for type-safe development
- Mocha for testing framework

---

``` mermaid
sequenceDiagram
    participant Alice
    actor Bob
    Alice->>John: Hello John, how are you?
    loop HealthCheck
        John->>John: Fight against hypochondria
    end
    Note right of John: Rational thoughts
    John-->>Alice: Great!
    John->>Bob: How about you?
    Bob-->>John: Jolly good!
```

``` mermaid
---
title: Note
config:
  flowchart:
    htmlLabels: true
---
flowchart LR

    A[Start] --> B{Is it working?}

    circle((circle)) --> B
    flag>flag] --> D

    B -- Yes --> C[Great!]
    B -- No --> D[Fix it]
    D --> B
    C --> E[End]
```

$$
\int_{a}^{b} x^2 dx
$$

This is inline math: $E = mc^2a$

**Happy Coding!** :rocket:
