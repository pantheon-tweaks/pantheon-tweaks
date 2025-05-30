/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: elementary Tweaks Developers, 2014-2020
 *                         Pantheon Tweaks Developers, 2020-2025
 */

public class PantheonTweaks.Tweaks : Gtk.Application {
    private static Settings settings;

    private MainWindow window;

    public Tweaks () {
        Intl.bindtextdomain (Config.GETTEXT_PACKAGE, Config.LOCALEDIR);
        Intl.bind_textdomain_codeset (Config.GETTEXT_PACKAGE, "UTF-8");

        Object (
            application_id: "io.github.pantheon_tweaks.pantheon-tweaks",
            flags: ApplicationFlags.DEFAULT_FLAGS
        );
    }

    static construct {
        settings = new Settings ("io.github.pantheon_tweaks.pantheon-tweaks");
    }

    protected override void startup () {
        base.startup ();

        Granite.init ();

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

    protected override void activate () {
        if (window != null) {
            window.present ();
            return;
        }

        window = new MainWindow (this);
        // The window seems to need showing before restoring its size in Gtk4
        window.present ();

        // Load after present because this may show warning dialogs on top of main window
        window.load ();

        settings.bind ("window-height", window, "default-height", SettingsBindFlags.DEFAULT);
        settings.bind ("window-width", window, "default-width", SettingsBindFlags.DEFAULT);

        // Binding of window maximization with "SettingsBindFlags.DEFAULT" results the window getting bigger and bigger on open.
        // So we use the prepared binding only for setting.
        if (settings.get_boolean ("window-maximized")) {
            window.maximize ();
        }

        settings.bind ("window-maximized", window, "maximized", SettingsBindFlags.SET);

        var quit_action = new SimpleAction ("quit", null);
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
