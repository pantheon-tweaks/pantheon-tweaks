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

public class CerbereGrid : Gtk.Grid
{
    Gtk.ListStore list_store;
    Gtk.TreeView list;
    Gee.ArrayList<string> watched;

    public CerbereGrid () {
        this.row_spacing = 6;
        this.column_spacing = 12;
        this.margin_top = 0;
        this.column_homogeneous = true;

        list_store = new Gtk.ListStore (1, typeof (string));
        watched = new Gee.ArrayList<string> ();
        list_update();

        list = new Gtk.TreeView.with_model (list_store);
        list.expand = true;

        Gtk.CellRendererText cell = new Gtk.CellRendererText ();
        cell.editable = true;
        list.insert_column_with_attributes (-1, " " + _("Watched Processes"), cell, "text", 0);

        var tbar = new Gtk.Toolbar();
        tbar.set_style(Gtk.ToolbarStyle.ICONS);
        tbar.set_icon_size(Gtk.IconSize.SMALL_TOOLBAR);
        tbar.set_show_arrow(false);
        tbar.hexpand = true;

        tbar.get_style_context().add_class(Gtk.STYLE_CLASS_INLINE_TOOLBAR);
        tbar.get_style_context().set_junction_sides(Gtk.JunctionSides.TOP);

        var add_button = new Gtk.ToolButton (null, _("Add..."));
        var remove_button = new Gtk.ToolButton (null, _("Remove"));
        var spacer = new Gtk.ToolItem ();
        var reset_button = new Gtk.ToolButton.from_stock (Gtk.Stock.REVERT_TO_SAVED);

        spacer.set_expand(true);

        add_button.set_icon_name ("list-add-symbolic");
        remove_button.set_icon_name ("list-remove-symbolic");

        add_button.set_tooltip_text (_("Add..."));
        remove_button.set_tooltip_text (_("Remove"));
        reset_button.set_tooltip_text (_("Revert to Default"));

        tbar.insert (add_button, -1);
        tbar.insert (remove_button, -1);
        tbar.insert (spacer, -1);
        tbar.insert (reset_button, -1);

        add_button.clicked.connect (() => {
            var add_popover = new Granite.Widgets.PopOver();
            var entry = new Gtk.Entry ();
            var apply = new Gtk.ToolButton.from_stock (Gtk.Stock.ADD);
            var box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);

            apply.clicked.connect (() => {
                list_add( entry.get_text () );
                add_popover.destroy ();
            });

            entry.activate.connect (() => {
                list_add( entry.get_text () );
                add_popover.destroy ();
            });

            box.pack_start (entry);
            box.pack_start (apply);

            ((Gtk.Box)add_popover.get_content_area ()).add (box);
            add_popover.move_to_widget(add_button);
            add_popover.show_all ();
            add_popover.present ();
            add_popover.run ();
            add_popover.destroy ();
        });

        remove_button.clicked.connect (() => list_remove());

        cell.edited.connect ((path, new_text) => list_edit( path, new_text ) );

        reset_button.clicked.connect (() => {
            if ( watched.contains("wingpanel-slim") )
                CerbereSettings.get_default ().monitored_processes = { "wingpanel-slim" , "plank", "slingshot-launcher --silent" };
            else
                CerbereSettings.get_default ().schema.reset ("monitored-processes");
            list_update();
        });

        CerbereSettings.get_default ().schema.changed.connect (() => list_update());

        /* Add to Grid */
        this.attach (list, 0, 0, 1, 1);
        this.attach (tbar, 0, 1, 1, 1);
    }

    void list_update() {
        watched.clear();
        list_store.clear();

        foreach (string process in CerbereSettings.get_default ().monitored_processes) {
            Gtk.TreeIter iter;

            watched.add(process);
            list_store.append (out iter);
            list_store.set (iter, 0, process);
        }
    }

    void list_add( string text ) {
        if ( text != "") {
            watched.add (text);
            CerbereSettings.get_default ().monitored_processes = watched.to_array();
        }
    }

    void list_remove() {
        GLib.Value name;
        Gtk.TreeIter iter;
        Gtk.TreePath path;

        list.get_cursor (out path, null);
        if (path != null) {
            list_store.get_iter (out iter, path);
            list_store.get_value (iter, 0, out name);

            watched.remove (name.get_string ());
            CerbereSettings.get_default ().monitored_processes = watched.to_array();
        }
    }

    void list_edit ( string path, string new_text) {
        GLib.Value name;
        Gtk.TreeIter iter;

        list_store.get_iter (out iter, new Gtk.TreePath.from_string (path));
        list_store.get_value (iter, 0, out name);

        watched.set (watched.index_of (name.get_string ()) , new_text);
        CerbereSettings.get_default ().monitored_processes = watched.to_array();
        name.set_string (new_text);
        list_store.set_value (iter, 0, name);
    }

}
