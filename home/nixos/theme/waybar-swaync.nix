{
  mkWaybarThemeCss = t: ''
    @define-color bar_bg ${t.barBg};
    @define-color text_main ${t.textMain};
    @define-color text_muted ${t.textMuted};
    @define-color text_secondary ${t.textSecondary};
    @define-color border_normal ${t.borderNormal};
    @define-color border_active ${t.borderActive};
    @define-color shadow_color ${t.shadowColor};
    @define-color card_bg ${t.cardBg};
    @define-color card_hover ${t.cardHover};

    /* Semantic accents */
    @define-color accent_primary ${t.accentPrimary};
    @define-color accent_primary_bright ${t.accentPrimaryBright};
    @define-color accent_secondary ${t.accentSecondary};
    @define-color accent_secondary_bright ${t.accentSecondaryBright};
    @define-color accent_success ${t.accentSuccess};
    @define-color accent_success_bright ${t.accentSuccessBright};
    @define-color accent_warning ${t.accentWarning};
    @define-color accent_warning_bright ${t.accentWarningBright};
    @define-color accent_danger ${t.accentDanger};
    @define-color accent_danger_bright ${t.accentDangerBright};
    @define-color accent_info ${t.accentInfo};
    @define-color accent_info_bright ${t.accentInfoBright};

    /* Compatibility aliases */
    @define-color accent_cyan ${t.accentPrimary};
    @define-color accent_fuchsia ${t.accentSecondary};
    @define-color accent_green ${t.accentSuccess};
    @define-color accent_yellow ${t.accentWarning};
    @define-color accent_red ${t.accentDanger};
    @define-color accent_blue ${t.accentInfo};

    @define-color active_btn_bg ${t.activeBtnBg};
    @define-color active_btn_text ${t.activeBtnText};
    @define-color active_btn_shadow ${t.activeBtnShadow};
  '';
}
