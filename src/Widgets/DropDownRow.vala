/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: elementary Tweaks Developers, 2016-2020
 *                         Pantheon Tweaks Developers, 2020-2025
 */

public class DropDownRow : Gtk.Box {
    public Gtk.Label label { get; set; }

    public DropDownRow () {
    }

    construct {
        orientation = Gtk.Orientation.VERTICAL;

        label = new Gtk.Label (null) {
            halign = Gtk.Align.START
        };

        append (label);
    }
}
