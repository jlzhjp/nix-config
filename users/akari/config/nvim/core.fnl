(local vim _G.vim)

(macro set-options [target specs]
  (let [forms []]
    (each [_ spec (ipairs specs)]
      (table.insert forms `(tset ,target ,(. spec 1) ,(. spec 2))))
    `(do
       ,(unpack forms))))

(fn setup []
  (set-options vim.g
               [[:mapleader " "]
                [:maplocalleader ","]
                [:rainbow_delimiters
                 {:whitelist [:clojure :racket :scheme :lisp :fennel]}]])
  (set-options vim.o
               [[:mouse :a]
                [:switchbuf :usetab]
                [:undofile true]
                [:shada "'100,<50,s10,:1000,/100,@100,h"]])
  ((. (require :vim._core.ui2) :enable))
  (vim.cmd "filetype plugin indent on")
  (when (not= (vim.fn.exists :syntax_on) 1)
    (vim.cmd "syntax enable"))
  (set-options vim.o [[:breakindent true]
                      [:breakindentopt "list:-1"]
                      [:colorcolumn :+1]
                      [:cursorline true]
                      [:linebreak true]
                      [:list true]
                      [:number true]
                      [:pumborder :single]
                      [:pumheight 10]
                      [:pummaxwidth 100]
                      [:relativenumber true]
                      [:ruler false]
                      [:shortmess :CFOSWaco]
                      [:showmode false]
                      [:signcolumn :yes]
                      [:splitbelow true]
                      [:splitkeep :screen]
                      [:splitright true]
                      [:winborder :single]
                      [:wrap false]
                      [:cursorlineopt "screenline,number"]
                      [:fillchars "eob: ,fold:╌"]
                      [:listchars "extends:…,nbsp:␣,precedes:…,tab:> "]
                      [:foldlevel 10]
                      [:foldmethod :indent]
                      [:foldnestmax 10]
                      [:foldtext ""]])
  (set-options vim.o [[:autoindent true]
                      [:expandtab true]
                      [:formatoptions :rqnl1j]
                      [:ignorecase true]
                      [:incsearch true]
                      [:infercase true]
                      [:shiftwidth 2]
                      [:smartcase true]
                      [:smartindent true]
                      [:spelloptions :camel]
                      [:tabstop 8]
                      [:virtualedit :block]
                      [:iskeyword "@,48-57,_,192-255,-"]
                      [:formatlistpat "^\\s*[0-9\\-\\+\\*]\\+[\\.)]*\\s\\+"]
                      [:complete ".,w,b,kspell"]
                      [:completeopt "menuone,noselect,fuzzy,nosort"]
                      [:completetimeout 100]]))

{: setup}
