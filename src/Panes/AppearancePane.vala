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

    public AppearancePane (PaneName pane_name) {
        base (pane_name);
    }

    construct {
        var theme_label = new Granite.HeaderLabel (_("Theme Settings"));

        var gtk_label = new SummaryLabel (_("GTK+:"));
        var gtk_store = Util.get_themes_store ("themes", "gtk-3.0", InterfaceSettings.get_default ().gtk_theme, out gtk_index);
        gtk_combobox = new ComboBox ();
        gtk_combobox.set_model (gtk_store);

        /// TRANSLATORS: The two "%s" represent the paths to put custom icons
        var gtk_info = new DimLabel (_("To show custom themes here, put them in %s or %s.").printf (
            "~/.themes/<theme-name>/gtk-3.0",
            "~/.local/share/themes/<theme-name>/gtk-3.0"
        ));

        var icon_label = new SummaryLabel (_("Icons:"));
        var icon_store = Util.get_themes_store ("icons", "index.theme", InterfaceSettings.get_default ().icon_theme, out icon_index);
        icon_combobox = new ComboBox ();
        icon_combobox.set_model (icon_store);

        /// TRANSLATORS: The two "%s" represent the paths to put custom icons
        var icon_info = new DimLabel (_("To show custom icons here, put them in %s or %s.").printf (
            "~/.icons/<theme-name>",
            "~/.local/share/icons/<theme-name>"
        ));

        var cursor_label = new SummaryLabel (_("Cursor:"));
        var cursor_store = Util.get_themes_store ("icons", "cursors", InterfaceSettings.get_default ().cursor_theme, out cursor_index);
        cursor_combobox = new ComboBox ();
        cursor_combobox.set_model (cursor_store);

        /// TRANSLATORS: The two "%s" represent the paths to put custom cursors
        var cursor_info = new DimLabel (_("To show custom cursors here, put them in %s or %s.").printf (
            "~/.icons/<theme-name>/cursors",
            "~/.local/share/icons/<theme-name>/cursors"
        ));

        var prefer_dark_label = new SummaryLabel (_("Force to use dark stylesheet:"));
        prefer_dark_switch = new Switch ();
        var prefer_dark_info = new DimLabel (_("The official dark style only works for apps that support it. This setting forces all apps to use dark style."));

        var layout_label = new Granite.HeaderLabel (_("Window Controls"));

        var controls_label = new SummaryLabel (_("Layout:"));
        var controls_store = AppearanceSettings.get_button_layouts (out controls_index);
        controls_combobox = new ComboBox ();
        controls_combobox.set_model (controls_store);
        var controls_info = new DimLabel (_("Changes button layout of window."));

        var gnome_menu_label = new SummaryLabel (_("Show GNOME menu:"));
        gnome_menu = new Switch ();
        var gnome_menu_info = new DimLabel (_("Whether to show GNOME menu in GNOME apps."));

        init_data ();

        content_area.attach (theme_label, 0, 0, 1, 1);
        content_area.attach (gtk_label, 0, 1, 1, 1);
        content_area.attach (gtk_combobox, 1, 1, 1, 1);
        content_area.attach (gtk_info, 1, 2, 1, 1);
        content_area.attach (icon_label, 0, 3, 1, 1);
        content_area.attach (icon_combobox, 1, 3, 1, 1);
        content_area.attach (icon_info, 1, 4, 1, 1);
        content_area.attach (cursor_label, 0, 5, 1, 1);
        content_area.attach (cursor_combobox, 1, 5, 1, 1);
        content_area.attach (cursor_info, 1, 6, 1, 1);
        content_area.attach (prefer_dark_label, 0, 7, 1, 1);
        content_area.attach (prefer_dark_switch, 1, 7, 1, 1);
        content_area.attach (prefer_dark_info, 1, 8, 1, 1);
        content_area.attach (layout_label, 0, 9, 1, 1);
        content_area.attach (controls_label, 0, 10, 1, 1);
        content_area.attach (controls_combobox, 1, 10, 1, 1);
        content_area.attach (controls_info, 1, 11, 1, 1);
        content_area.attach (gnome_menu_label, 0, 12, 1, 1);
        content_area.attach (gnome_menu, 1, 12, 1, 1);
        content_area.attach (gnome_menu_info, 1, 13, 1, 1);

        show_all ();

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
            init_data ();
        });
    }

    private void init_data () {
        gtk_combobox.set_active (gtk_index);
        icon_combobox.set_active (icon_index);
        cursor_combobox.set_active (cursor_index);
        controls_combobox.set_active (controls_index);

        gnome_menu.set_state (XSettings.get_default ().has_gnome_menu ());
        prefer_dark_switch.set_state (GtkSettings.get_default ().prefer_dark_theme);
    }
}
