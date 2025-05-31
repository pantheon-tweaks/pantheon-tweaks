/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: elementary Tweaks Developers, 2016-2020
 *                         Pantheon Tweaks Developers, 2020-2025
 */

namespace DropDownId {
    private static void list_factory_setup (Object object) {
        var item = object as Gtk.ListItem;

        var row = new DropDownRow ();
        item.child = row;
    }

    private static void list_factory_bind (Object object) {
        var item = object as Gtk.ListItem;
        var model = item.item as StringIdObject;
        var row = item.child as DropDownRow;

        row.label.label = model.display_text;
    }

    public static Gtk.DropDown new (owned ListModel? list_model) {
        var list_factory = new Gtk.SignalListItemFactory ();
        list_factory.setup.connect (list_factory_setup);
        list_factory.bind.connect (list_factory_bind);

        var expression = new Gtk.PropertyExpression (
            typeof (StringIdObject), null, "display_text"
        );
        var dropdown = new Gtk.DropDown (list_model, expression) {
            list_factory = list_factory,
            valign = Gtk.Align.CENTER
        };

        return dropdown;
    }

    public static bool settings_value_to_selected (Value selected, Variant settings_value, void* user_data) {
        string selected_id = settings_value.get_string ();
        var list = (ListStore) user_data;

        uint selected_pos = StringIdListUtil.find (list, selected_id);
        if (selected_pos == Gtk.INVALID_LIST_POSITION) {
            selected.set_uint (selected_pos);
            // Never returns false because it causes intentional crash
            return true;
        }

        selected.set_uint (selected_pos);
        return true;
    }

    public static Variant selected_to_settings_value (Value selected, VariantType value_type, void* user_data) {
        uint selected_pos = selected.get_uint ();
        var list = (ListStore) user_data;

        string? selected_id = StringIdListUtil.get_id (list, selected_pos);
        if (selected_id == null) {
            return new Variant.string ("");
        }

        return new Variant.string (selected_id);
    }
}
