/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: elementary Tweaks Developers, 2014-2020
 *                         Pantheon Tweaks Developers, 2020-2025
 */

public class PantheonTweaks.Categories : Gtk.Box {
    private const string BUGTRACKER_URL = "https://github.com/pantheon-tweaks/pantheon-tweaks/issues";

    construct {
        var panes = new List<BasePane> ();
        panes.append (new Panes.AppearancePane ());
        panes.append (new Panes.FontsPane ());
        panes.append (new Panes.MiscPane ());
        panes.append (new Panes.FilesPane ());
        panes.append (new Panes.TerminalPane ());

        var stack = new Gtk.Stack ();
        var pane_list = new Switchboard.SettingsSidebar (stack) {
            show_title_buttons = true
        };

        var toast = new Granite.Toast (_("Reset settings successfully"));

        var overlay = new Gtk.Overlay () {
            child = stack
        };
        overlay.add_overlay (toast);

        for (unowned List<BasePane> pane = panes; pane != null; pane = panes.first ()) {
            unowned BasePane _pane = pane.data;

            stack.add_titled (_pane, _pane.name, _pane.title);
            panes.remove_link (pane);

            bool ret = _pane.load ();
            if (!ret) {
                var warning_dialog = new Granite.MessageDialog.with_image_from_icon_name (
                    _("Failed to Load %s Preference").printf (_pane.title),
                    _("Make sure your Pantheon desktop installation is up to date and not incomplete. Please report this problem on our bugtracker if it persists."),
                    "dialog-warning", Gtk.ButtonsType.CLOSE
                ) {
                    modal = true,
                    transient_for = (Gtk.Window) get_root (),
                };

                var report_button = new Gtk.LinkButton.with_label (BUGTRACKER_URL, _("Report Problem…"));
                report_button.clicked.connect (() => {
                    report_button.visited = true;
                });

                warning_dialog.custom_bin.append (report_button);

                warning_dialog.response.connect (warning_dialog.destroy);

                warning_dialog.present ();

                continue;
            }

            _pane.restored.connect (() => {
                toast.send_notification ();
            });
        }

        var paned = new Gtk.Paned (Gtk.Orientation.HORIZONTAL) {
            hexpand = true
        };
        paned.resize_start_child = false;
        paned.shrink_start_child = false;
        paned.shrink_end_child = false;
        paned.set_start_child (pane_list);
        paned.set_end_child (overlay);

        append (paned);
    }
}
