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

public class PantheonTweaks.Panes.FontsPane : Categories.Pane {
    public FontsPane () {
        base (_("Fonts"), "applications-fonts");
    }

    construct {
        var interface_settings = new GLib.Settings ("org.gnome.desktop.interface");
        var window_settings = new GLib.Settings ("org.gnome.desktop.wm.preferences");

        var fonts_label = new Granite.HeaderLabel (_("Font Settings"));
        var fonts_box = new Widgets.SettingsBox ();

        var default_font = new Gtk.FontButton ();
        default_font.use_font = true;

        var document_font = new Gtk.FontButton ();
        document_font.use_font = true;

        var mono_font = new Gtk.FontButton ();
        mono_font.use_font = true;

        var titlebar_font = new Gtk.FontButton ();
        titlebar_font.use_font = true;

        fonts_box.add_widget (_("Default font"), default_font);
        fonts_box.add_widget (_("Document font"), document_font);
        fonts_box.add_widget (_("Monospace font"), mono_font);
        fonts_box.add_widget (_("Titlebar font"), titlebar_font);

        grid.add (fonts_label);
        grid.add (fonts_box);

        grid.show_all ();

        interface_settings.bind ("font-name", default_font, "font-name", SettingsBindFlags.DEFAULT);
        interface_settings.bind ("document-font-name", document_font, "font-name", SettingsBindFlags.DEFAULT);
        interface_settings.bind ("monospace-font-name", mono_font, "font-name", SettingsBindFlags.DEFAULT);
        window_settings.bind ("titlebar-font", titlebar_font, "font-name", SettingsBindFlags.DEFAULT);

        connect_reset_button (() => {
            string[] keys = {"font-name", "document-font-name", "monospace-font-name"};

            foreach (var key in keys) {
                interface_settings.reset (key);
            }

            window_settings.reset ("titlebar-font");
        });
    }
}
