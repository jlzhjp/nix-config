(local vim _G.vim)
(var latest-term-buf nil)
(var latest-term-chan-id nil)

(fn setup-paredit-autocmd []
  (vim.api.nvim_create_autocmd :FileType
                               {:pattern [:clojure
                                          :racket
                                          :scheme
                                          :lisp
                                          :fennel]
                                :callback (fn []
                                            ((. (require :nvim-paredit) :setup) {:filetypes [:clojure
                                                                                             :fennel
                                                                                             :scheme
                                                                                             :lisp
                                                                                             :janet
                                                                                             :racket]})
                                            (vim.keymap.set :i "'" "'"
                                                            {:buffer true})
                                            (vim.keymap.set :i "`" "`"
                                                            {:buffer true}))}))

(fn setup-terminal-send []
  (let [track-terminal (fn [buf]
                         (let [terminal-id (vim.api.nvim_buf_get_var buf
                                                                     :terminal_job_id)]
                           (set latest-term-buf buf)
                           (set latest-term-chan-id terminal-id)))
        clear-tracked-terminal (fn [buf]
                                 (when (= buf latest-term-buf)
                                   (set latest-term-buf nil)
                                   (set latest-term-chan-id nil)))
        get-latest-term-chan-id (fn []
                                  (when latest-term-chan-id
                                    (let [status (. (vim.fn.jobwait [latest-term-chan-id]
                                                                    0)
                                                    1)]
                                      (if (= status -1)
                                          latest-term-chan-id
                                          (do
                                            (set latest-term-buf nil)
                                            (set latest-term-chan-id nil)
                                            nil)))))
        send-to-term (fn [lines]
                       (let [chan-id (get-latest-term-chan-id)]
                         (if (not chan-id)
                             (vim.notify "No active terminal found. Open a terminal first with <Leader>tt or :term"
                                         vim.log.levels.WARN)
                             (do
                               (table.insert lines "")
                               (vim.fn.chansend chan-id lines)))))
        send-line (fn []
                    (send-to-term [(vim.api.nvim_get_current_line)]))
        send-selection (fn []
                         (let [saved-reg (vim.fn.getreg :t)]
                           (vim.cmd "noau normal! \"<Esc>\"tygv")
                           (vim.cmd "noau normal! \"ty")
                           (let [text (vim.fn.getreg :t)]
                             (vim.fn.setreg :t saved-reg)
                             (send-to-term (vim.split text "\n")))))
        send-top-sexp (fn []
                        (let [view (vim.fn.winsaveview)
                              saved-reg (vim.fn.getreg :t)
                              found (vim.fn.search "^(" :bcW)]
                          (if (= found 0)
                              (vim.notify "Top-level S-expression not found!"
                                          vim.log.levels.WARN)
                              (do
                                (vim.cmd "noau normal! \"ty%")
                                (let [text (vim.fn.getreg :t)]
                                  (vim.fn.setreg :t saved-reg)
                                  (vim.fn.winrestview view)
                                  (send-to-term (vim.split text "\n")))))))]
    (vim.api.nvim_create_autocmd :TermOpen
                                 {:group (vim.api.nvim_create_augroup :latest-terminal-track
                                                                      {:clear true})
                                  :callback (fn [args]
                                              (track-terminal args.buf))})
    (vim.api.nvim_create_autocmd [:TermClose :BufWipeout]
                                 {:group :latest-terminal-track
                                  :callback (fn [args]
                                              (clear-tracked-terminal args.buf))})
    ;; Terminal Send Mappings
    (vim.keymap.set :n :<LocalLeader>l send-line {:desc "Send Line to Term"})
    (vim.keymap.set :x :<LocalLeader>v send-selection
                    {:desc "Send Selection to Term"})
    (vim.keymap.set :n :<LocalLeader>s send-top-sexp
                    {:desc "Send Top Sexp to Term"})))

(fn setup-treesitter-autocmd []
  (vim.api.nvim_create_autocmd :FileType
                               {:group (vim.api.nvim_create_augroup :tree-sitter-enable
                                                                    {:clear true})
                                :callback (fn [args]
                                            (let [lang (vim.treesitter.language.get_lang args.match)]
                                              (when lang
                                                (when (vim.treesitter.query.get lang
                                                                                :highlights)
                                                  (vim.treesitter.start args.buf))
                                                (when (vim.treesitter.query.get lang
                                                                                :folds)
                                                  (set vim.opt_local.foldmethod
                                                       :expr)
                                                  (set vim.opt_local.foldexpr
                                                       "v:lua.vim.treesitter.foldexpr()")))))}))

(fn setup-diagnostics []
  (vim.diagnostic.config {:signs {:text {vim.diagnostic.severity.ERROR ""
                                         vim.diagnostic.severity.WARN ""
                                         vim.diagnostic.severity.INFO ""
                                         vim.diagnostic.severity.HINT ""}}
                          :virtual_text {:spacing 4
                                         :source :if_many
                                         :prefix ""}}))

(fn setup-leap []
  (let [leap (require :leap)
        jump (fn [backward]
               (fn []
                 ((. leap :leap) {: backward})))]
    (vim.keymap.set [:n :x :o] :gs (jump false) {:desc "Leap forward"})
    (vim.keymap.set [:n :x :o] :gS (jump true) {:desc "Leap backward"})))

(fn setup-pack-commands []
  (let [pack-clean (fn []
                     (let [all-plugins (vim.pack.get)
                           unused []]
                       (each [_ plugin (ipairs all-plugins)]
                         (when (not plugin.active)
                           (table.insert unused plugin.spec.name)))
                       (if (= (length unused) 0)
                           (vim.notify "No unused plugins found."
                                       vim.log.levels.INFO)
                           (let [msg (.. "Remove the following unused plugins?\n"
                                         (table.concat unused "\n"))]
                             (when (= (vim.fn.confirm msg "&Yes\n&No" 2) 1)
                               (vim.pack.del unused)
                               (vim.notify (.. "Cleaned " (length unused)
                                               " plugins.")
                                           vim.log.levels.INFO))))))
        pack-update (fn []
                      (vim.pack.update))]
    (vim.api.nvim_create_user_command :PackClean pack-clean {})
    (vim.api.nvim_create_user_command :PackUpdate pack-update {})))

(fn setup []
  (setup-terminal-send)
  (setup-pack-commands)
  (setup-paredit-autocmd)
  (setup-leap)
  (setup-diagnostics)
  (setup-treesitter-autocmd))

{: setup :setup-paredit setup-paredit-autocmd}
