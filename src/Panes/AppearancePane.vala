/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: elementary Tweaks Developers, 2016-2020
 *                         Pantheon Tweaks Developers, 2020-2025
 *
 * Some code borrowed from:
 * elementary/switchboard-plug-pantheon-shell, src/Views/Appearance.vala
 */

public class PantheonTweaks.Panes.AppearancePane : BasePane {
    private Gtk.DropDown gtk_dropdown;
    private Gtk.DropDown icon_dropdown;
    private Gtk.DropDown cursor_dropdown;
    private Gtk.DropDown sound_dropdown;
    private Gtk.DropDown controls_dropdown;
    private Gtk.Switch dark_style_switch;
    private Gtk.Switch gnome_menu_switch;

    private XSettings x_settings;
    private GtkSettings gtk_settings;
    private Settings interface_settings;
    private Settings sound_settings;
    private Settings gnome_wm_settings;
    private Pantheon.AccountsService? pantheon_act = null;

    private Gtk.StringList gtk_list;
    private Gtk.StringList icon_list;
    private Gtk.StringList cursor_list;
    private Gtk.StringList sound_list;
    private ListStore controls_list;

    public AppearancePane () {
        Object (
            name: "appearance",
            title: _("Appearance"),
            icon: new ThemedIcon ("preferences-desktop"),
            description: _("Change the theme and button layout of windows. Changing theme may cause visibility issue."),
            header: _("General")
        );
    }

    construct {
        unowned string home_dir = Environment.get_home_dir ();

        /*************************************************/
        /* GTK Theme                                     */
        /*************************************************/
        var gtk_rootdir = Path.build_filename (home_dir, ".local", "share", "themes");

        var gtk_label = new Granite.HeaderLabel (_("GTK Theme")) {
            /// TRANSLATORS: The "%s" represents the path where custom themes are installed
            secondary_text = _("To show custom themes here, put them in %s.").printf (
                "%s/\"%s\"/gtk-3.0".printf (gtk_rootdir, _("theme-name"))
            ),
            hexpand = true
        };

        gtk_list = new Gtk.StringList (null);

        gtk_dropdown = new Gtk.DropDown (gtk_list, null) {
            valign = Gtk.Align.CENTER
        };

        var gtk_dir_button = new OpenButton (gtk_rootdir);

        var gtk_theme_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 12);
        gtk_theme_box.append (gtk_label);
        gtk_theme_box.append (gtk_dropdown);
        gtk_theme_box.append (gtk_dir_button);

        /*************************************************/
        /* Icon Theme                                    */
        /*************************************************/
        var icon_rootdir = Path.build_filename (home_dir, ".icons");

        var icon_label = new Granite.HeaderLabel (_("Icon Theme")) {
            /// TRANSLATORS: The "%s" represents the path where custom icons are installed
            secondary_text = _("To show custom icons here, put them in %s.").printf (
                "%s/\"%s\"".printf (icon_rootdir, _("theme-name"))
            ),
            hexpand = true
        };

        icon_list = new Gtk.StringList (null);

        icon_dropdown = new Gtk.DropDown (icon_list, null) {
            valign = Gtk.Align.CENTER
        };

        var icon_dir_button = new OpenButton (icon_rootdir);

