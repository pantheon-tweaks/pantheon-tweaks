/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: elementary Tweaks Developers, 2016-2020
 *                         Pantheon Tweaks Developers, 2020-2025
 */

namespace PantheonTweaks.DropDownUtil {
    public static bool settings_value_to_selected (Value selected, Variant settings_value, void* user_data) {
        string selected_id = settings_value.get_string ();
        var list = (Gtk.StringList) user_data;

        uint selected_pos = StringListUtil.find (list, selected_id);
        if (selected_pos == uint.MAX) {
            selected.set_uint (Gtk.INVALID_LIST_POSITION);
            // Never returns false because it causes intentional crash
            return true;
        }

        selected.set_uint (selected_pos);
        return true;
    }

    public static Variant selected_to_settings_value (Value selected, VariantType value_type, void* user_data) {
        uint selected_pos = selected.get_uint ();
        var list = (Gtk.StringList) user_data;

        unowned string? selected_id = list.get_string (selected_pos);
        if (selected_id == null) {
            return new Variant.string ("");
        }

        return new Variant.string (selected_id);
    }
}
