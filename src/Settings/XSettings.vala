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

namespace ElementaryTweaks {

    public class XSettings
    {
        public string decoration_layout {
            get {
                var overrides = settings.get_value ("overrides");
                var layout = overrides.lookup_value ("Gtk/DecorationLayout", VariantType.STRING);

                if (layout != null) {
                    return layout.get_string ();
                }
                else {
                    return "";
                }
            }
            set {
                if (value != "" && value != "close:maximize") {
                    //FIXME: this is so gross, since we're tossing everything else out
                    VariantBuilder builder = new VariantBuilder (new VariantType ("a{sv}"));
                    builder.add ("{sv}", "Gtk/DecorationLayout", new Variant.string (value));
                    Variant dictionary = builder.end ();
                    settings.set_value ("overrides", dictionary);
                }
                else {
                    settings.reset ("overrides");
                }
            }
        }

        private Settings settings;

        static XSettings? instance = null;

        private XSettings ()
        {
            settings = new Settings ("org.gnome.settings-daemon.plugins.xsettings");
        }

        public static XSettings get_default ()
        {
            if (instance == null)
                instance = new XSettings ();

            return instance;
        }

        public void reset () {
            settings.reset ("overrides");
        }
    }
}
