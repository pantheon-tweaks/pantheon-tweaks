/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: elementary Tweaks Developers, 2016-2020
 *                         Pantheon Tweaks Developers, 2020-2025
 *
 * Some code borrowed from:
 * elementary/switchboard-plug-pantheon-shell, src/Views/Appearance.vala
 */

public class PantheonTweaks.Panes.AppearancePane : BasePane {
    private XSettings x_settings;
    private GtkSettings gtk_settings;
    private Settings interface_settings;
    private Settings sound_settings;
    private Settings gnome_wm_settings;
    private Pantheon.AccountsService? pantheon_act = null;

    private Gtk.ComboBoxText gtk_combobox;
    private Gtk.Switch gnome_menu_switch;

    private ListStore controls_list;
    private Gtk.DropDown controls_combobox;

    public AppearancePane () {
        base (
            "appearance", _("Appearance"), "preferences-desktop",
            _("Change the theme and button layout of windows. Changing theme may cause visibility issue.")
        );
    }

    construct {
        interface_settings = new Settings ("org.gnome.desktop.interface");
        sound_settings = new Settings ("org.gnome.desktop.sound");
        x_settings = new XSettings ();
        gtk_settings = new GtkSettings ();
        gnome_wm_settings = new Settings ("org.gnome.desktop.wm.preferences");

        string? user_path = null;
        try {
            FDO.Accounts? accounts_service = Bus.get_proxy_sync (
                BusType.SYSTEM,
               "org.freedesktop.Accounts",
               "/org/freedesktop/Accounts"
            );

            user_path = accounts_service.find_user_by_name (Environment.get_user_name ());
        } catch (Error e) {
            critical (e.message);
        }

        if (user_path != null) {
            try {
                pantheon_act = Bus.get_proxy_sync (
                    BusType.SYSTEM,
                    "org.freedesktop.Accounts",
                    user_path,
                    DBusProxyFlags.GET_INVALIDATED_PROPERTIES
                );
            } catch (Error err) {
                warning ("Unable to get AccountsService proxy, color scheme preference may be incorrect: %s",
                        err.message);
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
        var gtk_list = ThemeSettings.fetch_gtk_themes ();
        gtk_combobox = combobox_text_new_from_list (gtk_list);

        var gtk_dir_button = new OpenButton (
            Path.build_filename (Environment.get_home_dir (), ".local", "share", "themes")
        );

        var gtk_theme_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 12);
        gtk_theme_box.append (gtk_label);
        gtk_theme_box.append (gtk_combobox);
        gtk_theme_box.append (gtk_dir_button);

        /*************************************************/
        /* Icon Theme                                    */
        /*************************************************/
        var icon_label = new Granite.HeaderLabel (_("Icon Theme")) {
            /// TRANSLATORS: The "%s" represents the path where custom icons are installed
            secondary_text = _("To show custom icons here, put them in %s.").printf (
                "~/.icons/\"%s\"".printf (_("theme-name"))
            ),
            hexpand = true
        };
        var icon_list = ThemeSettings.fetch_icon_themes ();
        var icon_combobox = combobox_text_new_from_list (icon_list);

        var icon_dir_button = new OpenButton (
            Path.build_filename (Environment.get_home_dir (), ".icons")
        );

        var icon_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 12);
        icon_box.append (icon_label);
        icon_box.append (icon_combobox);
        icon_box.append (icon_dir_button);

        /*************************************************/
        /* Cursor Theme                                  */
        /*************************************************/
        var cursor_label = new Granite.HeaderLabel (_("Cursor Theme")) {
            /// TRANSLATORS: The "%s" represents the path where custom cursors are installed
            secondary_text = _("To show custom cursors here, put them in %s.").printf (
                "~/.icons/\"%s\"/cursors".printf (_("theme-name"))
            ),
            hexpand = true
        };
        var cursor_list = ThemeSettings.fetch_cursor_themes ();
        var cursor_combobox = combobox_text_new_from_list (cursor_list);

        var cursor_dir_button = new OpenButton (
            Path.build_filename (Environment.get_home_dir (), ".icons")
        );

        var cursor_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 12);
        cursor_box.append (cursor_label);
        cursor_box.append (cursor_combobox);
        cursor_box.append (cursor_dir_button);

