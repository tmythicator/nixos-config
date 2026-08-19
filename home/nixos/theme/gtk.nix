{
  mkFullGtkCss = t: ''
    /* ==========================================================================
       Libadwaita Palette Definition
       ========================================================================== */
    @define-color bg_color ${t.barBg};
    @define-color fg_color ${t.textMain};
    @define-color base_color ${t.cardBg};
    @define-color text_color ${t.textMain};
    @define-color selected_bg_color ${t.accentPrimary};
    @define-color selected_fg_color ${t.activeBtnText};

    @define-color theme_bg_color ${t.barBg};
    @define-color theme_fg_color ${t.textMain};
    @define-color theme_base_color ${t.cardBg};
    @define-color theme_text_color ${t.textMain};
    @define-color theme_selected_bg_color ${t.accentPrimary};
    @define-color theme_selected_fg_color ${t.activeBtnText};
    @define-color theme_hover_bg_color ${t.cardHover};

    @define-color accent_color ${t.accentPrimary};
    @define-color accent_bg_color ${t.accentPrimary};
    @define-color accent_fg_color ${t.activeBtnText};
    @define-color window_bg_color ${t.barBg};
    @define-color window_fg_color ${t.textMain};
    @define-color view_bg_color ${t.cardBg};
    @define-color view_fg_color ${t.textMain};
    @define-color headerbar_bg_color ${t.barBg};
    @define-color headerbar_fg_color ${t.textMain};
    @define-color card_bg_color ${t.cardBg};
    @define-color card_fg_color ${t.textMain};
    @define-color popover_bg_color ${t.cardBg};
    @define-color popover_fg_color ${t.textMain};
    @define-color dialog_bg_color ${t.barBg};
    @define-color dialog_fg_color ${t.textMain};
    @define-color borders ${t.borderNormal};
    @define-color shadow_col ${t.shadowColor};
    @define-color active_shadow_col ${t.activeBtnShadow};

    /* ==========================================================================
       Base Surfaces & Headers
       ========================================================================== */
    window, .background, menubar, toolbar, .toolbar {
      background-color: @window_bg_color;
      color: @window_fg_color;
    }

    headerbar, .titlebar, actionbar {
      background-color: @headerbar_bg_color;
      color: @headerbar_fg_color;
      border-bottom: 2px solid @borders;
    }

    /* ==========================================================================
       Buttons
       ========================================================================== */
    button, button.text-button, button.image-button, button.opaque {
      background-color: @card_bg_color;
      background-image: none;
      color: @card_fg_color;
      border: 2px solid @borders;
      border-radius: 4px;
      box-shadow: 2px 2px 0px 0px @shadow_col;
      transition: all 0.15s ease;
    }

    button:hover {
      background-color: @theme_hover_bg_color;
      border-color: @accent_color;
      color: @accent_color;
      box-shadow: 2px 2px 0px 0px @accent_color;
    }

    button:checked, button.suggested-action {
      background-color: @accent_bg_color;
      color: @accent_fg_color;
      border-color: @accent_bg_color;
      box-shadow: 2px 2px 0px 0px @active_shadow_col;
      font-weight: bold;
    }

    button.flat, headerbar button.flat {
      background-color: transparent;
      border: none;
      box-shadow: none;
    }
    button.flat:hover, headerbar button.flat:hover {
      background-color: @theme_hover_bg_color;
      color: @accent_color;
    }

    /* ==========================================================================
       Popovers, Menus, Dropdowns
       ========================================================================== */
    popover contents, popover.background, menu, .menu, .context-menu {
      background-color: @popover_bg_color;
      color: @popover_fg_color;
      border: 1px solid @borders;
      border-radius: 6px;
      box-shadow: 0px 4px 12px @shadow_col;
      padding: 4px;
    }

    menuitem, modelbutton, row, listview row, .dropdown row {
      background-color: transparent;
      color: @popover_fg_color;
      border: none;
      box-shadow: none;
      border-radius: 4px;
      padding: 6px 10px;
      transition: background-color 0.1s ease, color 0.1s ease;
    }

    menuitem:hover, modelbutton:hover, row:hover, listview row:hover, .dropdown row:hover {
      background-color: @theme_hover_bg_color;
      color: @accent_color;
    }

    /* ==========================================================================
       Selections
       ========================================================================== */
    selection, *:selected,
    menuitem:selected, modelbutton:selected,
    row:selected, listview row:selected, columnview row:selected,
    treeview:selected, treeview.view:selected, iconview:selected, view:selected {
      background-color: @accent_bg_color;
      color: @accent_fg_color;
    }

    /* ==========================================================================
       Inputs, Sliders, Tabs, Other
       ========================================================================== */
    entry, combobox, dropdown {
      background-color: @card_bg_color;
      color: @card_fg_color;
      border: 2px solid @borders;
      border-radius: 4px;
      padding: 4px 8px;
    }
    entry:focus, combobox:hover, dropdown:hover {
      border-color: @accent_color;
      box-shadow: 2px 2px 0px 0px @accent_color;
    }

    scale trough {
      background-color: @card_bg_color;
      border: 2px solid @borders;
      border-radius: 4px;
      min-height: 8px;
    }
    scale highlight { background-color: @accent_bg_color; border-radius: 2px; }
    scale slider {
      background-color: ${t.accentSecondary};
      border: 2px solid @borders;
      border-radius: 4px;
      min-width: 16px;
      min-height: 16px;
      box-shadow: 1px 1px 0px 0px @shadow_col;
    }

    notebook tab {
      background-color: @card_bg_color;
      border: 2px solid @borders;
      border-radius: 4px 4px 0 0;
      color: ${t.textMuted};
      font-weight: 700;
      padding: 4px 10px;
    }
    notebook tab:checked {
      background-color: @accent_bg_color;
      color: @accent_fg_color;
      border-color: @accent_bg_color;
    }

    scrollbar trough { background-color: @window_bg_color; }
    scrollbar slider {
      background-color: @borders;
      border-radius: 4px;
      min-width: 6px;
      min-height: 6px;
    }
    scrollbar slider:hover { background-color: @accent_color; }

    separator { background-color: @borders; min-height: 1px; min-width: 1px; }

    tooltip, tooltip > contents, .tooltip {
      background-color: @card_bg_color;
      color: @card_fg_color;
      border: 1px solid @borders;
      border-radius: 4px;
      box-shadow: 2px 2px 0px 0px @shadow_col;
    }
  '';
}
