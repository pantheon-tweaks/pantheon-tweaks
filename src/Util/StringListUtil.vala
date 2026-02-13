/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: elementary Tweaks Developers, 2016-2020
 *                         Pantheon Tweaks Developers, 2020-2026
 */

namespace PantheonTweaks.StringListUtil {
    // TODO: Remove in favor of Gtk.StringList.find() which is only available on GTK >= 4.18
    public static uint find (Gtk.StringList list, string str) {
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
