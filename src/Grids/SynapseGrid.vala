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

public class SynapseGrid : Gtk.Grid
{

    public SynapseGrid () {
        this.row_spacing = 6;
        this.column_spacing = 12;
        this.margin_top = 24;
        this.column_homogeneous = true;

        var key = new AcceleratorInput ();
        var key_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        key.set_accelerator_from_string(SynapseSettings.get_default ().shortcut);
        key.width_request = 160;

        key.accelerator_set.connect (() => SynapseSettings.get_default ().shortcut = key.get_accelerator_from_string());

        var key_default = new Gtk.ToolButton.from_stock (Gtk.Stock.REVERT_TO_SAVED);

        key_default.clicked.connect (() => {
            SynapseSettings.get_default ().schema.reset("shortcut");
            key.set_accelerator_from_string(SynapseSettings.get_default ().shortcut);
        });

        key_box.pack_start (key, false);
        key_box.pack_start (key_default, false);



        this.attach (new LLabel.right (_("Search Indicator Shortcut:")), 0, 0, 1, 1);
        this.attach (key_box, 1, 0, 1, 1);
    }
}
