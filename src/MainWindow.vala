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
        set_default_size (1080, 600);

        set_titlebar (headerbar);
        add (categories);
    }
}
