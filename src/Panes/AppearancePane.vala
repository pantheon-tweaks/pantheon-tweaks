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
    private GtkSettings gtk_settings;
    private GLib.Settings interface_settings;
    private GLib.Settings sound_settings;
    private GLib.Settings appearance_settings;
    private GLib.Settings gnome_wm_settings;
    private Pantheon.AccountsService? pantheon_act = null;

    private Gtk.ComboBoxText gtk_combobox;
    private Gtk.ComboBoxText controls_combobox;
    private Gtk.Switch gnome_menu_switch;

    public AppearancePane () {
        base (
            "appearance", _("Appearance"), "preferences-desktop",
            _("Change the theme and button layout of windows. Changing theme may cause visibility issue.")
        );
    }

    construct {
        interface_settings = new GLib.Settings ("org.gnome.desktop.interface");
        sound_settings = new GLib.Settings ("org.gnome.desktop.sound");
        x_settings = new XSettings ();
        gtk_settings = new GtkSettings ();
        appearance_settings = new GLib.Settings ("org.pantheon.desktop.gala.appearance");
        gnome_wm_settings = new GLib.Settings ("org.gnome.desktop.wm.preferences");

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

        /*************************************************/
        /* GTK Theme                                     */
        /*************************************************/
        var gtk_label = new Granite.HeaderLabel (_("GTK Theme")) {
            /// TRANSLATORS: The "%s" represents the path where custom themes are installed
            secondary_text = _("To show custom themes here, put them in %s.").printf (
                "~/.local/share/themes/\"%s\"/gtk-3.0".printf (_("theme-name"))
            ),
            hexpand = true
        };
        var gtk_list = ThemeSettings.get_themes ("themes", "gtk-3.0");
        gtk_combobox = combobox_text_new_from_list (gtk_list);
        gtk_combobox.valign = Gtk.Align.CENTER;

        var gtk_dir_button = new DestinationButton (".local/share/themes");

        var gtk_theme_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 12);
        gtk_theme_box.append (gtk_label);
        gtk_theme_box.append (gtk_combobox);
        gtk_theme_box.append (gtk_dir_button);

        /*************************************************/
        /* Icons                                         */
        /*************************************************/
        var icon_label = new Granite.HeaderLabel (_("Icons")) {
            /// TRANSLATORS: The "%s" represents the path where custom icons are installed
            secondary_text = _("To show custom icons here, put them in %s.").printf (
                "~/.icons/\"%s\"".printf (_("theme-name"))
            ),
            hexpand = true
        };
        var icon_list = ThemeSettings.get_themes ("icons", "index.theme");
        var icon_combobox = combobox_text_new_from_list (icon_list);
        icon_combobox.valign = Gtk.Align.CENTER;

        var icon_dir_button = new DestinationButton (".icons");

        var icon_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 12);
        icon_box.append (icon_label);
        icon_box.append (icon_combobox);
        icon_box.append (icon_dir_button);

        /*************************************************/
        /* Cursor                                        */
        /*************************************************/
        var cursor_label = new Granite.HeaderLabel (_("Cursor")) {
            /// TRANSLATORS: The "%s" represents the path where custom cursors are installed
            secondary_text = _("To show custom cursors here, put them in %s.").printf (
                "~/.icons/\"%s\"/cursors".printf (_("theme-name"))
            ),
            hexpand = true
        };
        var cursor_list = ThemeSettings.get_themes ("icons", "cursors");
        var cursor_combobox = combobox_text_new_from_list (cursor_list);
        cursor_combobox.valign = Gtk.Align.CENTER;

        var cursor_dir_button = new DestinationButton (".icons");

        var cursor_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 12);
        cursor_box.append (cursor_label);
        cursor_box.append (cursor_combobox);
        cursor_box.append (cursor_dir_button);

        /*************************************************/
        /* Sound                                         */
        /*************************************************/
        var sound_label = new Granite.HeaderLabel (_("Sound")) {
            /// TRANSLATORS: The "%s" represents the path where custom sounds are installed
            secondary_text = _("To show custom sounds here, put them in %s.").printf (
                "~/.local/share/sounds/\"%s\"".printf (_("theme-name"))
            ),
            hexpand = true
        };
        var sound_list = ThemeSettings.get_themes ("sounds", "index.theme");
        var sound_combobox = combobox_text_new_from_list (sound_list);
        sound_combobox.valign = Gtk.Align.CENTER;

        var sound_dir_button = new DestinationButton (".local/share/sounds");

        var sound_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 12);
        sound_box.append (sound_label);
        sound_box.append (sound_combobox);
        sound_box.append (sound_dir_button);

        /*************************************************/
        /* Force Dark Style                              */
        /*************************************************/
        var dark_style_label = new Granite.HeaderLabel (_("Force Dark Style")) {
            secondary_text = _("Forces dark style on all apps, even if it's not supported. Requires restarting the application."),
            hexpand = true
        };
        var dark_style_switch = new Gtk.Switch () {
            valign = Gtk.Align.CENTER
        };

        var dark_style_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 12);
        dark_style_box.append (dark_style_label);
        dark_style_box.append (dark_style_switch);

        /*************************************************/
        /* Window Control Layout                         */
        /*************************************************/
        var controls_label = new Granite.HeaderLabel (_("Window Control Layout")) {
            secondary_text = _("Changes button layout of the window."),
            hexpand = true
        };
        var controls_map = get_preset_button_layouts ();
        controls_combobox = combobox_text_new (controls_map);
        controls_combobox.valign = Gtk.Align.CENTER;

        var controls_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 12) {
            margin_top = 24
        };
        controls_box.append (controls_label);
        controls_box.append (controls_combobox);

        /*************************************************/
        /* Show GNOME Menu                               */
        /*************************************************/
        var gnome_menu_switch_label = new Granite.HeaderLabel (_("Show GNOME Menu")) {
            secondary_text = _("Whether to show GNOME menu in GNOME apps."),
            hexpand = true
        };
        gnome_menu_switch = new Gtk.Switch () {
            valign = Gtk.Align.CENTER
        };

        var gnome_menu_switch_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 12);
        gnome_menu_switch_box.append (gnome_menu_switch_label);
        gnome_menu_switch_box.append (gnome_menu_switch);

        init_data ();

        content_area.attach (gtk_theme_box, 0, 0, 1, 1);
        content_area.attach (icon_box, 0, 1, 1, 1);
        content_area.attach (cursor_box, 0, 2, 1, 1);
        content_area.attach (sound_box, 0, 3, 1, 1);
        content_area.attach (dark_style_box, 0, 4, 1, 1);
        content_area.attach (controls_box, 0, 5, 1, 1);
        content_area.attach (gnome_menu_switch_box, 0, 6, 1, 1);

        interface_settings.bind ("icon-theme", icon_combobox, "active_id", SettingsBindFlags.DEFAULT);
        interface_settings.bind ("cursor-theme", cursor_combobox, "active_id", SettingsBindFlags.DEFAULT);
        sound_settings.bind ("theme-name", sound_combobox, "active_id", SettingsBindFlags.DEFAULT);
        gtk_settings.bind_property ("prefer-dark-theme", dark_style_switch, "active", BindingFlags.SYNC_CREATE | BindingFlags.BIDIRECTIONAL);

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
            x_settings.set_gnome_menu (gnome_menu_switch.active, new_layout);
        });

        gnome_menu_switch.notify["active"].connect (() => {
            controls_combobox.changed ();
        });
    }

    protected override void do_reset () {
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
    }

    private void init_data () {
        gtk_combobox.active_id = interface_settings.get_string ("gtk-theme");
        controls_combobox.active_id = appearance_settings.get_string ("button-layout");
        gnome_menu_switch.active = x_settings.has_gnome_menu ();
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
