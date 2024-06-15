/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: elementary Tweaks Developers, 2014-2020
 *                         Pantheon Tweaks Developers, 2020-2024
 */

public class PantheonTweaks.MainWindow : Gtk.ApplicationWindow {
    public MainWindow (Gtk.Application app) {
        Object (
            application: app
        );
    }

    construct {
        var headerbar = new Gtk.HeaderBar () {
            show_title_buttons = true,
            title_widget = new Gtk.Label (_("Tweaks"))
        };

        set_titlebar (headerbar);

        string desktop_environment = GLib.Environment.get_variable ("XDG_CURRENT_DESKTOP");
        // Prevent Tweaks from launching and breaking preferences on other DEs
        if (desktop_environment != "Pantheon") {
            var unsupported_view = new Granite.Placeholder (
                _("Your Desktop Environment Is Not Supported")
            ) {
                description = _("Pantheon Tweaks is a customization tool for Pantheon. Your desktop environment \"%s\" is not supported.").printf (desktop_environment),
                icon = new ThemedIcon ("dialog-warning")
            };
            child = unsupported_view;
        } else {
            var categories = new Categories ();
            child = categories;
        }

        // Follow OS-wide dark preference
        var granite_settings = Granite.Settings.get_default ();
        var gtk_settings = Gtk.Settings.get_default ();

        gtk_settings.gtk_application_prefer_dark_theme = granite_settings.prefers_color_scheme == Granite.Settings.ColorScheme.DARK;

        granite_settings.notify["prefers-color-scheme"].connect (() => {
            gtk_settings.gtk_application_prefer_dark_theme = granite_settings.prefers_color_scheme == Granite.Settings.ColorScheme.DARK;
        });
    }
}
