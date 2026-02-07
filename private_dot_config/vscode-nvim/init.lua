local vscode = require("vscode")

vim.g.mapleader = " "

vim.opt.clipboard = "unnamedplus"

vim.keymap.set("n", ">", ">>", { noremap = true })
vim.keymap.set("n", "<", "<<", { noremap = true })

vim.keymap.set("v", ">", ">gv", { noremap = true })
vim.keymap.set("v", "<", "<gv", { noremap = true })

vim.keymap.set("v", "p", '"_dP', { noremap = true })


vim.keymap.set("n", "<leader>e", function()
    vscode.call("workbench.action.toggleSidebarVisibility")
end)

vim.keymap.set("n", "<leader>ff", function()
    vscode.call("workbench.action.quickOpen")
end, { noremap = true, silent = true })

vim.keymap.set("n", "<leader>fG", function()
    vscode.call("workbench.action.findInFiles")
end, { noremap = true, silent = true })