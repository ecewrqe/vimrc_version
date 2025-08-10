// The module 'vscode' contains the VS Code extensibility API
// Import the module and reference it with the alias vscode in your code below
import * as vscode from 'vscode';

// This method is called when your extension is activated
// Your extension is activated the very first time the command is executed
export function activate(context: vscode.ExtensionContext) {
	console.log('Congratulations, your extension "example-ext" is now active!');

	const helloCommand = vscode.commands.registerCommand('example-ext.helloWorld', () => {
		vscode.window.showInformationMessage('Hello World from example_ext!');
	});

	const warningCommand = vscode.commands.registerCommand('example-ext.showWarning', () => {
		vscode.window.showWarningMessage('This is a warning message!');
	});

	const errorCommand = vscode.commands.registerCommand('example-ext.showError', () => {
		vscode.window.showErrorMessage('This is an error message!');
	});

	const inputCommand = vscode.commands.registerCommand('example-ext.getUserInput', async() => {
		const result = await vscode.window.showInputBox({
			prompt: 'Please enter some input',
			placeHolder: 'Type your name here...'
		});

		if (result) {
			vscode.window.showInformationMessage(`You entered: ${result}`);
		}
	});

	const quickPickCommand = vscode.commands.registerCommand('example-ext.showQuickPick', async () => {
		const options = ['Option 1', 'Option 2', 'Option 3'];
		const selected = await vscode.window.showQuickPick(options, {
			placeHolder: 'Select an option'
		});

		if (selected) {
			vscode.window.showInformationMessage(`You selected: ${selected}`);
		}
	});

	const editorCommand = vscode.commands.registerCommand('example-ext.workWithEditor', () => {
		const editor = vscode.window.activeTextEditor;

		if (editor) {
			const document = editor.document;
			const selection = editor.selection;

			const selectedText = document.getText(selection);
			if (selectedText) {
				vscode.window.showInformationMessage(`Selected text: ${selectedText}`);
			} else {
				vscode.window.showInformationMessage('No text selected in the editor.');
			}
		} else {
			vscode.window.showErrorMessage('No active editor');
		}
	});

	const insertCommand = vscode.commands.registerCommand('example-ext.insertText', () => {
		const editor = vscode.window.activeTextEditor;
		if (editor) {
			editor.edit(editBuilder => {
				editBuilder.insert(editor.selection.active, 'Hello from extension');
			});
		}
	});

	context.subscriptions.push(
		helloCommand,
		warningCommand,
		errorCommand,
		inputCommand,
		quickPickCommand,
		editorCommand,
		insertCommand
	);
}

// This method is called when your extension is deactivated
export function deactivate() {}
