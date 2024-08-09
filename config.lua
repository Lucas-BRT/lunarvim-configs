-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny

lvim.transparent_window = true
vim.opt.timeoutlen = 500

lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
lvim.keys.normal_mode["<C-t>"] = "<cmd>ToggleTerm direction=float size=50<CR>"
lvim.builtin.which_key.mappings["t"] = { "<cmd>ToggleTerm direction=float size=50<CR>", "Terminal" }
lvim.format_on_save = false

-- Importar as configurações de lsp do lvim
local lspconfig = require("lspconfig")

-- Adicionar configuração para o Ruff LSP
lspconfig.ruff_lsp.setup({
    cmd = { "ruff-lsp" },
    filetypes = { "python" },
    root_dir = lspconfig.util.root_pattern(".git", vim.fn.getcwd()),
    settings = {
        args = {},
    },
})

-- Adicionar configuração para o Rust Analyzer
lspconfig.rust_analyzer.setup({
    on_attach = function(_, bufnr)
        vim.api.nvim_buf_set_option(bufnr, "formatexpr", "v:lua.vim.lsp.formatexpr()")
    end,
    settings = {
        ["rust-analyzer"] = {
            cargo = { allFeatures = true },
            checkOnSave = {
                command = "clippy",
            },
        },
    },
})

-- Adicionar Ruff às lsp_installer
lvim.lsp.installer.setup.ensure_installed = {
  "ruff_lsp",
  "rust_analyzer"
}

-- AutoCmd para executar o formatador Ruff ao salvar o arquivo
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.py",
    callback = function()
        vim.lsp.buf.format({ async = false })
    end,
})


-- AutoCmd para executar o formatador Rust ao salvar o arquivo Rust
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.rs",
    callback = function()
        vim.lsp.buf.format({ async = false })
    end,
})


vim.keymap.set("n", "<leader>y", '"+y')
vim.keymap.set("n", "<leader>p", '"+p')
