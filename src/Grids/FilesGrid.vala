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

    public class FilesGrid : Gtk.Grid
    {
        public FilesGrid () {
            // setup grid so that it aligns everything properly
            this.set_orientation (Gtk.Orientation.VERTICAL);
            this.margin_top = 24;
            this.row_spacing = 6;
            this.halign = Gtk.Align.CENTER;

            // Single Click tweak
            var single_click = new TweakWidget.with_switch (
                        _("Single Click:"),
                        _("If set off, files will use 'normal' double-click behavior"),
                        null,
                        (() => { return FilesSettings.get_default ().single_click; }), // get
                        ((val) => { FilesSettings.get_default ().single_click = val; }), // set
                        (() => { FilesSettings.get_default ().schema.reset ("single-click"); }) // reset
                    );
            this.add (single_click);

            // Date format tweak
            var date_format_map = new Gee.HashMap<string, string> ();
            date_format_map.set ("locale", _("Locale"));
            date_format_map.set ("iso", _("ISO"));
            date_format_map.set ("informal", _("Informal"));

            var date_format = new TweakWidget.with_combo_box (
                        _("Date Format:"),
                        _("For date accessed, modified, etc."),
                        null,
                        (() => { return FilesSettings.get_default ().date_format; }), // get
                        ((val) => { FilesSettings.get_default ().date_format = val; }), // set
                        (() => { FilesSettings.get_default ().schema.reset ("date-format"); }), // reset
                        date_format_map
                    );
            this.add (date_format);

            // Sidebar Zoom tweak
            var sidebar_zoom_map = new Gee.HashMap<string, string> ();
            sidebar_zoom_map.set ("smallest", _("Smallest"));
            sidebar_zoom_map.set ("smaller", _("Smaller"));
            sidebar_zoom_map.set ("small", _("Small"));
            sidebar_zoom_map.set ("normal", _("Normal"));
            sidebar_zoom_map.set ("large", _("Large"));
            sidebar_zoom_map.set ("larger", _("Larger"));
            sidebar_zoom_map.set ("largest", _("Largest"));

            var sidebar_zoom = new TweakWidget.with_combo_box (
                        _("Sidebar Icon Size:"),
                        _("Size of the icons in the sidebar"),
                        null,
                        (() => { return FilesSettings.get_default ().sidebar_zoom_level; }), // get
                        ((val) => { FilesSettings.get_default ().sidebar_zoom_level = val; }), // set
                        (() => { FilesSettings.get_default ().schema.reset ("sidebar-zoom-level"); }), // reset
                        sidebar_zoom_map
                    );
            this.add (sidebar_zoom);
        }
    }
}
