{
  mkFullGtkCss = t: ''
    /* Legacy GTK Named Colors */
    @define-color bg_color ${t.barBg};
    @define-color fg_color ${t.textMain};
    @define-color base_color ${t.cardBg};
    @define-color text_color ${t.textMain};
    @define-color selected_bg_color ${t.accentPrimary};
    @define-color selected_fg_color ${t.activeBtnText};
    @define-color menubar_bg_color ${t.barBg};
    @define-color menubar_fg_color ${t.textMain};
    @define-color toolbar_bg_color ${t.barBg};
    @define-color toolbar_fg_color ${t.textMain};
    @define-color insensitive_bg_color ${t.cardBg};
    @define-color insensitive_fg_color ${t.textMuted};

    /* Libadwaita GTK Named Colors */
    @define-color theme_bg_color ${t.barBg};
    @define-color theme_fg_color ${t.textMain};
    @define-color theme_base_color ${t.cardBg};
    @define-color theme_text_color ${t.textMain};
    @define-color theme_selected_bg_color ${t.accentPrimary};
    @define-color theme_selected_fg_color ${t.activeBtnText};
    @define-color theme_hover_bg_color ${t.cardHover};
    @define-color theme_hover_fg_color ${t.accentPrimary};
    @define-color theme_unfocused_bg_color ${t.barBg};
    @define-color theme_unfocused_fg_color ${t.textMain};
    @define-color accent_color ${t.accentPrimary};
    @define-color accent_bg_color ${t.accentPrimary};
    @define-color accent_fg_color ${t.activeBtnText};
    @define-color window_bg_color ${t.barBg};
    @define-color window_fg_color ${t.textMain};
    @define-color view_bg_color ${t.cardBg};
    @define-color view_fg_color ${t.textMain};
    @define-color headerbar_bg_color ${t.barBg};
    @define-color headerbar_fg_color ${t.textMain};
    @define-color headerbar_backdrop_color ${t.barBg};
    @define-color headerbar_border_color ${t.borderNormal};
    @define-color card_bg_color ${t.cardBg};
    @define-color card_fg_color ${t.textMain};
    @define-color card_shade_color ${t.cardHover};
    @define-color shade_color ${t.shadowColor};
    @define-color dialog_bg_color ${t.barBg};
    @define-color dialog_fg_color ${t.textMain};
    @define-color popover_bg_color ${t.cardBg};
    @define-color popover_fg_color ${t.textMain};
    @define-color popover_shade_color ${t.cardBg};
    @define-color menu_bg_color ${t.cardBg};
    @define-color menu_fg_color ${t.textMain};
    @define-color tooltip_bg_color ${t.cardBg};
    @define-color tooltip_fg_color ${t.textMain};
    @define-color borders ${t.borderNormal};
    @define-color scrollbar_outline_color ${t.borderNormal};

    window,
    .background,
    window.background {
      background-color: ${t.barBg};
      color: ${t.textMain};
    }

    headerbar,
    .titlebar,
    actionbar {
      background-color: ${t.barBg};
      border-bottom: 2px solid ${t.borderNormal};
      color: ${t.textMain};
    }

    menubar,
    .menubar,
    menubar.background {
      background-color: ${t.barBg};
      color: ${t.textMain};
      border: none;
    }

    menubar > menuitem,
    .menubar > menuitem {
      background-color: transparent;
      color: ${t.textMain};
      padding: 4px 8px;
    }

    menubar > menuitem:hover,
    .menubar > menuitem:hover {
      background-color: ${t.cardHover};
      color: ${t.accentPrimary};
    }

    toolbar,
    .toolbar {
      background-color: ${t.barBg};
      color: ${t.textMain};
    }

    button,
    button:not(.flat),
    button.text-button,
    button.image-button,
    button.opaque {
      background-color: ${t.cardBg};
      background-image: none;
      color: ${t.textMain};
      border: 2px solid ${t.borderNormal};
      border-radius: 4px;
      box-shadow: 2px 2px 0px 0px ${t.shadowColor};
      transition: all 0.15s ease;
    }

    button:hover,
    button:not(.flat):hover,
    button.text-button:hover,
    button.image-button:hover,
    button.opaque:hover {
      background-color: ${t.cardHover};
      background-image: none;
      border-color: ${t.accentPrimary};
      color: ${t.accentPrimary};
      box-shadow: 2px 2px 0px 0px ${t.accentPrimary};
    }

    button:checked, button.suggested-action {
      background-color: ${t.accentPrimary};
      color: ${t.activeBtnText};
      border-color: ${t.accentPrimary};
      box-shadow: 2px 2px 0px 0px ${t.activeBtnShadow};
      font-weight: bold;
    }

    button.flat,
    headerbar button.flat {
      background-color: transparent;
      border: none;
      box-shadow: none;
    }

    button.flat:hover,
    headerbar button.flat:hover {
      background-color: ${t.cardHover};
      color: ${t.accentPrimary};
      border: none;
      box-shadow: none;
    }

    popover,
    popover.background,
    popover > contents,
    popover contents,
    .popover,
    menu,
    .menu,
    .context-menu {
      background-color: ${t.cardBg};
      color: ${t.textMain};
      border: 1px solid ${t.borderNormal};
      border-radius: 6px;
      box-shadow: 0px 4px 12px ${t.shadowColor};
      padding: 4px;
    }

    popover arrow,
    popover.background arrow {
      background-color: ${t.cardBg};
      border-color: ${t.borderNormal};
    }

    popover modelbutton,
    popover button,
    popover button.flat,
    menuitem,
    .menuitem,
    modelbutton,
    row,
    listview row,
    .dropdown row,
    dropdown popover contents listview row {
      background-color: transparent;
      color: ${t.textMain};
      border: none;
      box-shadow: none;
      border-radius: 4px;
      padding: 6px 10px;
      transition: background-color 0.1s ease, color 0.1s ease;
    }

    popover modelbutton:hover,
    popover button:hover,
    popover button.flat:hover,
    menuitem:hover,
    menu menuitem:hover,
    .menuitem:hover,
    modelbutton:hover,
    row:hover,
    listview row:hover,
    list row:hover,
    .dropdown row:hover,
    dropdown popover contents listview row:hover,
    popover modelbutton:focus,
    modelbutton:focus,
    menuitem:focus,
    row:focus {
      background-color: ${t.cardHover};
      color: ${t.accentPrimary};
      border: none;
      box-shadow: none;
    }

    popover modelbutton:hover label,
    popover modelbutton:hover image,
    popover modelbutton:hover GtkLabel,
    popover modelbutton:hover GtkImage,
    popover button:hover label,
    popover button:hover image,
    menuitem:hover label,
    menuitem:hover image,
    menuitem:hover GtkLabel,
    menuitem:hover GtkImage,
    modelbutton:hover label,
    modelbutton:hover image,
    row:hover label,
    row:hover image {
      color: ${t.accentPrimary};
    }

    popover modelbutton:selected,
    popover modelbutton:active,
    menuitem:selected,
    menuitem:active,
    row:selected,
    listview row:selected {
      background-color: ${t.accentPrimary};
      color: ${t.activeBtnText};
    }

    popover modelbutton:selected label,
    popover modelbutton:selected image,
    menuitem:selected label,
    menuitem:selected image,
    row:selected label,
    row:selected image {
      color: ${t.activeBtnText};
    }

    tooltip,
    tooltip.background,
    .tooltip,
    tooltip > contents {
      background-color: ${t.cardBg};
      color: ${t.textMain};
      border: 1px solid ${t.borderNormal};
      border-radius: 4px;
      box-shadow: 2px 2px 0px 0px ${t.shadowColor};
    }

    tooltip label {
      color: ${t.textMain};
    }

    combobox,
    dropdown {
      background-color: ${t.cardBg};
      color: ${t.textMain};
      border: 2px solid ${t.borderNormal};
      border-radius: 4px;
      padding: 4px 8px;
    }

    combobox:hover,
    dropdown:hover {
      border-color: ${t.accentPrimary};
    }

    combobox window,
    combobox popover,
    dropdown popover {
      background-color: ${t.cardBg};
      color: ${t.textMain};
      border: 1px solid ${t.borderNormal};
      border-radius: 6px;
    }

    scale trough {
      background-color: ${t.cardBg};
      border: 2px solid ${t.borderNormal};
      border-radius: 4px;
      min-height: 8px;
    }

    scale highlight {
      background-color: ${t.accentPrimary};
      border-radius: 2px;
    }

    scale slider {
      background-color: ${t.accentSecondary};
      border: 2px solid ${t.borderNormal};
      border-radius: 4px;
      min-width: 16px;
      min-height: 16px;
      box-shadow: 1px 1px 0px 0px ${t.shadowColor};
    }

    notebook tab {
      background-color: ${t.cardBg};
      border: 2px solid ${t.borderNormal};
      border-radius: 4px 4px 0 0;
      color: ${t.textMuted};
      font-weight: 700;
      padding: 4px 10px;
    }

    notebook tab:checked {
      background-color: ${t.accentPrimary};
      color: ${t.activeBtnText};
      border-color: ${t.accentPrimary};
    }

    entry {
      background-color: ${t.cardBg};
      color: ${t.textMain};
      border: 2px solid ${t.borderNormal};
      border-radius: 4px;
      padding: 4px 8px;
    }

    entry:focus {
      border-color: ${t.accentPrimary};
      box-shadow: 2px 2px 0px 0px ${t.accentPrimary};
    }

    scrollbar trough {
      background-color: ${t.barBg};
    }

    scrollbar slider {
      background-color: ${t.borderNormal};
      border-radius: 4px;
      min-width: 6px;
      min-height: 6px;
    }

    scrollbar slider:hover {
      background-color: ${t.accentPrimary};
    }

    separator {
      background-color: ${t.borderNormal};
      min-height: 1px;
      min-width: 1px;
    }

    list,
    listview,
    treeview {
      background-color: ${t.cardBg};
      color: ${t.textMain};
    }
  '';
}
