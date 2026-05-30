(local vim _G.vim)

(local gh (fn [repo] (.. "https://github.com/" repo)))

(fn add []
  (vim.pack.add [(gh :nvim-treesitter/nvim-treesitter)
                 (gh :neovim/nvim-lspconfig)
                 {:src (gh :nvim-mini/mini.nvim) :version :stable}
                 {:src (gh :saghen/blink.cmp)
                  :version (vim.version.range :1.*)}
                 (gh :folke/which-key.nvim)
                 (gh :tpope/vim-sleuth)
                 (gh :tpope/vim-repeat)
                 (gh :julienvincent/nvim-paredit)
                 (gh :b0o/SchemaStore.nvim)
                 (gh :stevearc/conform.nvim)
                 (gh :hiphish/rainbow-delimiters.nvim)
                 (gh :shatur/neovim-ayu)]))

{: add}
