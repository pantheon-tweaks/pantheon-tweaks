/*
 * Copyright (C) Elementary Tweaks Developers, 2016 - 2020
 *               Pantheon Tweaks Developers, 2020
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