        /*************************************************/
        /* Sound Theme                                   */
        /*************************************************/
        var sound_label = new Granite.HeaderLabel (_("Sound Theme")) {
            /// TRANSLATORS: The "%s" represents the path where custom sounds are installed
            secondary_text = _("To show custom sounds here, put them in %s.").printf (
                "~/.local/share/sounds/\"%s\"".printf (_("theme-name"))
            ),
            hexpand = true
        };
        var sound_list = ThemeSettings.fetch_sound_themes ();
        var sound_combobox = combobox_text_new_from_list (sound_list);

        var sound_dir_button = new OpenButton (
            Path.build_filename (Environment.get_home_dir (), ".local", "share", "sounds")
        );

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

        controls_list = new ListStore (typeof (ListItemModel));
        controls_list.append (new ListItemModel ("close:maximize", _("elementary")));
        controls_list.append (new ListItemModel ("maximize:close", _("elementary Reversed")));
        controls_list.append (new ListItemModel (":close", _("Close Only Right")));
        controls_list.append (new ListItemModel ("close:", _("Close Only Left")));
        controls_list.append (new ListItemModel ("close,minimize:maximize", _("Add Minimize Left")));
        controls_list.append (new ListItemModel ("close:minimize,maximize", _("Add Minimize Right")));
        controls_list.append (new ListItemModel ("close:minimize", _("Replace Maximize to Minimize")));
        controls_list.append (new ListItemModel (":minimize,maximize,close", _("Windows")));
        controls_list.append (new ListItemModel ("close,minimize,maximize", _("macOS")));
        controls_list.append (new ListItemModel ("close,maximize,minimize", _("Windows Reversed")));

        controls_combobox = dropdown_new (controls_list);

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
        controls_settings_to_combo ();

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

        if (((DBusProxy) pantheon_act).get_cached_property ("PrefersAccentColor") != null) {
            ((DBusProxy) pantheon_act).g_properties_changed.connect ((changed, invalid) => {
                gtk_combobox.active_id = interface_settings.get_string ("gtk-theme");
            });
        }

        gtk_combobox.changed.connect (() => {
            interface_settings.set_string ("gtk-theme", gtk_combobox.active_id);

            if (gtk_combobox.active_id.has_prefix (ThemeSettings.ELEMENTARY_STYLESHEET_PREFIX)) {
                ThemeSettings.AccentColor color = ThemeSettings.parse_accent_color (gtk_combobox.active_id);
                if (((DBusProxy) pantheon_act).get_cached_property ("PrefersAccentColor") != null) {
                    pantheon_act.prefers_accent_color = color;
                }
            }
        });

        gnome_wm_settings.changed["button-layout"].connect (controls_settings_to_combo);
        controls_combobox.notify["selected"].connect (controls_combo_to_settings);
        gnome_menu_switch.notify["active"].connect (controls_combo_to_settings);
    }

    protected override void do_reset () {
        string[] keys = {"gtk-theme", "icon-theme", "cursor-theme"};

        foreach (var key in keys) {
            interface_settings.reset (key);
        }

        if (((DBusProxy) pantheon_act).get_cached_property ("PrefersAccentColor") != null) {
            pantheon_act.prefers_accent_color = ThemeSettings.AccentColor.BLUE;
        }

        sound_settings.reset ("theme-name");
        gnome_wm_settings.reset ("button-layout");
        x_settings.reset ();

        gtk_settings.prefer_dark_theme = false;
        init_data ();
    }

    private void controls_settings_to_combo () {
        string selected_id = gnome_wm_settings.get_string ("button-layout");
        uint selected_pos = ListItemModel.liststore_get_position (controls_list, selected_id);

        if (controls_combobox.selected == selected_pos) {
            return;
        }

        controls_combobox.selected = selected_pos;
    }

    private void controls_combo_to_settings () {
        uint selected_pos = controls_combobox.selected;
        string? selected_id = ListItemModel.liststore_get_id (controls_list, selected_pos);

        if (selected_id == null) {
            return;
        }

        gnome_wm_settings.set_string ("button-layout", selected_id);
        x_settings.set_gnome_menu (gnome_menu_switch.active, selected_id);
    }

    private void init_data () {
        gtk_combobox.active_id = interface_settings.get_string ("gtk-theme");
        gnome_menu_switch.active = x_settings.has_gnome_menu ();
    }
}
