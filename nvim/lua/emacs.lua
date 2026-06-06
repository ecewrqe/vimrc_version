-- Emacs-like universal argument in Insert mode:
-- C-u 5 C-f => move right 5
-- C-u 10 C-b => move left 10
-- C-u C-f => move right 4
local prefix_active = false
local prefix_digits = ""

local function feed(keys)
    vim.api.nvim_feedkeys(
        vim.api.nvim_replace_termcodes(keys, true, false, true),
        "n", false
    )
end

local function start_prefix()
    prefix_active = true
    prefix_digits = ""
end

local function add_digit(d)
    if prefix_active then
        prefix_digits = prefix_digits .. d
    else
        feed(d)
    end
end

local function get_count()
    local n

    if prefix_digits == "" then
        n = 4
    else
        n = tonumber(prefix_digits)
    end

    prefix_active = false
    prefix_digits = ""

    return n or 1
end

local function move(keys)
    local n = prefix_active and get_count() or 1
    feed(string.rep(keys, n))
end

vim.keymap.set("i", "<C-u>", start_prefix, { silent = true })
for i = 0, 9 do
    vim.keymap.set("i", tostring(i), function()
        add_digit(tostring(i))
    end, { silent = true })
end

vim.keymap.set("i", "<C-f>", function()
    return move("<Right>")
end, { silent = true })

vim.keymap.set("i", "<C-b>", function()
    return move("<Left>")
end, { silent = true })

vim.keymap.set("i", "<C-n>", function()
    return move("<Down>")
end, { silent = true })

vim.keymap.set("i", "<C-p>", function()
    return move("<Up>")
end, { silent = true })

vim.keymap.set("i", "<M-f>", function()
    local n = prefix_active and get_count() or 1
    feed("<C-o>" .. n .. "w")
end, { silent = true })

vim.keymap.set("i", "<M-b>", function()
    local n = prefix_active and get_count() or 1
    feed("<C-o>" .. n .. "b")
end, { silent = true })

vim.keymap.set("i", "<C-d>", function()
    local n = prefix_active and get_count() or 1
    feed(string.rep("<Del>", n))
end, { silent = true })

vim.keymap.set("i", "<C-BS>", function()
    local n = prefix_active and get_count() or 1
    feed(string.rep("<BS>", n))
end, { silent = true })

vim.keymap.set("i", "<M-d>", function()
    local n = prefix_active and get_count() or 1
    feed("<C-o>" .. n .. "dw")
end, { silent = true })

vim.keymap.set("i", "<M-BS>", function()
    local n = prefix_active and get_count() or 1
    feed("<C-o>" .. n .. "db")
end, { silent = true })

vim.keymap.set("i", "<C-a>", function()
    feed("<C-o>0")
end, { silent = true })

vim.keymap.set("i", "<C-e>", function()
    local n = prefix_active and get_count() or 1
    feed("<C-o>" .. n .. "$")
end, { silent = true })

vim.keymap.set("i", "<C-k>", function()
    local n = prefix_active and get_count() or 1
    feed("<C-o>" .. n .. "d$")
end, { silent = true })

vim.keymap.set("i", "<C-y>", "<C-r>+", { silent = true })


