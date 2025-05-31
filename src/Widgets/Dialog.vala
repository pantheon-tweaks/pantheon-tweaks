/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: elementary Tweaks Developers, 2014-2020
 *                         Pantheon Tweaks Developers, 2020-2025
 */

namespace Dialog {
    private const string HELP_URL = "https://github.com/pantheon-tweaks/pantheon-tweaks/discussions";

    public void show_error_dialog (string title, string desc, string? details = null) {
        var error_dialog = new Granite.MessageDialog.with_image_from_icon_name (
            title, desc, "dialog-error", Gtk.ButtonsType.CLOSE
        ) {
            modal = true,
            transient_for = ((Gtk.Application) GLib.Application.get_default ()).active_window
        };

        var help_button = new Gtk.LinkButton.with_label (HELP_URL, _("Get Support…"));
        error_dialog.custom_bin.append (help_button);

        if (details != null) {
            error_dialog.show_error_details (details);
        }

        error_dialog.response.connect (error_dialog.destroy);

        error_dialog.present ();
    }
}
