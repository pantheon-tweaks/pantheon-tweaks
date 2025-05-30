/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: elementary Tweaks Developers, 2014-2020
 *                         Pantheon Tweaks Developers, 2020-2025
 */

public class PantheonTweaks.Categories : Gtk.Box {
    private Gtk.Stack stack;
    private Granite.Toast toast;

    construct {
        stack = new Gtk.Stack ();
        var pane_list = new Switchboard.SettingsSidebar (stack) {
            show_title_buttons = true
        };

        toast = new Granite.Toast (_("Reset settings successfully"));

        var overlay = new Gtk.Overlay () {
            child = stack
        };
        overlay.add_overlay (toast);

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

    public void load () {
        var panes = new List<BasePane> ();
        panes.append (new Panes.AppearancePane ());
        panes.append (new Panes.FontsPane ());
        panes.append (new Panes.MiscPane ());
        panes.append (new Panes.FilesPane ());
        panes.append (new Panes.TerminalPane ());

        for (unowned List<BasePane> pane = panes; pane != null; pane = panes.first ()) {
            unowned BasePane _pane = pane.data;

            stack.add_titled (_pane, _pane.name, _pane.title);
            panes.remove_link (pane);

            bool ret = _pane.load ();
            if (!ret) {
                Dialog.show_error_dialog (
                    _("Failed to Load %s Preference").printf (_pane.title),
                    _("Make sure your Pantheon desktop installation is up to date and not incomplete.")
                );

                continue;
            }

            _pane.restored.connect (() => {
                toast.send_notification ();
            });
        }
    }
}
