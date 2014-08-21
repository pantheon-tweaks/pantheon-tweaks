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

    public class ShortcutsGrid : Gtk.Grid
    {
        Gtk.ListStore store;
        Gtk.TreeView key;

        public ShortcutsGrid () {
            this.row_spacing = 6;
            this.column_spacing = 12;
            this.margin_top = 0;
            this.column_homogeneous = true;

            store = new Gtk.ListStore (5,
                    typeof (string), // Name
                    typeof (string), // Shortcut
                    typeof (string), // Shortcut Display
                    typeof (string), // Command
                    typeof (int)     // Index
                    );
            list_update();

            var css = new Gtk.CssProvider ();
            css.load_from_data ("""
                    GtkTreeView { background-color: @fff; }
GtkTreeView:selected { background-color: @selected_bg_color; }
""", -1);

key = new Gtk.TreeView.with_model (store);
key.expand = true;
key.get_style_context ().add_provider (css, 9999999);

var cell_name = new Gtk.CellRendererText ();
cell_name.editable = true;
cell_name.alignment = Pango.Alignment.LEFT;

var cell_shortcut = new Gtk.CellRendererAccel ();
cell_shortcut.editable = true;
cell_shortcut.accel_mode = Gtk.CellRendererAccelMode.OTHER;
cell_shortcut.alignment = Pango.Alignment.CENTER;

var cell_command = new Gtk.CellRendererText ();
cell_command.editable = true;
cell_command.alignment = Pango.Alignment.RIGHT;

cell_shortcut.accel_edited.connect ((path, key, mods) => change_shortcut(path, new Shortcut (key, mods)));

cell_shortcut.accel_cleared.connect ((path) => change_shortcut (path, (Shortcut) null));

cell_name.edited.connect ((path, new_text) => list_edit( path, new_text, null, null ));
cell_command.edited.connect ((path, new_text) => list_edit( path, null, null, new_text ));

key.insert_column_with_attributes (-1, " " + _("Name"), cell_name, "text", 0);
key.insert_column_with_attributes (-1, " " + _("Shortcut"), cell_shortcut, "text", 2);
key.insert_column_with_attributes (-1, " " + _("Command"), cell_command, "text", 3);

//        Debbuging:
//        var cell_int = new Gtk.CellRendererText ();
//        cell_int.alignment = Pango.Alignment.RIGHT;
//        key.insert_column_with_attributes (-1, null, cell_int, "text", 3);


foreach (var column in key.get_columns()) {
    column.expand = true;
}

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

add_button.clicked.connect (() => {
        var add_popover = new Granite.Widgets.PopOver();
        var entry_name = new Gtk.Entry ();
        var entry_shortcut = new AcceleratorInput ();
        var entry_command = new Gtk.Entry ();
        var label_warning = new Gtk.Label (null);
        var apply = new Gtk.ToolButton.from_stock (Gtk.Stock.ADD);
        var box = new Gtk.Grid ();

        entry_name.width_request = 160;
        entry_shortcut.width_request = 160;
        entry_command.width_request = 160;
        apply.halign = Gtk.Align.START;
        label_warning.set_use_markup (true);
        label_warning.set_line_wrap (true);

        box.row_spacing = 6;
        box.column_spacing = 12;

        apply.clicked.connect (() => {
            if ( entry_name.get_text() == "" || entry_command.get_text() == "" || entry_shortcut.get_accelerator_from_string() == "") {
            label_warning.label = "<span foreground=\"red\">" + _("Every field must be filled!") + "</span>";
            }
            else {
            label_warning.label = "";
            list_add( entry_name.get_text(), entry_shortcut.get_accelerator_from_string(), entry_command.get_text());
            add_popover.destroy ();
            }
            });

        box.attach (new LLabel.right (_("Name:")), 0, 0, 1, 1);
        box.attach (entry_name, 1, 0, 1, 1);

        box.attach (new LLabel.right (_("Shortcut:")), 0, 1, 1, 1);
        box.attach (entry_shortcut, 1, 1, 1, 1);

        box.attach (new LLabel.right (_("Command:")), 0, 2, 1, 1);
        box.attach (entry_command, 1, 2, 1, 1);

        box.attach (label_warning, 1, 3, 1, 1);
        box.attach (apply, 2, 2, 1, 1);

        ((Gtk.Box)add_popover.get_content_area ()).add (box);
        add_popover.move_to_widget(add_button);
        add_popover.show_all ();
        add_popover.present ();
        add_popover.run ();
        add_popover.destroy ();
});

remove_button.clicked.connect (() => list_remove());

reset_button.clicked.connect (() => {
        KeyboardSettings.reset_custom_shortcuts();
        list_update();
        });

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


this.attach (key, 0, 0, 1, 1);
this.attach (tbar, 0, 1, 1, 1);
}

void list_update() {
    store.clear();
    var keyboard_settings = KeyboardSettings.list_custom_shortcuts ();

    foreach (var s in keyboard_settings) {
        Gtk.TreeIter iter;
        var short_obj = new Shortcut.parse (s.shortcut);

        store.append (out iter);
        store.set (iter, 0, s.name);
        store.set (iter, 1, s.shortcut);
        store.set (iter, 2, short_obj.to_readable());
        store.set (iter, 3, s.command);
        store.set (iter, 4, s.index);
    }
}

void change_shortcut (string path, Shortcut? shortcut) {
    if ( shortcut == null )
        list_edit( path, null, "", null );
    else
        list_edit( path, null, shortcut.to_gsettings(), null );
}

void list_add( string name, string shortcut, string command ) {
    Gtk.TreeIter iter;
    var short_obj = new Shortcut.parse (shortcut);

    int index = KeyboardSettings.add_custom_shortcut (name, shortcut, command);

    store.append (out iter);
    store.set (iter, 0, name);
    store.set (iter, 1, shortcut);
    store.set (iter, 2, short_obj.to_readable());
    store.set (iter, 3, command);
    store.set (iter, 4, index);
}

void list_remove() {
    GLib.Value index;
    Gtk.TreeIter iter;
    Gtk.TreePath path;

    key.get_cursor (out path, null);
    if (path != null) {
        store.get_iter (out iter, path);
        store.get_value (iter, 4, out index);
        if (index.get_int() == 0)
            return;
        store.remove (iter);

        KeyboardSettings.remove_custom_shortcut (index.get_int());
    }
}

void list_edit ( string path, string ? new_name, string ? new_shortcut, string ? new_command) {
    GLib.Value name;
    GLib.Value shortcut;
    GLib.Value command;
    GLib.Value index;
    Gtk.TreeIter iter;

    store.get_iter (out iter, new Gtk.TreePath.from_string (path));

    if ( new_name != null )
        store.set (iter, 0, new_name);
    if ( new_shortcut != null ) {
        var short_obj = new Shortcut.parse (new_shortcut);
        store.set (iter, 1, new_shortcut);
        store.set (iter, 2, short_obj.to_readable());
    }
    if ( new_command != null )
        store.set (iter, 3, new_command);

    store.get_value (iter, 0, out name);
    store.get_value (iter, 1, out shortcut);
    store.get_value (iter, 3, out command);
    store.get_value (iter, 4, out index);

    KeyboardSettings.edit_custom_shortcuts (name.get_string(), shortcut.get_string(), command.get_string(), index.get_int());
}
}
}
