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
    private Gtk.ComboBox gtk_combobox;
    private Gtk.ComboBox icon_combobox;
    private Gtk.ComboBox cursor_combobox;
    private Gtk.Switch prefer_dark_switch;
    private Gtk.ComboBox controls_combobox;
    private Gtk.Switch gnome_menu;

    private int gtk_index = 0;
    private int icon_index = 0;
    private int cursor_index = 0;
    private int controls_index = 0;

    public AppearancePane () {
        base (_("Appearance"), "applications-graphics");
    }

    construct {
        var theme_label = new Granite.HeaderLabel (_("Theme Settings"));
        var theme_box = new Widgets.SettingsBox ();

        var gtk_store = Util.get_themes_store ("themes", "gtk-3.0", InterfaceSettings.get_default ().gtk_theme, out gtk_index);
        gtk_combobox = theme_box.add_combo_box (_("GTK+"));
        gtk_combobox.set_model (gtk_store);

        var icon_store = Util.get_themes_store ("icons", "index.theme", InterfaceSettings.get_default ().icon_theme, out icon_index);
        icon_combobox = theme_box.add_combo_box (_("Icons"));
        icon_combobox.set_model (icon_store);

        var cursor_store = Util.get_themes_store ("icons", "cursors", InterfaceSettings.get_default ().cursor_theme, out cursor_index);
        cursor_combobox = theme_box.add_combo_box (_("Cursor"));
        cursor_combobox.set_model (cursor_store);

        prefer_dark_switch = theme_box.add_switch (_("Force dark stylesheet"));

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

        prefer_dark_switch.notify["active"].connect (() => {
            GtkSettings.get_default ().prefer_dark_theme = prefer_dark_switch.state;
        });

        connect_combobox (gtk_combobox, gtk_store, (val) => { InterfaceSettings.get_default ().gtk_theme = val; });
        connect_combobox (icon_combobox, icon_store, (val) => { InterfaceSettings.get_default ().icon_theme = val; });
        connect_combobox (cursor_combobox, cursor_store, (val) => { InterfaceSettings.get_default ().cursor_theme = val; });
        connect_combobox (controls_combobox, controls_store,
            (val) => { AppearanceSettings.get_default ().button_layout = val;
                       XSettings.get_default ().set_gnome_menu (gnome_menu.state, val);
        });

        gnome_menu.notify["active"].connect (() => {
            controls_combobox.changed ();
        });

        connect_reset_button (()=> {
            GtkSettings.get_default ().prefer_dark_theme = false;
            InterfaceSettings.get_default ().reset_appearance ();
            AppearanceSettings.get_default ().reset ();
            XSettings.get_default ().reset ();
        });
    }

    protected override void init_data () {
        gtk_combobox.set_active (gtk_index);
        icon_combobox.set_active (icon_index);
        cursor_combobox.set_active (cursor_index);
        controls_combobox.set_active (controls_index);

        gnome_menu.set_state (XSettings.get_default ().has_gnome_menu ());
        prefer_dark_switch.set_state (GtkSettings.get_default ().prefer_dark_theme);
    }
}
