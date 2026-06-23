(local vim _G.vim)
(local core (include :core))
(local plugins (include :plugins))
(local behavior (include :behavior))
(local keymaps (include :keymaps))
(local ui (include :ui))

(macro setup-modules [specs]
  (let [forms []]
    (each [_ spec (ipairs specs)]
      (let [module (. spec 1)
            opts (or (. spec 2) {})]
        (table.insert forms `((. (require ,module) :setup) ,opts))))
    `(do
       ,(unpack forms))))

((. core :setup))

(if vim.g.vscode
    (do
      ((. plugins :add-vscode))
      ((. behavior :setup-paredit)))
    (do
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
                      [:mini.icons]])
      ((. (require :mini.icons) :mock_nvim_web_devicons))
      ((. ui :setup))
      (setup-modules [[:mini.ai]
                      [:mini.pairs]
                      [:mini.pick]
                      [:mini.extra]
                      [:mini.notify]
                      [:which-key]])
      ((. (require :blink.cmp) :setup) {:completion {:list {:selection {:preselect false}}
                                                     :menu {:border :none}}})
      ((. (require :conform) :setup) {:default_format_opts {:lsp_format :fallback}
                                      :formatters_by_ft {:nix [:nixfmt]}})
      (vim.lsp.config :racket_langserver {:filetypes [:racket]})
      (vim.lsp.config :yamlls
                      {:settings {:yaml {:schemaStore {:enable false :url ""}
                                         :schemas ((. (. (require :schemastore)
                                                         :yaml)
                                                      :schemas))}}})
      ((. behavior :setup))
      ((. keymaps :setup))))
