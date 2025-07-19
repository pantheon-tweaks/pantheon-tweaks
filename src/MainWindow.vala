/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: elementary Tweaks Developers, 2014-2020
 *                         Pantheon Tweaks Developers, 2020-2025
 */

public class PantheonTweaks.MainWindow : Gtk.ApplicationWindow {
    private Gtk.HeaderBar headerbar;
    private Categories categories;

    public MainWindow (Gtk.Application app) {
        Object (
            application: app
        );
    }

    construct {
        headerbar = new Gtk.HeaderBar () {
            show_title_buttons = true,
            title_widget = new Gtk.Label (_("Pantheon Tweaks"))
        };

        set_titlebar (headerbar);
    }

    public void load () {
        unowned string desktop_environment = Environment.get_variable ("XDG_CURRENT_DESKTOP");
        if (desktop_environment == "Pantheon") {
            load_on_pantheon ();
        } else {
            // Prevent Tweaks from launching and breaking preferences on other DEs
            load_on_other (desktop_environment);
        }
    }

    private void load_on_other (string desktop_environment) {
        var unsupported_view = new Granite.Placeholder (
            _("Your Desktop Environment \"%s\" Is Not Supported").printf (desktop_environment)
        ) {
            description = _("Pantheon Tweaks is a customization tool for Pantheon."),
            icon = new ThemedIcon ("dialog-warning")
        };
        child = unsupported_view;
    }

    private void load_on_pantheon () {
        categories = new Categories ();
        child = categories;

        // Hide the headerbar in favor of SettingsPage and SettingsSidebar, otherwise duplicated headerbars are shown
        headerbar.visible = false;

        categories.load ();
    }
}
