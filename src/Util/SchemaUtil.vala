/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: elementary Tweaks Developers, 2016-2020
 *                         Pantheon Tweaks Developers, 2020-2025
 */

namespace PantheonTweaks.SchemaUtil {
    public const string INTERFACE_SCHEMA = "org.gnome.desktop.interface";
    public const string SOUND_SCHEMA = "org.gnome.desktop.sound";
    public const string GNOME_WM_SCHEMA = "org.gnome.desktop.wm.preferences";

    public const string FILES_SCHEMA = "io.elementary.files.preferences";

    public const string PANEL_SOUND_SCHEMA = "io.elementary.desktop.wingpanel.sound";

    public const string TERMINAL_SCHEMA = "io.elementary.terminal.settings";

    public const string XSETTINGS_SCHEMA = "org.gnome.settings-daemon.plugins.xsettings";

    public static bool schema_exists (string schema) {
        return (SettingsSchemaSource.get_default ().lookup (schema, true) != null);
    }
}
