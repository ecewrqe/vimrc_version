function CopilotChatBuffer()
    local input = vim.fn.input("Quick Chat:")
    if input ~= "" then
        require("CopilotChat").ask(input, {
            selection = require("CopilotChat.select").buffer
        })
    end
end

-- vim.api.nvim_set_keymap("n", "<leader>ee", "<cmd>lua CopilotChatBuffer()<cr>", { noremap = true, silent = true })
