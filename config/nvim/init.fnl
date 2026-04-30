(local vim _G.vim)
(local core (include :core))
(local plugins (include :plugins))
(local behavior (include :behavior))
(local keymaps (include :keymaps))

(macro setup-modules [specs]
  (let [forms []]
    (each [_ spec (ipairs specs)]
      (let [module (. spec 1)
            opts (or (. spec 2) {})]
        (table.insert forms `((. (require ,module) :setup) ,opts))))
    `(do
       ,(unpack forms))))

((. core :setup))

(when (not vim.g.vscode)
  ((. plugins :add))
  (vim.lsp.enable [:clangd
                   :rust_analyzer
                   :fennel_ls
                   :gopls
                   :harper_ls
                   :hls
                   :nixd
                   :racket_langserver
                   :ty
                   :yamlls])
  (setup-modules [[:mini.basics {:options {:extra_ui true}}]
                  [:mini.files]
                  [:mini.icons]
                  [:mini.tabline]
                  [:mini.statusline]])
  ((. (require :mini.surround) :setup) {:mappings {:add :ys
                                                   :delete :ds
                                                   :find ""
                                                   :find_left ""
                                                   :highlight ""
                                                   :replace :cs
                                                   :suffix_last ""
                                                   :suffix_next ""}
                                        :search_method :cover_or_next})
  (vim.keymap.del :x :ys)
  (vim.keymap.set :x :S ":<C-u>lua MiniSurround.add('visual')<CR>"
                  {:silent true})
  (vim.keymap.set :n :yss :ys_ {:remap true})
  (setup-modules [[:mini.ai]
                  [:mini.jump2d]
                  [:mini.pairs]
                  [:mini.pick]
                  [:mini.extra]
                  [:mini.notify]
                  [:which-key]])
  ((. (require :blink.cmp) :setup) {:completion {:list {:selection {:preselect false}}}})
  ((. (require :conform) :setup) {:default_format_opts {:lsp_format :fallback}})
  (vim.lsp.config :racket_langserver {:filetypes [:racket]})
  (vim.lsp.config :yamlls
                  {:settings {:yaml {:schemaStore {:enable false :url ""}
                                     :schemas ((. (. (require :schemastore)
                                                     :yaml)
                                                  :schemas))}}})
  (let [terminal-send ((. behavior :setup-terminal-send))]
    ((. keymaps :setup) terminal-send))
  ((. behavior :setup-paredit-autocmd))
  ((. behavior :setup-diagnostics))
  (vim.cmd "colorscheme tokyonight")
  ((. behavior :setup-treesitter-autocmd)))
