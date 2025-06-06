/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: elementary Tweaks Developers, 2014-2020
 *                         Pantheon Tweaks Developers, 2020-2025
 */

public class PantheonTweaks.Categories : Gtk.Box {
    private List<BasePane> panes;

    private Gtk.Stack stack;
    private Granite.Toast toast;

    ~Categories () {
        for (unowned List<BasePane> pane = panes; pane != null; pane = panes.first ()) {
            stack.remove (pane.data);
            panes.delete_link (pane);
        }
    }

    construct {
        panes = new List<BasePane> ();
        panes.append (new Panes.AppearancePane ());
        panes.append (new Panes.FontsPane ());
        panes.append (new Panes.MiscPane ());
        panes.append (new Panes.FilesPane ());
        panes.append (new Panes.TerminalPane ());

        stack = new Gtk.Stack ();

        var side_bar = new Switchboard.SettingsSidebar (stack) {
            show_title_buttons = true
        };

        toast = new Granite.Toast (_("Reset settings successfully"));

        var overlay = new Gtk.Overlay () {
            child = stack
        };
        overlay.add_overlay (toast);

        var paned = new Gtk.Paned (Gtk.Orientation.HORIZONTAL) {
            hexpand = true,
            resize_start_child = false,
            shrink_start_child = false,
            shrink_end_child = false,
            start_child = side_bar,
            end_child = overlay
        };

        panes.foreach ((pane) => {
            pane.restored.connect (() => {
                toast.send_notification ();
            });

            stack.add_titled (pane, pane.name, pane.title);
        });

        append (paned);
    }

    public void load () {
        panes.foreach ((pane) => {
            bool ret = pane.load ();
            if (!ret) {
                Dialog.show_error_dialog (
                    _("Failed to Load %s Preference").printf (pane.title),
                    _("Make sure your Pantheon desktop installation is up to date and not incomplete.")
                );

                // continue to the next pane
                return;
            }
        });
    }
}
