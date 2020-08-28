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
    private Gtk.ComboBox controls_combobox;
    private Gtk.Switch gnome_menu;

    private int controls_index = 0;

    public AppearancePane () {
        base (_("Appearance"), "applications-graphics");
    }

    construct {
        var interface_settings = new GLib.Settings ("org.gnome.desktop.interface");
        var gtk_settings = GtkSettings.get_default ();

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

        var controls_store = AppearanceSettings.get_button_layouts (out controls_index);
        controls_combobox = layout_box.add_combo_box (_("Layout"));
        controls_combobox.set_model (controls_store);

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

        connect_combobox (controls_combobox, controls_store,
            (val) => { AppearanceSettings.get_default ().button_layout = val;
                       XSettings.get_default ().set_gnome_menu (gnome_menu.state, val);
        });

        gnome_menu.notify["active"].connect (() => {
            controls_combobox.changed ();
        });

        connect_reset_button (()=> {
            string[] keys = {"gtk-theme", "icon-theme", "cursor-theme"};

            foreach (var key in keys) {
                interface_settings.reset (key);
            }

            gtk_settings.prefer_dark_theme = false;
            AppearanceSettings.get_default ().reset ();
            XSettings.get_default ().reset ();
        });
    }

    protected override void init_data () {
        controls_combobox.set_active (controls_index);
        gnome_menu.set_state (XSettings.get_default ().has_gnome_menu ());
    }
}
