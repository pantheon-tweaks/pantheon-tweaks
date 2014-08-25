/*
 * Copyright (C) Elementary Tweaks Developers, 2014
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

namespace ElementaryTweaks {
    public class Util {

        /**
         * Gets and returns a list of the current themes by path and condition.
         */
        public static Gee.ArrayList<string> get_themes (string path, string condition) {
            var themes = new Gee.ArrayList<string> ();

            string[] dirs = {
                "/usr/share/" + path + "/",
                Environment.get_home_dir () + "/." + path + "/",
                Environment.get_home_dir () + "/.local/share/" + path + "/"};

            foreach (string dir in dirs) {
                try {
                    var enumerator = File.new_for_path (dir).enumerate_children (FileAttribute.STANDARD_NAME, 0);
                    FileInfo file_info;
                    while ((file_info = enumerator.next_file ()) != null) {
                        var name = file_info.get_name ();
                        var checktheme = File.new_for_path (dir + name + "/" + condition);
                        var checkicons = File.new_for_path (dir + name + "/48x48/" + condition);
                        if ( ( checktheme.query_exists() || checkicons.query_exists() ) &&
                                name != "Emacs" && name != "Default" && name != "default" && !themes.contains(name))
                            themes.add(name);
                    }
                } catch (Error e) { /*warning (e.message);*/ }
            }

            return themes;
        }
    }
}
