/*
 * Copyright (C) Elementary Tweak Developers, 2014
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

public class KeyboardSettings : GConf.Client
{
    const int MAX_KEYBINDINGS = 1000;
    const string KEYBINDING_DIR = "/desktop/gnome/keybindings";

    public struct Shortcut {
        string name;
        string shortcut;
        string command;
        int index;
    }

    // Ported from GCC, returns the index of the new shortcut
    public static int add_custom_shortcut (string name, string shortcut, string command) {
        var client = GConf.Client.get_default ();
        int i;
        string dir = "";

        for (i = 0; i < MAX_KEYBINDINGS; i++) {
            dir = "%s/custom%d".printf (KEYBINDING_DIR, i);
            var client_exists = false;
            try {
                 client_exists = client.dir_exists (dir);
            } catch (Error e) {
               warning (e.message);
            }
            if (!client_exists)
                break;
        }

        if (i == MAX_KEYBINDINGS) {
            warning ("No more custom shortcuts available");
            return -1;
        }

        try {
            client.set_string (dir + "/binding", shortcut);
            client.set_string (dir + "/name", name);
            client.set_string (dir + "/action", command);
        } catch (Error e) {
            warning (e.message);
            return -1;
        }

        return i;
    }

    public static bool remove_custom_shortcut (int index) {
        GConf.Client client;
        try {
            client = GConf.Client.get_default ();
            if (!client.recursive_unset ("%s/custom%d".printf (KEYBINDING_DIR, index), 0)) {
                warning ("Could not unset keybinding");
                return false;
            }
            client.suggest_sync ();
        } catch (Error e) {
            warning (e.message);
        }
        return true;
    }

    public static bool edit_custom_shortcuts (string name, string shortcut, string command, int index) {
        var client = GConf.Client.get_default ();
        var dir = KEYBINDING_DIR + "/custom" + index.to_string();
        try {
            client.set_string (dir + "/binding", shortcut);
            client.set_string (dir + "/name", name);
            client.set_string (dir + "/action", command);
        } catch (Error e) {
            warning (e.message);
            return false;
        }

        return true;
    }

    public static List<Shortcut?> list_custom_shortcuts () {
        var list = new List<Shortcut?> ();
        var client = GConf.Client.get_default ();

        try {
            var dirs = client.all_dirs (KEYBINDING_DIR);
            foreach (var dir in dirs) {
                list.append ({
                    client.get_string (dir + "/name"),
                    client.get_string (dir + "/binding"),
                    client.get_string (dir + "/action"),
                    int.parse(dir.replace("/desktop/gnome/keybindings/custom", ""))
                });
            }
        } catch (Error e) {
            warning (e.message);
        }

        return list;
    }

    public static void reset_custom_shortcuts () {
        var client = GConf.Client.get_default ();

        try {
            var dirs = client.all_dirs (KEYBINDING_DIR);
            foreach (var dir in dirs) {
                if (!client.recursive_unset (dir, 0))
                    warning ("Could not unset keybinding");
            }
        } catch (Error e) {
            warning (e.message);
        }
    }

}
