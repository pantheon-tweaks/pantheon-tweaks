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
    public FontsPane (PaneName pane_name) {
        base (pane_name);
    }

    construct {
        var interface_settings = new GLib.Settings ("org.gnome.desktop.interface");
        var window_settings = new GLib.Settings ("org.gnome.desktop.wm.preferences");

        var default_font_label = new SummaryLabel (_("Default Font:"));
        var default_font_button = new FontButton ();

        var document_font_label = new SummaryLabel (_("Document font:"));
        var document_font_button = new FontButton ();

        var mono_font_label = new SummaryLabel (_("Monospace font:"));
        var mono_font_button = new FontButton ();

        var titlebar_font_label = new SummaryLabel (_("Titlebar font:"));
        var titlebar_font_button = new FontButton ();

        content_area.attach (default_font_label, 0, 0, 1, 1);
        content_area.attach (default_font_button, 1, 0, 1, 1);
        content_area.attach (document_font_label, 0, 1, 1, 1);
        content_area.attach (document_font_button, 1, 1, 1, 1);
        content_area.attach (mono_font_label, 0, 2, 1, 1);
        content_area.attach (mono_font_button, 1, 2, 1, 1);
        content_area.attach (titlebar_font_label, 0, 3, 1, 1);
        content_area.attach (titlebar_font_button, 1, 3, 1, 1);

        show_all ();

        interface_settings.bind ("font-name", default_font_button, "font-name", SettingsBindFlags.DEFAULT);
        interface_settings.bind ("document-font-name", document_font_button, "font-name", SettingsBindFlags.DEFAULT);
        interface_settings.bind ("monospace-font-name", mono_font_button, "font-name", SettingsBindFlags.DEFAULT);
        window_settings.bind ("titlebar-font", titlebar_font_button, "font-name", SettingsBindFlags.DEFAULT);

        connect_reset_button (() => {
            string[] keys = {"font-name", "document-font-name", "monospace-font-name"};

            foreach (var key in keys) {
                interface_settings.reset (key);
            }

            window_settings.reset ("titlebar-font");
        });
    }

    private class FontButton : Gtk.FontButton {
        construct {
            halign = Gtk.Align.START;
            use_font = true;
        }
    }
}
