/*
 * Copyright (C) Elementary Tweaks Developers, 2016 - 2020
 *               Pantheon Tweaks Developers, 2020
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 */

public class PantheonTweaks.Panes.AppearancePane : Categories.Pane {
    private Gee.HashMap<string, string> preset_button_layouts;
    private XSettings x_settings;
    private GLib.Settings appearance_settings;

    private Gtk.ComboBoxText controls_combobox;
    private Gtk.Switch gnome_menu;

    public AppearancePane () {
        base (_("Appearance"), "applications-graphics");
    }

    construct {
        var interface_settings = new GLib.Settings ("org.gnome.desktop.interface");
        var gtk_settings = GtkSettings.get_default ();
        x_settings = XSettings.get_default ();
        appearance_settings = new GLib.Settings ("org.pantheon.desktop.gala.appearance");
        var gnome_wm_settings = new GLib.Settings ("org.gnome.desktop.wm.preferences");

        var theme_label = new Granite.HeaderLabel (_("Theme Settings"));
        var theme_box = new Widgets.SettingsBox ();

        var gtk_map = Util.get_themes_map ("themes", "gtk-3.0");
        var gtk_combobox = theme_box.add_combo_box_text (_("GTK+"), gtk_map);

        var icon_map = Util.get_themes_map ("icons", "index.theme");
        var icon_combobox = theme_box.add_combo_box_text (_("Icons"), icon_map);

        var cursor_map = Util.get_themes_map ("icons", "cursors");
        var cursor_combobox = theme_box.add_combo_box_text (_("Cursor"), cursor_map);

        var prefer_dark_switch = theme_box.add_switch (_("Force dark stylesheet"));
        prefer_dark_switch.active = GtkSettings.get_default ().prefer_dark_theme;

        var layout_label = new Granite.HeaderLabel (_("Window Controls"));
        var layout_box = new Widgets.SettingsBox ();

        var controls_map = get_preset_button_layouts ();
        controls_combobox = layout_box.add_combo_box_text (_("Layout"), controls_map);

        gnome_menu = layout_box.add_switch (_("Show GNOME menu"));

        init_data ();

        grid.add (theme_label);
        grid.add (theme_box);
        grid.add (layout_label);
        grid.add (layout_box);

        grid.show_all ();

        interface_settings.bind ("gtk-theme", gtk_combobox, "active_id", SettingsBindFlags.DEFAULT);
        interface_settings.bind ("icon-theme", icon_combobox, "active_id", SettingsBindFlags.DEFAULT);
        interface_settings.bind ("cursor-theme", cursor_combobox, "active_id", SettingsBindFlags.DEFAULT);
        prefer_dark_switch.bind_property ("active", gtk_settings, "prefer-dark-theme", BindingFlags.BIDIRECTIONAL);

        controls_combobox.changed.connect (() => {
            string new_layout = controls_combobox.active_id;
            appearance_settings.set_string ("button-layout", new_layout);
            gnome_wm_settings.set_string ("button-layout", new_layout);
            x_settings.set_gnome_menu (gnome_menu.state, new_layout);
        });

        gnome_menu.notify["active"].connect (() => {
            controls_combobox.changed ();
        });

        connect_reset_button (()=> {
            string[] keys = {"gtk-theme", "icon-theme", "cursor-theme"};

            foreach (var key in keys) {
                interface_settings.reset (key);
            }

            appearance_settings.reset ("button-layout");
            gnome_wm_settings.reset ("button-layout");
            x_settings.reset ();

            gtk_settings.prefer_dark_theme = false;
            init_data ();
        });
    }

    private void init_data () {
        controls_combobox.active_id = appearance_settings.get_string ("button-layout");
        gnome_menu.state = x_settings.has_gnome_menu ();
    }

    private Gee.HashMap<string, string> get_preset_button_layouts () {
        if (preset_button_layouts == null) {
            preset_button_layouts = new Gee.HashMap<string, string> ();
            preset_button_layouts["close:maximize"] = _("elementary");
            preset_button_layouts[":close"] = _("Close Only Right");
            preset_button_layouts["close:"] = _("Close Only Left");
            preset_button_layouts["close,minimize:maximize"] = _("Minimize Left");
            preset_button_layouts["close:minimize,maximize"] = _("Minimize Right");
            preset_button_layouts[":minimize,maximize,close"] = _("Windows");
            preset_button_layouts["close,minimize,maximize"] = _("OS X");
            preset_button_layouts["close,maximize,minimize"] = _("Ubuntu");
        }

        return preset_button_layouts;
    }
}
