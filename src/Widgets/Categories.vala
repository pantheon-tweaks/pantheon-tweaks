/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: elementary Tweaks Developers, 2014-2020
 *                         Pantheon Tweaks Developers, 2020-2025
 */

public class PantheonTweaks.Categories : Gtk.Box {
    private Gtk.Stack stack;
    private List<BasePane> panes;

    ~Categories () {
        for (unowned List<BasePane> pane = panes; pane != null; pane = panes.first ()) {
            stack.remove (pane.data);
            panes.delete_link (pane);
        }
        warning ("panes: %u", panes.length ());
    }

    construct {
        panes = new List<BasePane> ();
        panes.append (new Panes.AppearancePane ());
        panes.append (new Panes.FontsPane ());
        panes.append (new Panes.MiscPane ());
        panes.append (new Panes.FilesPane ());
        panes.append (new Panes.TerminalPane ());

        stack = new Gtk.Stack ();
        var pane_list = new Switchboard.SettingsSidebar (stack) {
            show_title_buttons = true
        };

        var toast = new Granite.Toast (_("Reset settings successfully"));

        var overlay = new Gtk.Overlay () {
            child = stack
        };
        overlay.add_overlay (toast);

        foreach (var pane in panes) {
            stack.add_titled (pane, pane.name, pane.title);
            pane.restored.connect (() => {
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
