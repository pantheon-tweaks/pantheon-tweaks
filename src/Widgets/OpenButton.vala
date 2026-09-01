/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: elementary Tweaks Developers, 2014-2020
 *                         Pantheon Tweaks Developers, 2020-2026
 */

public class PantheonTweaks.OpenButton : Gtk.Button {
    public string path { get; construct; }

    public OpenButton (string path) {
        Object (
            icon_name: "folder-open",
            path: path,
            valign: Gtk.Align.CENTER,
            tooltip_text: _("Open \"%s\"").printf (path)
        );
    }

    construct {
        clicked.connect (() => {
            try {
                open ();
            } catch (Error err) {
                Dialog.show_error_dialog (
                    _("Failed To Open \"%s\"").printf (path),
                    _("There was an error when opening the directory or creating it."),
                    err.message
                );
            }
        });
    }

    private void open () throws Error {
        var dir = File.new_for_path (path);
        if (!dir.query_exists ()) {
            try {
                dir.make_directory_with_parents ();
            } catch (Error err) {
                warning ("Failed to create '%s': %s", path, err.message);
                throw err;
            }
        }

        try {
            AppInfo.launch_default_for_uri (dir.get_uri (), null);
        } catch (Error err) {
            warning ("Failed to open '%s': %s", path, err.message);
            throw err;
        }
    }
}
