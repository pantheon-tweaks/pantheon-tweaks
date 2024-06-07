/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: elementary Tweaks Developers, 2016-2020
 *                         Pantheon Tweaks Developers, 2020-2024
 */

public class PantheonTweaks.Panes.FontsPane : Categories.Pane {
    public FontsPane () {
        base (
            "fonts", _("Fonts"), "preferences-desktop-font",
            _("Change the fonts used in your system and documents by default.")
        );
    }

    construct {
        var interface_settings = new GLib.Settings ("org.gnome.desktop.interface");
        var window_settings = new GLib.Settings ("org.gnome.desktop.wm.preferences");

        var default_font_label = summary_label_new (_("Default Font:"));
        var default_font_button = font_button_new ();

        var document_font_label = summary_label_new (_("Document font:"));
        var document_font_button = font_button_new ();

        var mono_font_label = summary_label_new (_("Monospace font:"));
        var mono_font_button = font_button_new ();

        var titlebar_font_label = summary_label_new (_("Titlebar font:"));
        var titlebar_font_button = font_button_new ();

        content_area.attach (default_font_label, 0, 0, 1, 1);
        content_area.attach (default_font_button, 1, 0, 1, 1);
        content_area.attach (document_font_label, 0, 1, 1, 1);
        content_area.attach (document_font_button, 1, 1, 1, 1);
        content_area.attach (mono_font_label, 0, 2, 1, 1);
        content_area.attach (mono_font_button, 1, 2, 1, 1);
        content_area.attach (titlebar_font_label, 0, 3, 1, 1);
        content_area.attach (titlebar_font_button, 1, 3, 1, 1);

        interface_settings.bind ("font-name", default_font_button, "font", SettingsBindFlags.DEFAULT);
        interface_settings.bind ("document-font-name", document_font_button, "font", SettingsBindFlags.DEFAULT);
        interface_settings.bind ("monospace-font-name", mono_font_button, "font", SettingsBindFlags.DEFAULT);
        window_settings.bind ("titlebar-font", titlebar_font_button, "font", SettingsBindFlags.DEFAULT);

        on_click_reset (() => {
            string[] keys = {"font-name", "document-font-name", "monospace-font-name"};

            foreach (var key in keys) {
                interface_settings.reset (key);
            }

            window_settings.reset ("titlebar-font");
        });
    }
}
