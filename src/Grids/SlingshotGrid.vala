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

    public class SlingshotGrid : Gtk.Grid
    {
        public SlingshotGrid () {
            // setup grid so that it aligns everything properly
            this.set_orientation (Gtk.Orientation.VERTICAL);
            this.margin_top = 24;
            this.row_spacing = 6;
            this.halign = Gtk.Align.CENTER;

            // Slingshot number of rows tweak
            var slingshot_rows = new TweakWidget.with_spin_button (
                        _("Rows:"),
                        _("The number of rows displayed in Slingshot"),
                        null,
                        (() => { return SlingshotSettings.get_default ().rows ; }), // get
                        ((val) => { SlingshotSettings.get_default ().rows = val; }), // set
                        (() => { SlingshotSettings.get_default ().schema.reset ("rows"); }), // reset
                        2, 10, 1
                    );
            this.add (slingshot_rows);

            // Slingshot number of rows tweak
            var slingshot_columns = new TweakWidget.with_spin_button (
                        _("Columns:"),
                        _("The number of columns displayed in Slingshot"),
                        null,
                        (() => { return SlingshotSettings.get_default ().columns ; }), // get
                        ((val) => { SlingshotSettings.get_default ().columns = val; }), // set
                        (() => { SlingshotSettings.get_default ().schema.reset ("columns"); }), // reset
                        4, 15, 1
                    );
            this.add (slingshot_columns);

            /*
            var slingshot_columns_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
            var slingshot_columns = new Gtk.SpinButton.with_range (4, 15, 1);

            slingshot_columns.set_value (SlingshotSettings.get_default ().columns);
            slingshot_columns.value_changed.connect (() => SlingshotSettings.get_default ().columns = slingshot_columns.get_value_as_int() );
            slingshot_columns.width_request = 160;
            slingshot_columns.halign = Gtk.Align.START;

            var slingshot_columns_default = new Gtk.ToolButton.from_stock (Gtk.Stock.REVERT_TO_SAVED);

            slingshot_columns_default.clicked.connect (() => {
                    SlingshotSettings.get_default ().schema.reset("columns");
                    slingshot_columns.set_value (SlingshotSettings.get_default ().columns);
                    });
            slingshot_columns_default.halign = Gtk.Align.START;
            slingshot_columns_box.pack_start (slingshot_columns, false);
            slingshot_columns_box.pack_start (slingshot_columns_default, false);

            this.attach (new LLabel.right (_("Rows:")), 0, 0, 1, 1);
            this.attach (slingshot_rows_box, 1, 0, 1, 1);

            this.attach (new LLabel.right (_("Columns:")), 0, 1, 1, 1);
            this.attach (slingshot_columns_box, 1, 1, 1, 1);
            */
        }
    }
}
