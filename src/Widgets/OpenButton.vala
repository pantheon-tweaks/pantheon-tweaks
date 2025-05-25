/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: elementary Tweaks Developers, 2014-2020
 *                         Pantheon Tweaks Developers, 2020-2025
 */

public class OpenButton : Gtk.Button {
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
        clicked.connect (on_click);
    }

    private void on_click () {
        var dir = File.new_for_path (path);
        if (!dir.query_exists ()) {
            try {
                dir.make_directory_with_parents ();
            } catch (Error e) {
                show_folder_action_error (
                    _("Failed to create \"%s\"").printf (path),
                    _("The folder doesn't exist and tried to create new but failed. The following error message might be helpful:"),
                    e.message
                );

                return;
            }
        }

        try {
            AppInfo.launch_default_for_uri (dir.get_uri (), null);
        } catch (Error e) {
            show_folder_action_error (
                _("Failed to open \"%s\"").printf (path),
                _("Tried to open the folder but failed. The following error message might be helpful:"),
                e.message
            );
        }
    }

    private void show_folder_action_error (string primary_text, string secondary_text, string error_message) {
        var error_dialog = new Granite.MessageDialog.with_image_from_icon_name (
            primary_text, secondary_text, "dialog-error", Gtk.ButtonsType.CLOSE
        ) {
            modal = true,
            transient_for = (Gtk.Window) get_root ()
        };
        error_dialog.show_error_details (error_message);
        error_dialog.response.connect ((response_id) => {
            error_dialog.destroy ();
        });
        error_dialog.present ();
    }
}
