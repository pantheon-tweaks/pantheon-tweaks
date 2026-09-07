/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: elementary Tweaks Developers, 2014-2020
 *                         Pantheon Tweaks Developers, 2020-2026
 */

namespace PantheonTweaks.Dialog {
    public void show_error_dialog (string title, string desc, string? details = null) {
        var error_dialog = new Granite.MessageDialog.with_image_from_icon_name (
            title, desc, "dialog-error", Gtk.ButtonsType.CLOSE
        ) {
            modal = true,
            transient_for = ((Gtk.Application) GLib.Application.get_default ()).active_window
        };

        if (details != null) {
            error_dialog.show_error_details (details);
        }

        error_dialog.response.connect (error_dialog.destroy);

        error_dialog.present ();
    }
}
