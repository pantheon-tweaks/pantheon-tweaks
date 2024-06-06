/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: elementary Tweaks Developers, 2016-2020
 *                         Pantheon Tweaks Developers, 2020-2024
 *
 * Some code borrowed from:
 * elementary/switchboard-plug-pantheon-shell, src/Views/Appearance.vala
 */

public class PantheonTweaks.Panes.AppearancePane : Categories.Pane {
    private Gee.HashMap<string, string> preset_button_layouts;
    private XSettings x_settings;
    private GLib.Settings interface_settings;
    private GLib.Settings appearance_settings;

    private Categories.Pane.ComboBoxText gtk_combobox;
    private Categories.Pane.ComboBoxText controls_combobox;
    private Categories.Pane.Switch gnome_menu;

    public AppearancePane () {
        base (
            "appearance", _("Appearance"), "preferences-desktop",
            _("Change the theme and button layout of windows. Changing theme may cause visibility issue.")
        );
    }

    construct {
        interface_settings = new GLib.Settings ("org.gnome.desktop.interface");
        var sound_settings = new GLib.Settings ("org.gnome.desktop.sound");
        x_settings = new XSettings ();
        var gtk_settings = new GtkSettings ();
        appearance_settings = new GLib.Settings ("org.pantheon.desktop.gala.appearance");
        var gnome_wm_settings = new GLib.Settings ("org.gnome.desktop.wm.preferences");

        Pantheon.AccountsService? pantheon_act = null;

        string? user_path = null;
        try {
            FDO.Accounts? accounts_service = GLib.Bus.get_proxy_sync (
                GLib.BusType.SYSTEM,
               "org.freedesktop.Accounts",
               "/org/freedesktop/Accounts"
            );

            user_path = accounts_service.find_user_by_name (GLib.Environment.get_user_name ());
        } catch (Error e) {
            critical (e.message);
        }

        if (user_path != null) {
            try {
                pantheon_act = GLib.Bus.get_proxy_sync (
                    GLib.BusType.SYSTEM,
                    "org.freedesktop.Accounts",
                    user_path,
                    GLib.DBusProxyFlags.GET_INVALIDATED_PROPERTIES
                );
            } catch (Error e) {
                warning ("Unable to get AccountsService proxy, color scheme preference may be incorrect");
            }
        }

        var theme_label = new Granite.HeaderLabel (_("Theme Settings"));

        var gtk_label = new SummaryLabel (_("GTK:"));
        var gtk_list = ThemeSettings.get_themes ("themes", "gtk-3.0");
        gtk_combobox = new ComboBoxText.from_list (gtk_list);

        /// TRANSLATORS: The "%s" represents the path where custom themes are installed
        var gtk_info = new DimLabel (_("To show custom themes here, put them in %s.").printf (
            "~/.local/share/themes/<%s>/gtk-3.0".printf (_("theme-name"))
        ));

        var gtk_dir_button = new DestinationButton (".local/share/themes");

        var icon_label = new SummaryLabel (_("Icons:"));
        var icon_list = ThemeSettings.get_themes ("icons", "index.theme");
        var icon_combobox = new ComboBoxText.from_list (icon_list);

        /// TRANSLATORS: The "%s" represents the path where custom icons are installed
        var icon_info = new DimLabel (_("To show custom icons here, put them in %s.").printf (
            "~/.icons/<%s>".printf (_("theme-name"))
        ));

        var icon_dir_button = new DestinationButton (".icons");

        var cursor_label = new SummaryLabel (_("Cursor:"));
        var cursor_list = ThemeSettings.get_themes ("icons", "cursors");
        var cursor_combobox = new ComboBoxText.from_list (cursor_list);

        /// TRANSLATORS: The "%s" represents the path where custom cursors are installed
        var cursor_info = new DimLabel (_("To show custom cursors here, put them in %s.").printf (
            "~/.icons/<%s>/cursors".printf (_("theme-name"))
        ));

        var cursor_dir_button = new DestinationButton (".icons");

        var sound_label = new SummaryLabel (_("Sound:"));
        var sound_list = ThemeSettings.get_themes ("sounds", "index.theme");
        var sound_combobox = new ComboBoxText.from_list (sound_list);

        /// TRANSLATORS: The "%s" represents the path where custom sounds are installed
        var sound_info = new DimLabel (_("To show custom sounds here, put them in %s.").printf (
            "~/.local/share/sounds/<%s>".printf (_("theme-name"))
        ));

        var sound_dir_button = new DestinationButton (".local/share/sounds");

        var dark_style_label = new SummaryLabel (_("Force to use dark stylesheet:"));
        var dark_style_switch = new Switch ();
        var prefer_dark_info = new DimLabel (
            _("Forces dark style on all apps, even if it's not supported. Requires restarting the application.")
        );

        var layout_label = new Granite.HeaderLabel (_("Window Controls"));

        var controls_label = new SummaryLabel (_("Layout:"));
        var controls_map = get_preset_button_layouts ();
        controls_combobox = new ComboBoxText (controls_map);
        var controls_info = new DimLabel (_("Changes button layout of the window."));

        var gnome_menu_label = new SummaryLabel (_("Show GNOME menu:"));
        gnome_menu = new Switch ();
        var gnome_menu_info = new DimLabel (_("Whether to show GNOME menu in GNOME apps."));

        init_data ();

        content_area.attach (theme_label, 0, 0, 1, 1);
        content_area.attach (gtk_label, 0, 1, 1, 1);
        content_area.attach (gtk_combobox, 1, 1, 1, 1);
        content_area.attach (gtk_info, 1, 2, 1, 1);
        content_area.attach (gtk_dir_button, 2, 2, 1, 1);
        content_area.attach (icon_label, 0, 3, 1, 1);
        content_area.attach (icon_combobox, 1, 3, 1, 1);
        content_area.attach (icon_info, 1, 4, 1, 1);
        content_area.attach (icon_dir_button, 2, 4, 1, 1);
        content_area.attach (cursor_label, 0, 5, 1, 1);
        content_area.attach (cursor_combobox, 1, 5, 1, 1);
        content_area.attach (cursor_info, 1, 6, 1, 1);
        content_area.attach (cursor_dir_button, 2, 6, 1, 1);
        content_area.attach (sound_label, 0, 7, 1, 1);
        content_area.attach (sound_combobox, 1, 7, 1, 1);
        content_area.attach (sound_info, 1, 8, 1, 1);
        content_area.attach (sound_dir_button, 2, 8, 1, 1);
        content_area.attach (dark_style_label, 0, 9, 1, 1);
        content_area.attach (dark_style_switch, 1, 9, 1, 1);
        content_area.attach (prefer_dark_info, 1, 10, 1, 1);
        content_area.attach (layout_label, 0, 11, 1, 1);
        content_area.attach (controls_label, 0, 12, 1, 1);
        content_area.attach (controls_combobox, 1, 12, 1, 1);
        content_area.attach (controls_info, 1, 13, 1, 1);
        content_area.attach (gnome_menu_label, 0, 14, 1, 1);
        content_area.attach (gnome_menu, 1, 14, 1, 1);
        content_area.attach (gnome_menu_info, 1, 15, 1, 1);

        show_all ();

        interface_settings.bind ("icon-theme", icon_combobox, "active_id", SettingsBindFlags.DEFAULT);
        interface_settings.bind ("cursor-theme", cursor_combobox, "active_id", SettingsBindFlags.DEFAULT);
        sound_settings.bind ("theme-name", sound_combobox, "active_id", SettingsBindFlags.DEFAULT);
        dark_style_switch.bind_property ("active", gtk_settings, "prefer-dark-theme", BindingFlags.SYNC_CREATE | BindingFlags.BIDIRECTIONAL);

        if (((GLib.DBusProxy) pantheon_act).get_cached_property ("PrefersAccentColor") != null) {
            ((GLib.DBusProxy) pantheon_act).g_properties_changed.connect ((changed, invalid) => {
                gtk_combobox.active_id = interface_settings.get_string ("gtk-theme");
            });
        }

        gtk_combobox.changed.connect (() => {
            interface_settings.set_string ("gtk-theme", gtk_combobox.active_id);

            if (gtk_combobox.active_id.has_prefix (ThemeSettings.ELEMENTARY_STYLESHEET_PREFIX)) {
                ThemeSettings.AccentColor color = ThemeSettings.parse_accent_color (gtk_combobox.active_id);
                if (((GLib.DBusProxy) pantheon_act).get_cached_property ("PrefersAccentColor") != null) {
                    pantheon_act.prefers_accent_color = color;
                }
            }
        });

        controls_combobox.changed.connect (() => {
            string new_layout = controls_combobox.active_id;
            appearance_settings.set_string ("button-layout", new_layout);
            gnome_wm_settings.set_string ("button-layout", new_layout);
            x_settings.set_gnome_menu (gnome_menu.state, new_layout);
        });

        gnome_menu.notify["active"].connect (() => {
            controls_combobox.changed ();
        });

        on_click_reset (()=> {
            string[] keys = {"gtk-theme", "icon-theme", "cursor-theme"};

            foreach (var key in keys) {
                interface_settings.reset (key);
            }

            if (((GLib.DBusProxy) pantheon_act).get_cached_property ("PrefersAccentColor") != null) {
                pantheon_act.prefers_accent_color = ThemeSettings.AccentColor.BLUE;
            }

            sound_settings.reset ("theme-name");
            appearance_settings.reset ("button-layout");
            gnome_wm_settings.reset ("button-layout");
            x_settings.reset ();

            gtk_settings.prefer_dark_theme = false;
            init_data ();
        });
    }

    private void init_data () {
        gtk_combobox.active_id = interface_settings.get_string ("gtk-theme");
        controls_combobox.active_id = appearance_settings.get_string ("button-layout");
        gnome_menu.state = x_settings.has_gnome_menu ();
    }

    private Gee.HashMap<string, string> get_preset_button_layouts () {
        if (preset_button_layouts == null) {
            preset_button_layouts = new Gee.HashMap<string, string> ();
            preset_button_layouts["close:maximize"] = _("elementary");
            preset_button_layouts["maximize:close"] = _("elementary Reversed");
            preset_button_layouts[":close"] = _("Close Only Right");
            preset_button_layouts["close:"] = _("Close Only Left");
            preset_button_layouts["close,minimize:maximize"] = _("Add Minimize Left");
            preset_button_layouts["close:minimize,maximize"] = _("Add Minimize Right");
            preset_button_layouts["close:minimize"] = _("Replace Maximize to Minimize");
            preset_button_layouts[":minimize,maximize,close"] = _("Windows");
            preset_button_layouts["close,minimize,maximize"] = _("macOS");
            preset_button_layouts["close,maximize,minimize"] = _("Ubuntu");
        }

        return preset_button_layouts;
    }
}
