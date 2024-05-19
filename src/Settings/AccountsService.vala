/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: elementary Tweaks Developers, 2016-2020
 *                         Pantheon Tweaks Developers, 2020-2024
 *
 * Borrowed from:
 * elementary/switchboard-plug-pantheon-shell, src/PantheonAccountsServicePlugin.vala
 */

[DBus (name = "io.elementary.pantheon.AccountsService")]
private interface PantheonTweaks.Pantheon.AccountsService : Object {
    public abstract int prefers_accent_color { get; set; }
}

[DBus (name = "org.freedesktop.Accounts")]
interface PantheonTweaks.FDO.Accounts : Object {
    public abstract string find_user_by_name (string username) throws GLib.Error;
}
