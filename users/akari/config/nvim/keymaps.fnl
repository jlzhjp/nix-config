(local vim _G.vim)

(macro leader-maps [mapper specs]
  (let [forms []]
    (each [_ spec (ipairs specs)]
      (table.insert forms `(,mapper ,(. spec 1) ,(. spec 2) ,(. spec 3))))
    `(do
       ,(unpack forms))))

(fn setup []
  (let [nmap-leader (fn [suffix rhs desc]
                      (vim.keymap.set :n (.. :<Leader> suffix) rhs {: desc}))
        xmap-leader (fn [suffix rhs desc]
                      (vim.keymap.set :x (.. :<Leader> suffix) rhs {: desc}))
        explore-at-file "<Cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<CR>"
        pick-added-hunks-buf "<Cmd>Pick git_hunks path=\"%\" scope=\"staged\"<CR>"
        pick-workspace-symbols-live "<Cmd>Pick lsp scope=\"workspace_symbol_live\"<CR>"]
    ;; Editor / Directories
    (leader-maps nmap-leader [[:ed "<Cmd>lua MiniFiles.open()<CR>" :Directory]
                              [:ef explore-at-file "File directory"]
                              [:ei "<Cmd>edit $MYVIMRC<CR>" :init.lua]
                              [:en
                               "<Cmd>lua MiniNotify.show_history()<CR>"
                               :Notifications]
                              [:eq
                               (fn []
                                 (let [winid (. (vim.fn.getqflist {:winid true})
                                                :winid)]
                                   (vim.cmd (if (not= winid 0) :cclose :copen))))
                               "Quickfix list"]
                              [:eQ
                               (fn []
                                 (let [winid (. (vim.fn.getloclist 0
                                                                   {:winid true})
                                                :winid)]
                                   (vim.cmd (if (not= winid 0) :lclose :lopen))))
                               "Location list"]])
    ;; Find / Pick
    (leader-maps nmap-leader
                 [[:f/ "<Cmd>Pick history scope=\"/\"<CR>" "\"/\" history"]
                  ["f:" "<Cmd>Pick history scope=\":\"<CR>" "\":\" history"]
                  [:fa
                   "<Cmd>Pick git_hunks scope=\"staged\"<CR>"
                   "Added hunks (all)"]
                  [:fA pick-added-hunks-buf "Added hunks (buf)"]
                  [:fb "<Cmd>Pick buffers<CR>" :Buffers]
                  [:fc "<Cmd>Pick git_commits<CR>" "Commits (all)"]
                  [:fC "<Cmd>Pick git_commits path=\"%\"<CR>" "Commits (buf)"]
                  [:fd
                   "<Cmd>Pick diagnostic scope=\"all\"<CR>"
                   "Diagnostic workspace"]
                  [:fD
                   "<Cmd>Pick diagnostic scope=\"current\"<CR>"
                   "Diagnostic buffer"]
                  [:ff "<Cmd>Pick files<CR>" :Files]
                  [:fg "<Cmd>Pick grep_live<CR>" "Grep live"]
                  [:fG
                   "<Cmd>Pick grep pattern=\"<cword>\"<CR>"
                   "Grep current word"]
                  [:fh "<Cmd>Pick help<CR>" "Help tags"]
                  [:fH "<Cmd>Pick hl_groups<CR>" "Highlight groups"]
                  [:fl "<Cmd>Pick buf_lines scope=\"all\"<CR>" "Lines (all)"]
                  [:fL
                   "<Cmd>Pick buf_lines scope=\"current\"<CR>"
                   "Lines (buf)"]
                  [:fm "<Cmd>Pick git_hunks<CR>" "Modified hunks (all)"]
                  [:fM
                   "<Cmd>Pick git_hunks path=\"%\"<CR>"
                   "Modified hunks (buf)"]
                  [:fr "<Cmd>Pick resume<CR>" :Resume]
                  [:fR
                   "<Cmd>Pick lsp scope=\"references\"<CR>"
                   "References (LSP)"]
                  [:fs pick-workspace-symbols-live "Symbols workspace (live)"]
                  [:fS
                   "<Cmd>Pick lsp scope=\"document_symbol\"<CR>"
                   "Symbols document"]
                  [:fv
                   "<Cmd>Pick visit_paths cwd=\"\"<CR>"
                   "Visit paths (all)"]
                  [:fV "<Cmd>Pick visit_paths<CR>" "Visit paths (cwd)"]])
    ;; LSP
    (leader-maps nmap-leader [[:la
                               "<Cmd>lua vim.lsp.buf.code_action()<CR>"
                               :Actions]
                              [:ld
                               "<Cmd>lua vim.diagnostic.open_float()<CR>"
                               "Diagnostic popup"]
                              [:lf
                               "<Cmd>lua require(\"conform\").format()<CR>"
                               :Format]
                              [:li
                               "<Cmd>lua vim.lsp.buf.implementation()<CR>"
                               :Implementation]
                              [:lh "<Cmd>lua vim.lsp.buf.hover()<CR>" :Hover]
                              [:ll "<Cmd>lua vim.lsp.codelens.run()<CR>" :Lens]
                              [:lr "<Cmd>lua vim.lsp.buf.rename()<CR>" :Rename]
                              [:lR
                               "<Cmd>lua vim.lsp.buf.references()<CR>"
                               :References]
                              [:ls
                               "<Cmd>lua vim.lsp.buf.definition()<CR>"
                               "Source definition"]
                              [:lt
                               "<Cmd>lua vim.lsp.buf.type_definition()<CR>"
                               "Type definition"]])
    ;; Terminal
    (leader-maps nmap-leader
                 [[:tT "<Cmd>horizontal term<CR>" "Terminal (horizontal)"]
                  [:tt "<Cmd>vertical term<CR>" "Terminal (vertical)"]])
    ;; Visual Mode LSP
    (leader-maps xmap-leader
                 [[:lf
                   "<Cmd>lua require(\"conform\").format()<CR>"
                   "Format selection"]])
    ;; Surround
    (vim.keymap.del :x :ys)
    (vim.keymap.set :x :S ":<C-u>lua MiniSurround.add('visual')<CR>"
                    {:silent true})
    (vim.keymap.set :n :yss :ys_ {:remap true})))

{: setup}
