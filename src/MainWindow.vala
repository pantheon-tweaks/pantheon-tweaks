/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: elementary Tweaks Developers, 2014-2020
 *                         Pantheon Tweaks Developers, 2020-2025
 */

public class PantheonTweaks.MainWindow : Gtk.ApplicationWindow {
    private string desktop_environment;
    private Categories categories;

    public MainWindow (Gtk.Application app) {
        Object (
            application: app
        );
    }

    construct {
        desktop_environment = Environment.get_variable ("XDG_CURRENT_DESKTOP");

        // Follow OS-wide dark preference
        var granite_settings = Granite.Settings.get_default ();
        var gtk_settings = Gtk.Settings.get_default ();

        granite_settings.bind_property ("prefers-color-scheme", gtk_settings, "gtk-application-prefer-dark-theme",
            BindingFlags.DEFAULT | BindingFlags.SYNC_CREATE,
            ((binding, granite_prop, ref gtk_prop) => {
                gtk_prop.set_boolean ((Granite.Settings.ColorScheme) granite_prop == Granite.Settings.ColorScheme.DARK);
                return true;
            })
        );
    }

    public void load () {
        // Prevent Tweaks from launching and breaking preferences on other DEs
        if (desktop_environment != "Pantheon") {
            load_on_other ();
        } else {
            load_on_pantheon ();
        }
    }

    private void load_on_other () {
        var headerbar = new Gtk.HeaderBar () {
            show_title_buttons = true,
            title_widget = new Gtk.Label (_("Tweaks"))
        };

        set_titlebar (headerbar);

        var unsupported_view = new Granite.Placeholder (
            _("Your Desktop Environment Is Not Supported")
        ) {
            description = _("Pantheon Tweaks is a customization tool for Pantheon. Your desktop environment \"%s\" is not supported.").printf (desktop_environment),
            icon = new ThemedIcon ("dialog-warning")
        };
        child = unsupported_view;
    }

    private void load_on_pantheon () {
        categories = new Categories ();
        child = categories;

        // No headerbar in favor of SettingsPage and SettingsSidebar

        categories.load ();
    }
}
