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

public class FilesGrid : Gtk.Grid
{
    public FilesGrid () {
        this.row_spacing = 6;
        this.column_spacing = 12;
        this.margin_top = 24;
        this.column_homogeneous = true;


        /* Single Click */
        var single_click = new Gtk.Switch ();

        single_click.set_active(FilesSettings.get_default ().single_click);
        single_click.notify["active"].connect (() => FilesSettings.get_default ().single_click = single_click.active );
        single_click.halign = Gtk.Align.START;


        /* Date Format */
        var date_format_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        var date_format = new Gtk.ComboBoxText ();
        date_format.append ("locale", _("Locale"));
        date_format.append ("iso", _("ISO"));
        date_format.append ("informal", _("Informal"));

        date_format.active_id = FilesSettings.get_default ().date_format;
        date_format.changed.connect (() => FilesSettings.get_default ().date_format = date_format.active_id );
        date_format.halign = Gtk.Align.START;
        date_format.width_request = 160;

        var date_format_default = new Gtk.ToolButton.from_stock (Gtk.Stock.REVERT_TO_SAVED);

        date_format_default.clicked.connect (() => {
            FilesSettings.get_default ().schema.reset("date-format");
            date_format.active_id = FilesSettings.get_default ().date_format;
        });
        date_format_default.halign = Gtk.Align.START;

        date_format_box.pack_start (date_format, false);
        date_format_box.pack_start (date_format_default, false);

        /* Sidebar Zoom Level */
        var sidebar_zoom_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        var sidebar_zoom = new Gtk.ComboBoxText ();
        sidebar_zoom.append ("smallest", _("Smallest"));
        sidebar_zoom.append ("smaller", _("Smaller"));
        sidebar_zoom.append ("small", _("Small"));
        sidebar_zoom.append ("normal", _("Normal"));
        sidebar_zoom.append ("large", _("Large"));
        sidebar_zoom.append ("larger", _("Larger"));
        sidebar_zoom.append ("largest", _("Largest"));

        sidebar_zoom.active_id = FilesSettings.get_default ().sidebar_zoom_level;
        sidebar_zoom.changed.connect (() => FilesSettings.get_default ().sidebar_zoom_level = sidebar_zoom.active_id );
        sidebar_zoom.halign = Gtk.Align.START;
        sidebar_zoom.width_request = 160;

        var sidebar_zoom_default = new Gtk.ToolButton.from_stock (Gtk.Stock.REVERT_TO_SAVED);

        sidebar_zoom_default.clicked.connect (() => {
            FilesSettings.get_default ().schema.reset("sidebar-zoom-level");
            FilesSettings.get_default ().sidebar_zoom_level;
        });
        sidebar_zoom_default.halign = Gtk.Align.START;

        sidebar_zoom_box.pack_start (sidebar_zoom, false);
        sidebar_zoom_box.pack_start (sidebar_zoom_default, false);

        this.attach (new LLabel.right (_("Single Click:")), 0, 0, 1, 1);
        this.attach (single_click, 1, 0, 1, 1);

        this.attach (new LLabel.right (_("Date Format:")), 0, 1, 1, 1);
        this.attach (date_format_box, 1, 1, 1, 1);

        this.attach (new LLabel.right (_("Sidebar Icon Size:")), 0, 2, 1, 1);
        this.attach (sidebar_zoom_box, 1, 2, 1, 1);
    }
}
