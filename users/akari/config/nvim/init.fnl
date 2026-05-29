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
                   :fennel_ls
                   :fish_lsp
                   :gopls
                   :harper_ls
                   :hls
                   :nixd
                   :racket_langserver
                   :rust_analyzer
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
  (setup-modules [[:mini.ai]
                  [:mini.jump2d]
                  [:mini.pairs]
                  [:mini.pick]
                  [:mini.extra]
                  [:mini.notify]
                  [:which-key]])
  ((. (require :blink.cmp) :setup) {:completion {:list {:selection {:preselect false}}}})
  ((. (require :conform) :setup) {:default_format_opts {:lsp_format :fallback}
                                  :formatters_by_ft {:nix [:nixfmt]}})
  (vim.lsp.config :racket_langserver {:filetypes [:racket]})
  (vim.lsp.config :yamlls
                  {:settings {:yaml {:schemaStore {:enable false :url ""}
                                     :schemas ((. (. (require :schemastore)
                                                     :yaml)
                                                  :schemas))}}})
  ((. behavior :setup))
  ((. keymaps :setup))
  (vim.cmd "colorscheme kanagawa"))
