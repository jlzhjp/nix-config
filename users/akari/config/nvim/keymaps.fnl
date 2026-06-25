(local vim _G.vim)

(fn cmd [command]
  (.. :<Cmd> command :<CR>))

(fn leader-key [suffix]
  (.. :<Leader> suffix))

(fn setup-leader-groups [groups]
  (let [which-key (require :which-key)
        clues []]
    (each [_ group (ipairs groups)]
      (table.insert clues {1 (leader-key group.prefix)
                           :group group.group
                           :mode group.mode})
      (each [_ spec (ipairs group.maps)]
        (vim.keymap.set (or (. spec 4) group.mode)
                        (leader-key (.. group.prefix (. spec 1))) (. spec 2)
                        {:desc (. spec 3)})))
    ((. which-key :add) clues)))

(fn setup-direct-maps [maps]
  (each [_ spec (ipairs maps)]
    (vim.keymap.set (. spec 1) (. spec 2) (. spec 3) {:desc (. spec 4)})))

(fn setup []
  (let [new-scratch-buffer (fn []
                             (vim.api.nvim_win_set_buf 0
                                                       (vim.api.nvim_create_buf true
                                                                                true)))
        toggle-quickfix (fn []
                          (let [winid (. (vim.fn.getqflist {:winid true})
                                         :winid)]
                            (vim.cmd (if (not= winid 0) :cclose :copen))))
        toggle-location-list (fn []
                               (let [winid (. (vim.fn.getloclist 0
                                                                 {:winid true})
                                              :winid)]
                                 (vim.cmd (if (not= winid 0) :lclose :lopen))))
        make-pick-core (fn [cwd desc]
                         (fn []
                           (let [sort-latest (MiniVisits.gen_sort.default {:recency_weight 1})
                                 local-opts {: cwd
                                             :filter :core
                                             :sort sort-latest}]
                             (MiniExtra.pickers.visit_paths local-opts
                                                            {:source {:name desc}}))))
        leap-jump (fn [backward]
                    (fn []
                      ((. (require :leap) :leap) {: backward})))
        git-log-cmd "Git log --pretty=format:\\%h\\ \\%as\\ |\\ \\%s --topo-order"
        git-log-buf-cmd (.. git-log-cmd " --follow -- %")
        groups [{:mode :n
                 :prefix :b
                 :group :Buffer
                 :maps [[:a (cmd "b#") :Alternate]
                        [:d (cmd "lua MiniBufremove.delete()") :Delete]
                        [:D (cmd "lua MiniBufremove.delete(0, true)") :Delete!]
                        [:s new-scratch-buffer :Scratch]
                        [:w (cmd "lua MiniBufremove.wipeout()") :Wipeout]
                        [:W
                         (cmd "lua MiniBufremove.wipeout(0, true)")
                         :Wipeout!]]}
                {:mode :n
                 :prefix :e
                 :group :Explore/Edit
                 :maps [[:d (cmd "lua MiniFiles.open()") :Directory]
                        [:f
                         (cmd "lua MiniFiles.open(vim.api.nvim_buf_get_name(0))")
                         "File directory"]
                        [:i (cmd "edit $MYVIMRC") :init.lua]
                        [:n
                         (cmd "lua MiniNotify.show_history()")
                         :Notifications]
                        [:q toggle-quickfix "Quickfix list"]
                        [:Q toggle-location-list "Location list"]]}
                {:mode :n
                 :prefix :f
                 :group :Find
                 :maps [["/" (cmd "Pick history scope=\"/\"") "\"/\" history"]
                        [":" (cmd "Pick history scope=\":\"") "\":\" history"]
                        [:a
                         (cmd "Pick git_hunks scope=\"staged\"")
                         "Added hunks (all)"]
                        [:A
                         (cmd "Pick git_hunks path=\"%\" scope=\"staged\"")
                         "Added hunks (buf)"]
                        [:b (cmd "Pick buffers") :Buffers]
                        [:c (cmd "Pick git_commits") "Commits (all)"]
                        [:C
                         (cmd "Pick git_commits path=\"%\"")
                         "Commits (buf)"]
                        [:d
                         (cmd "Pick diagnostic scope=\"all\"")
                         "Diagnostic workspace"]
                        [:D
                         (cmd "Pick diagnostic scope=\"current\"")
                         "Diagnostic buffer"]
                        [:f (cmd "Pick files") :Files]
                        [:g (cmd "Pick grep_live") "Grep live"]
                        [:G (cmd "Pick grep pattern=\"\"") "Grep current word"]
                        [:h (cmd "Pick help") "Help tags"]
                        [:H (cmd "Pick hl_groups") "Highlight groups"]
                        [:l (cmd "Pick buf_lines scope=\"all\"") "Lines (all)"]
                        [:L
                         (cmd "Pick buf_lines scope=\"current\"")
                         "Lines (buf)"]
                        [:m (cmd "Pick git_hunks") "Modified hunks (all)"]
                        [:M
                         (cmd "Pick git_hunks path=\"%\"")
                         "Modified hunks (buf)"]
                        [:r (cmd "Pick resume") :Resume]
                        [:R
                         (cmd "Pick lsp scope=\"references\"")
                         "References (LSP)"]
                        [:s
                         (cmd "Pick lsp scope=\"workspace_symbol_live\"")
                         "Symbols workspace (live)"]
                        [:S
                         (cmd "Pick lsp scope=\"document_symbol\"")
                         "Symbols document"]
                        [:v
                         (cmd "Pick visit_paths cwd=\"\"")
                         "Visit paths (all)"]
                        [:V (cmd "Pick visit_paths") "Visit paths (cwd)"]]}
                {:mode :n
                 :prefix :g
                 :group :Git
                 :maps [[:a (cmd "Git diff --cached") "Added diff"]
                        [:A (cmd "Git diff --cached -- %") "Added diff buffer"]
                        [:c (cmd "Git commit") :Commit]
                        [:C (cmd "Git commit --amend") "Commit amend"]
                        [:d (cmd "Git diff") :Diff]
                        [:D (cmd "Git diff -- %") "Diff buffer"]
                        [:l (cmd git-log-cmd) :Log]
                        [:L (cmd git-log-buf-cmd) "Log buffer"]
                        [:o
                         (cmd "lua MiniDiff.toggle_overlay()")
                         "Toggle overlay"]
                        [:s
                         (cmd "lua MiniGit.show_at_cursor()")
                         "Show at cursor"]
                        [:z (leap-jump false) "Leap forward" [:n :x :o]]
                        [:Z (leap-jump true) "Leap backward" [:n :x :o]]]}
                {:mode :n
                 :prefix :l
                 :group :Language
                 :maps [[:a (cmd "lua vim.lsp.buf.code_action()") :Actions]
                        [:d
                         (cmd "lua vim.diagnostic.open_float()")
                         "Diagnostic popup"]
                        [:f (cmd "lua require(\"conform\").format()") :Format]
                        [:i
                         (cmd "lua vim.lsp.buf.implementation()")
                         :Implementation]
                        [:h (cmd "lua vim.lsp.buf.hover()") :Hover]
                        [:l (cmd "lua vim.lsp.codelens.run()") :Lens]
                        [:r (cmd "lua vim.lsp.buf.rename()") :Rename]
                        [:R (cmd "lua vim.lsp.buf.references()") :References]
                        [:s
                         (cmd "lua vim.lsp.buf.definition()")
                         "Source definition"]
                        [:t
                         (cmd "lua vim.lsp.buf.type_definition()")
                         "Type definition"]]}
                {:mode :n
                 :prefix :m
                 :group :Map
                 :maps [[:f
                         (cmd "lua MiniMap.toggle_focus()")
                         "Focus (toggle)"]
                        [:r (cmd "lua MiniMap.refresh()") :Refresh]
                        [:s (cmd "lua MiniMap.toggle_side()") "Side (toggle)"]
                        [:t (cmd "lua MiniMap.toggle()") :Toggle]]}
                {:mode :n
                 :prefix :o
                 :group :Other
                 :maps [[:r
                         (cmd "lua MiniMisc.resize_window()")
                         "Resize to default width"]
                        [:t
                         (cmd "lua MiniTrailspace.trim()")
                         "Trim trailspace"]
                        [:z (cmd "lua MiniMisc.zoom()") "Zoom toggle"]]}
                {:mode :n
                 :prefix :s
                 :group :Session
                 :maps [[:d
                         (cmd "lua MiniSessions.select(\"delete\")")
                         :Delete]
                        [:n
                         (cmd "lua vim.ui.input({ prompt = \"Session name: \" }, MiniSessions.write)")
                         :New]
                        [:r (cmd "lua MiniSessions.select(\"read\")") :Read]
                        [:R (cmd "lua MiniSessions.restart()") :Restart]
                        [:w (cmd "lua MiniSessions.write()") "Write current"]]}
                {:mode :n
                 :prefix :t
                 :group :Terminal
                 :maps [[:T (cmd "horizontal term") "Terminal (horizontal)"]
                        [:t (cmd "vertical term") "Terminal (vertical)"]]}
                {:mode :n
                 :prefix :v
                 :group :Visits
                 :maps [[:c
                         (make-pick-core "" "Core visits (all)")
                         "Core visits (all)"]
                        [:C
                         (make-pick-core nil "Core visits (cwd)")
                         "Core visits (cwd)"]
                        [:v
                         (cmd "lua MiniVisits.add_label(\"core\")")
                         "Add \"core\" label"]
                        [:V
                         (cmd "lua MiniVisits.remove_label(\"core\")")
                         "Remove \"core\" label"]
                        [:l (cmd "lua MiniVisits.add_label()") "Add label"]
                        [:L
                         (cmd "lua MiniVisits.remove_label()")
                         "Remove label"]]}
                {:mode :x
                 :prefix :g
                 :group :Git
                 :maps [[:s
                         (cmd "lua MiniGit.show_at_cursor()")
                         "Show at selection"]]}
                {:mode :x
                 :prefix :l
                 :group :Language
                 :maps [[:f
                         (cmd "lua require(\"conform\").format()")
                         "Format selection"]]}]]
    (setup-direct-maps [[:n
                         "[p"
                         "<Cmd>exe \"iput! \" . v:register<CR>"
                         "Paste Above"]
                        [:n
                         "]p"
                         "<Cmd>exe \"iput \" . v:register<CR>"
                         "Paste Below"]])
    (setup-leader-groups groups)))

{: setup}
