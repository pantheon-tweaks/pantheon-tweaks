/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: elementary Tweaks Developers, 2014-2020
 *                         Pantheon Tweaks Developers, 2020-2023
 */

public class PantheonTweaks.Tweaks : Gtk.Application {
    private Gtk.ApplicationWindow window;

    public Tweaks () {
        GLib.Intl.bindtextdomain (GETTEXT_PACKAGE, LOCALEDIR);
        GLib.Intl.bind_textdomain_codeset (GETTEXT_PACKAGE, "UTF-8");

        Object (
            application_id: "com.github.pantheon-tweaks.pantheon-tweaks",
            flags: ApplicationFlags.FLAGS_NONE
        );
    }

    protected override void activate () {
        if (window != null) {
            window.present ();
            return;
        }

        var headerbar = new Gtk.HeaderBar () {
            show_close_button = true,
            title = _("Tweaks")
        };

        var categories = new Categories ();

        window = new Gtk.ApplicationWindow (this);
        window.set_titlebar (headerbar);
        window.add (categories);
        window.show_all ();
    }

    public static int main (string[] args) {
        var app = new Tweaks ();
        return app.run (args);
    }
}
