/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: elementary Tweaks Developers, 2014-2020
 *                         Pantheon Tweaks Developers, 2020-2023
 */

public class PantheonTweaks.MainWindow : Gtk.ApplicationWindow {
    public MainWindow (Gtk.Application app) {
        Object (
            application: app
        );
    }

    construct {
        var headerbar = new Gtk.HeaderBar () {
            show_close_button = true,
            title = _("Tweaks")
        };

        var categories = new Categories ();

        // TODO Remember size
        // APIs completely changed between GTK 3.0 and 4, so leaving it until we port Tweaks to GTK 4
        set_default_size (1080, 600);

        set_titlebar (headerbar);
        add (categories);

        // Follow OS-wide dark preference
        var granite_settings = Granite.Settings.get_default ();
        var gtk_settings = Gtk.Settings.get_default ();

        gtk_settings.gtk_application_prefer_dark_theme = granite_settings.prefers_color_scheme == Granite.Settings.ColorScheme.DARK;

        granite_settings.notify["prefers-color-scheme"].connect (() => {
            gtk_settings.gtk_application_prefer_dark_theme = granite_settings.prefers_color_scheme == Granite.Settings.ColorScheme.DARK;
        });
    }
}