        var icon_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 12);
        icon_box.append (icon_label);
        icon_box.append (icon_dropdown);
        icon_box.append (icon_dir_button);

        /*************************************************/
        /* Cursor Theme                                  */
        /*************************************************/
        var cursor_rootdir = Path.build_filename (home_dir, ".icons");

        var cursor_label = new Granite.HeaderLabel (_("Cursor Theme")) {
            /// TRANSLATORS: The "%s" represents the path where custom cursors are installed
            secondary_text = _("To show custom cursors here, put them in %s.").printf (
                "%s/\"%s\"/cursors".printf (cursor_rootdir, _("theme-name"))
            ),
            hexpand = true
        };

        cursor_list = new Gtk.StringList (null);

        cursor_dropdown = new Gtk.DropDown (cursor_list, null) {
            valign = Gtk.Align.CENTER
        };

        var cursor_dir_button = new OpenButton (cursor_rootdir);

        var cursor_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 12);
        cursor_box.append (cursor_label);
        cursor_box.append (cursor_dropdown);
        cursor_box.append (cursor_dir_button);

        /*************************************************/
        /* Sound Theme                                   */
        /*************************************************/
        var sound_rootdir = Path.build_filename (home_dir, ".local", "share", "sounds");

        var sound_label = new Granite.HeaderLabel (_("Sound Theme")) {
            /// TRANSLATORS: The "%s" represents the path where custom sounds are installed
            secondary_text = _("To show custom sounds here, put them in %s.").printf (
                "%s/\"%s\"".printf (sound_rootdir, _("theme-name"))
            ),
            hexpand = true
        };

        sound_list = new Gtk.StringList (null);

        sound_dropdown = new Gtk.DropDown (sound_list, null) {
            valign = Gtk.Align.CENTER
        };

        var sound_dir_button = new OpenButton (sound_rootdir);

        var sound_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 12);
        sound_box.append (sound_label);
        sound_box.append (sound_dropdown);
        sound_box.append (sound_dir_button);

        /*************************************************/
        /* Force Dark Style                              */
        /*************************************************/
        var dark_style_label = new Granite.HeaderLabel (_("Force Dark Style")) {
            secondary_text = _("Forces dark style on all apps, even if it's not supported. Requires restarting the application."), // vala-lint=line-length
            hexpand = true
        };

        dark_style_switch = new Gtk.Switch () {
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

        controls_list = new ListStore (typeof (StringIdObject));
        controls_list.append (new StringIdObject ("close:maximize", _("elementary")));
        controls_list.append (new StringIdObject ("maximize:close", _("elementary Reversed")));
        controls_list.append (new StringIdObject (":close", _("Close Only Right")));
        controls_list.append (new StringIdObject ("close:", _("Close Only Left")));
        controls_list.append (new StringIdObject ("close,minimize:maximize", _("Add Minimize Left")));
        controls_list.append (new StringIdObject ("close:minimize,maximize", _("Add Minimize Right")));
        controls_list.append (new StringIdObject ("close:minimize", _("Replace Maximize to Minimize")));
        controls_list.append (new StringIdObject (":minimize,maximize,close", _("Windows")));
        controls_list.append (new StringIdObject ("close,minimize,maximize", _("macOS")));
        controls_list.append (new StringIdObject ("close,maximize,minimize", _("Windows Reversed")));

        controls_dropdown = DropDownId.new (controls_list);

        var controls_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 12) {
            margin_top = 24
        };
        controls_box.append (controls_label);
        controls_box.append (controls_dropdown);

        /*************************************************/
        /* Show GNOME Menu                               */
        /*************************************************/
        x_settings = new XSettings ();

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

        content_area.append (gtk_theme_box);
        content_area.append (icon_box);
        content_area.append (cursor_box);
        content_area.append (sound_box);
        content_area.append (dark_style_box);
        content_area.append (controls_box);
        content_area.append (gnome_menu_switch_box);
    }

    public override bool load () {
        if (!SettingsUtil.schema_exists (SettingsUtil.INTERFACE_SCHEMA)) {
            warning ("Could not find settings schema %s", SettingsUtil.INTERFACE_SCHEMA);
            return false;
        }
        interface_settings = new Settings (SettingsUtil.INTERFACE_SCHEMA);

        if (!SettingsUtil.schema_exists (SettingsUtil.SOUND_SCHEMA)) {
            warning ("Could not find settings schema %s", SettingsUtil.SOUND_SCHEMA);
            return false;
        }
        sound_settings = new Settings (SettingsUtil.SOUND_SCHEMA);

        bool ret = x_settings.load ();
        if (!ret) {
            return false;
        }

        gtk_settings = new GtkSettings ();

        if (!SettingsUtil.schema_exists (SettingsUtil.GNOME_WM_SCHEMA)) {
            warning ("Could not find settings schema %s", SettingsUtil.GNOME_WM_SCHEMA);
            return false;
        }
        gnome_wm_settings = new Settings (SettingsUtil.GNOME_WM_SCHEMA);

        FDO.Accounts? accounts_service;
        try {
            accounts_service = Bus.get_proxy_sync (
                BusType.SYSTEM,
               "org.freedesktop.Accounts",
               "/org/freedesktop/Accounts"
            );
        } catch (Error err) {
            critical ("Failed to get Accounts proxy: %s", err.message);
            return false;
        }

        string? user_path;
        string user_name = Environment.get_user_name ();
        try {
            user_path = accounts_service.find_user_by_name (user_name);
        } catch (Error err) {
            critical ("Failed to find user by name '%s': %s", user_name, err.message);
            return false;
        }

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

        ret = ThemeSettings.fetch_gtk_themes (gtk_list);
        if (!ret) {
            warning ("Failed to fetch GTK themes");
            return false;
        }

        ret = ThemeSettings.fetch_icon_themes (icon_list);
        if (!ret) {
            warning ("Failed to fetch icon themes");
            return false;
        }

        ret = ThemeSettings.fetch_cursor_themes (cursor_list);
        if (!ret) {
            warning ("Failed to fetch cursor themes");
            return false;
        }

        ret = ThemeSettings.fetch_sound_themes (sound_list);
        if (!ret) {
            warning ("Failed to fetch sound themes");
            return false;
        }

        gtk_theme_settings_to_dropdown ();
        controls_settings_to_dropdown ();
        gnome_menu_switch.active = x_settings.has_gnome_menu ();

        interface_settings.bind_with_mapping ("icon-theme",
            icon_dropdown, "selected",
            SettingsBindFlags.DEFAULT,
            (SettingsBindGetMappingShared) SettingsUtil.Binding.to_dropdown_selected,
            (SettingsBindSetMappingShared) SettingsUtil.Binding.from_dropdown_selected,
            icon_list, null);

        interface_settings.bind_with_mapping ("cursor-theme",
            cursor_dropdown, "selected",
            SettingsBindFlags.DEFAULT,
            (SettingsBindGetMappingShared) SettingsUtil.Binding.to_dropdown_selected,
            (SettingsBindSetMappingShared) SettingsUtil.Binding.from_dropdown_selected,
            cursor_list, null);

        sound_settings.bind_with_mapping ("theme-name",
            sound_dropdown, "selected",
            SettingsBindFlags.DEFAULT,
            (SettingsBindGetMappingShared) SettingsUtil.Binding.to_dropdown_selected,
            (SettingsBindSetMappingShared) SettingsUtil.Binding.from_dropdown_selected,
            sound_list, null);

        gtk_settings.bind_property ("prefer-dark-theme",
            dark_style_switch, "active",
            BindingFlags.SYNC_CREATE | BindingFlags.BIDIRECTIONAL);

        if (((DBusProxy) pantheon_act).get_cached_property ("PrefersAccentColor") != null) {
            ((DBusProxy) pantheon_act).g_properties_changed.connect ((changed, invalid) => {
                gtk_theme_settings_to_dropdown ();
            });
        }

        interface_settings.changed["gtk-theme"].connect (gtk_theme_settings_to_dropdown);
        gtk_dropdown.notify["selected-item"].connect (gtk_theme_dropdown_to_settings);

        gnome_wm_settings.changed["button-layout"].connect (controls_settings_to_dropdown);
        controls_dropdown.notify["selected"].connect (controls_dropdown_to_settings);
        gnome_menu_switch.notify["active"].connect (controls_dropdown_to_settings);

        is_load_success = true;
        return true;
    }

    protected override void do_reset () {
        string[] keys = {"gtk-theme", "icon-theme", "cursor-theme"};

        foreach (unowned var key in keys) {
            interface_settings.reset (key);
        }

        if (((DBusProxy) pantheon_act).get_cached_property ("PrefersAccentColor") != null) {
            pantheon_act.prefers_accent_color = ThemeSettings.AccentColor.BLUE;
        }

        sound_settings.reset ("theme-name");
        gnome_wm_settings.reset ("button-layout");
        x_settings.reset ();

        gtk_settings.prefer_dark_theme = false;
        gnome_menu_switch.active = x_settings.has_gnome_menu ();
    }

    private void gtk_theme_settings_to_dropdown () {
        string selected_id = interface_settings.get_string ("gtk-theme");
        uint selected_pos = gtk_list.find (selected_id);

        if (selected_pos == uint.MAX) {
            // Unselect if the list does not contain the current theme
            selected_pos = Gtk.INVALID_LIST_POSITION;
        }

        if (gtk_dropdown.selected == selected_pos) {
            return;
        }

        gtk_dropdown.selected = selected_pos;
    }

    private void gtk_theme_dropdown_to_settings () {
        var selected_item = (Gtk.StringObject) gtk_dropdown.selected_item;
        string selected_id = selected_item.string;

        interface_settings.set_string ("gtk-theme", selected_id);

        if (selected_id.has_prefix (ThemeSettings.ELEMENTARY_STYLESHEET_PREFIX)) {
            ThemeSettings.AccentColor color = ThemeSettings.parse_accent_color (selected_id);
            if (((DBusProxy) pantheon_act).get_cached_property ("PrefersAccentColor") != null) {
                pantheon_act.prefers_accent_color = color;
            }
        }
    }

    private void controls_settings_to_dropdown () {
        string selected_id = gnome_wm_settings.get_string ("button-layout");
        uint selected_pos = StringIdListUtil.find (controls_list, selected_id);

        if (controls_dropdown.selected == selected_pos) {
            return;
        }

        controls_dropdown.selected = selected_pos;
    }

    private void controls_dropdown_to_settings () {
        uint selected_pos = controls_dropdown.selected;
        string? selected_id = StringIdListUtil.get_id (controls_list, selected_pos);

        if (selected_id == null) {
            return;
        }

        gnome_wm_settings.set_string ("button-layout", selected_id);
        x_settings.set_gnome_menu (gnome_menu_switch.active, selected_id);
    }
}
