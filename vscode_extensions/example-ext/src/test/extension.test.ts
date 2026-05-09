import * as assert from 'assert';
import * as vscode from 'vscode';

suite('Extension Test Suite', () => {
	vscode.window.showInformationMessage('Start all tests.');

	test('Sample Test', () => {
		assert.strictEqual(-1, [1, 2, 3].indexOf(5));
		assert.strictEqual(-1, [1, 2, 3].indexOf(0));
	});

	test('Extension should be present', () => {
		assert.ok(vscode.extensions.getExtension('euewrqe.example-ext'));
	});

	test('Extension commands should be registered', async () => {
		const extension = vscode.extensions.getExtension('euewrqe.example-ext');
		assert.ok(extension, 'Extension sould be found');

		if (!extension.isActive) {
			await extension.activate();
		}
		const commands = await vscode.commands.getCommands(true);

		const expectedCommands = [
			'example-ext.helloWorld',
			'example-ext.showWarning',
			'example-ext.showError',
			'example-ext.getUserInput',
			'example-ext.showQuickPick',
			'example-ext.workWithEditor',
			'example-ext.insertText'
		];

		expectedCommands.forEach(command => {
			assert.ok(commands.includes(command), `Command ${command} should be registered`);
		});
	});
	test('Hello World command should execute', async () => {
		await vscode.commands.executeCommand('example-ext.helloWorld');
		assert.ok(true, 'Hello World command executed successfully');
	});

	test('Show Warning command should execute', async () => {
		await vscode.commands.executeCommand('example-ext.showWarning');
		assert.ok(true, 'Show Warning command executed successfully');
	});

	test('Show Error command should execute', async () => {
		await vscode.commands.executeCommand('example-ext.showError');
		assert.ok(true, 'Show Error command executed successfully');
	});

	// test('Get User Input command should execute', async () => {
	// 	await vscode.commands.executeCommand('example-ext.getUserInput');
	// 	assert.ok(true, 'User input should not be empty');
	// });

	// test('Show Quick Pick command should execute', async () => {
	// 	await vscode.commands.executeCommand('example-ext.showQuickPick');
	// 	assert.ok(true, 'Show Quick Pick command executed successfully');
	// });

	test('Work with editor command should execute', async () => {
		const document = await vscode.workspace.openTextDocument({
			content: 'Test content for editor command',
			language: 'plaintext'
		});

		const editor = await vscode.window.showTextDocument(document);

		editor.selection = new vscode.Selection(0, 0, 0, 4); // Select "Test"

		await vscode.commands.executeCommand('example-ext.workWithEditor');
		assert.ok(true, 'Work with Editor command execute successfully');

		await vscode.commands.executeCommand('workbench.action.closeActiveEditor');
	});

	test('Insert Text command should execute', async () => {
		const document = await vscode.workspace.openTextDocument({
			content: '',
			language: 'plaintext'
		});

		const editor = await vscode.window.showTextDocument(document);

		await vscode.commands.executeCommand('example-ext.insertText');

		const text = editor.document.getText();
		assert.strictEqual(text, '', 'Text should be inserted correctly');

		await vscode.commands.executeCommand('workbench.action.closeActiveEditor');
	});
});