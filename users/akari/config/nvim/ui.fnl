(local vim _G.vim)

(fn lualine-component [name opts]
  (let [component (or opts {})]
    (tset component 1 name)
    component))

(fn setup-colorscheme []
  ((. (require :catppuccin) :setup) {:flavour :mocha
                                     :integrations {:bufferline true
                                                    :native_lsp {:enabled true}}})
  (vim.cmd "colorscheme catppuccin"))

(fn setup-bufferline []
  ((. (require :bufferline) :setup) {:options {:always_show_bufferline true
                                               :close_command "bdelete! %d"
                                               :color_icons true
                                               :diagnostics :nvim_lsp
                                               :diagnostics_indicator (fn [count
                                                                           _
                                                                           _
                                                                           _]
                                                                        (.. " "
                                                                            count))
                                               :hover {:enabled true
                                                       :delay 160
                                                       :reveal [:close]}
                                               :indicator {:style :underline}
                                               :left_mouse_command :buffer
                                               :middle_mouse_command "bdelete! %d"
                                               :modified_icon "●"
                                               :numbers :none
                                               :offsets [{:filetype :minifiles
                                                          :highlight :Directory
                                                          :separator true
                                                          :text :Files
                                                          :text_align :left}]
                                               :right_mouse_command "vertical sbuffer %d"
                                               :separator_style :slant
                                               :show_buffer_icons true
                                               :show_buffer_close_icons false
                                               :show_close_icon false
                                               :show_duplicate_prefix false
                                               :tab_size 18}}))

(fn setup-lualine []
  ((. (require :lualine) :setup) {:options {:component_separators {:left "│"
                                                                   :right "│"}
                                            :disabled_filetypes {:statusline [:minifiles
                                                                              :prompt]}
                                            :globalstatus true
                                            :icons_enabled true
                                            :section_separators {:left ""
                                                                 :right ""}}
                                  :sections {:lualine_a [:mode]
                                             :lualine_b [:branch
                                                         (lualine-component :diff
                                                                            {:symbols {:added "+ "
                                                                                       :modified "~ "
                                                                                       :removed "- "}})
                                                         (lualine-component :diagnostics
                                                                            {:sources [:nvim_lsp]
                                                                             :symbols {:error "E "
                                                                                       :warn "W "
                                                                                       :info "I "
                                                                                       :hint "H "}})]
                                             :lualine_c [(lualine-component :filename
                                                                            {:path 1
                                                                             :symbols {:modified " ●"
                                                                                       :readonly " "
                                                                                       :unnamed "[No Name]"}})]
                                             :lualine_x [(lualine-component :encoding
                                                                            {:show_bomb true})
                                                         :fileformat
                                                         :filetype]
                                             :lualine_y [:progress]
                                             :lualine_z [:location]}
                                  :inactive_sections {:lualine_a []
                                                      :lualine_b []
                                                      :lualine_c [(lualine-component :filename
                                                                                     {:path 1})]
                                                      :lualine_x [:location]
                                                      :lualine_y []
                                                      :lualine_z []}}))

(fn setup []
  (setup-colorscheme)
  (setup-bufferline)
  (setup-lualine))

{: setup}
