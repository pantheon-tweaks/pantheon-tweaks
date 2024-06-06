/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: elementary Tweaks Developers, 2014-2020
 *                         Pantheon Tweaks Developers, 2020-2024
 */

public class PantheonTweaks.Tweaks : Gtk.Application {
    private MainWindow window;

    public Tweaks () {
        GLib.Intl.bindtextdomain (GETTEXT_PACKAGE, LOCALEDIR);
        GLib.Intl.bind_textdomain_codeset (GETTEXT_PACKAGE, "UTF-8");

        Object (
            application_id: "io.github.pantheon_tweaks.pantheon-tweaks",
            flags: ApplicationFlags.FLAGS_NONE
        );
    }

    protected override void activate () {
        if (window != null) {
            window.present ();
            return;
        }

        window = new MainWindow (this);
        window.present ();

        var quit_action = new GLib.SimpleAction ("quit", null);
        add_action (quit_action);
        set_accels_for_action ("app.quit", {"<Control>q"});
        quit_action.activate.connect (() => {
            if (window != null) {
                window.destroy ();
            }
        });
    }

    public static int main (string[] args) {
        var app = new Tweaks ();
        return app.run (args);
    }
}
