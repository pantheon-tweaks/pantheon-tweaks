/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: elementary Tweaks Developers, 2016-2020
 *                         Pantheon Tweaks Developers, 2020-2025
 */

public class StringIdListItem : Object {
    public string id { get; construct; }
    public string display_text { get; construct; }

    public StringIdListItem (string id, string display_text) {
        Object (
            id: id,
            display_text: display_text
        );
    }
}
