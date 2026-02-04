/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: elementary Tweaks Developers, 2014-2020
 *                         Pantheon Tweaks Developers, 2020-2026
 */

/**
 * Settings for Gtk; thanks gnome-tweak-tool for the help!
 */
public class PantheonTweaks.GtkSettings : Object {
    private KeyFile keyfile;
    private string path;

    /**
     * GTK should prefer the dark theme or not
     */
    public bool prefer_dark_theme {
        get {
            if (!(File.new_for_path (path).query_exists ())) {
                return false;
            }

            return (get_integer ("gtk-application-prefer-dark-theme") == 1);
        }
        set { set_integer ("gtk-application-prefer-dark-theme", value ? 1 : 0); }
    }

    public GtkSettings () {
        keyfile = new KeyFile ();

        path = Environment.get_home_dir () + "/.config/gtk-3.0/settings.ini";

        if (!(File.new_for_path (path).query_exists ())) {
            return;
        }

        try {
            keyfile.load_from_file (path, 0);
        } catch (Error err) {
            warning ("Error loading keyfile from '%s': %s", path, err.message);
        }
    }

    /**
     * Gets an integer from the keyfile at Settings group
     */
    private int get_integer (string key) {
        int key_int = 0;

        try {
            key_int = keyfile.get_integer ("Settings", key);
        } catch (Error err) {
            warning ("Error getting value of %s from keyfile: %s", key, err.message);
        }

        return key_int;
    }

    /**
     * Sets an integer from the keyfile at Settings group
     */
    private void set_integer (string key, int val) {
        keyfile.set_integer ("Settings", key, val);

        save_keyfile ();
    }

    /**
     * Saves the keyfile to disk
     */
    private void save_keyfile () {
        try {
            string data = keyfile.to_data ();
            FileUtils.set_contents (path, data);
        } catch (FileError err) {
            warning ("Error saving keyfile to '%s': %s", path, err.message);
        }
    }
}
