/*
 * Copyright (C) Elementary Tweaks Developers, 2014 - 2016
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 */

namespace PantheonTweaks {

    /**
     * Settings for Gtk; thanks gnome-tweak-tool for the help!
     */
    public class GtkSettings {
        private GLib.KeyFile keyfile;
        private string path;
        private static GtkSettings? instance = null;

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

        /**
         * Creates a new GTKSettings
         */
        public GtkSettings () {
            keyfile = new GLib.KeyFile ();

            path = GLib.Environment.get_user_config_dir () + "/gtk-3.0/settings.ini";

            if (!(File.new_for_path (path).query_exists ())) {
                return;
            }

            try {
                keyfile.load_from_file (path, 0);
            }
            catch (Error e) {
                warning ("Error loading GTK+ Keyfile settings.ini: " + e.message);
            }
        }

        public static GtkSettings get_default () {
            if (instance == null)
                instance = new GtkSettings ();

            return instance;
        }

        /**
         * Gets an integer from the keyfile at Settings group
         */
        private int get_integer (string key) {
            int key_int = 0;

            try {
                key_int = keyfile.get_integer ("Settings", key);
            }
            catch (Error e) {
                warning ("Error getting GTK+ int setting: " + e.message);
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
                string data = keyfile.to_data();
                GLib.FileUtils.set_contents(path, data);
            }
            catch (GLib.FileError e) {
                warning ("Error saving GTK+ Keyfile settings.ini: " + e.message);
            }
        }
    }
}
