/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: elementary Tweaks Developers, 2016-2020
 *                         Pantheon Tweaks Developers, 2020-2025
 */

namespace ListUtil {
    public static uint liststore_find (ListStore list, string id) {
        assert (list.item_type == typeof (ListItemModel));

        uint pos;

        bool found = list.find_with_equal_func (
            new ListItemModel (id, ""),
            (a, b) => {
                return ((ListItemModel) a).id == ((ListItemModel) b).id;
            },
            out pos
        );

        if (!found) {
            return Gtk.INVALID_LIST_POSITION;
        }

        return pos;
    }

    public static string? liststore_get_id (ListStore list, uint position) {
        assert (list.item_type == typeof (ListItemModel));

        // No item is selected
        if (position == Gtk.INVALID_LIST_POSITION) {
            return null;
        }

        if (position >= list.get_n_items ()) {
            return null;
        }

        var item = list.get_item (position) as ListItemModel;
        if (item == null) {
            // This unlikely happens though, according to Valadoc:
            //     null is never returned for an index that is smaller than the length of the list.
            return null;
        }

        return item.id;
    }

    // Implement Gtk.StringList.find() by ourselves which is only available on GTK >= 4.18
    public static uint strlist_find (Gtk.StringList list, string str) {
        uint pos = uint.MAX;

        for (int i = 0; i < list.n_items; i++) {
            unowned var list_str = list.get_string (i);

            if (list_str == str) {
                pos = i;
                break;
            }
        }

        return pos;
    }
}

