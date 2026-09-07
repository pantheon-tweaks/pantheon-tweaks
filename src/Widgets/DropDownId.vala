/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: elementary Tweaks Developers, 2016-2020
 *                         Pantheon Tweaks Developers, 2020-2026
 */

namespace PantheonTweaks.DropDownId {
    public static Gtk.DropDown new (owned ListModel? list_model) {
        var list_factory = new Gtk.SignalListItemFactory ();
        list_factory.setup.connect (list_factory_setup);
        list_factory.bind.connect (list_factory_bind);

        var expression = new Gtk.PropertyExpression (
            typeof (StringIdObject), null, "display_text"
        );
        var dropdown = new Gtk.DropDown (list_model, expression) {
            list_factory = list_factory,
            valign = Gtk.Align.CENTER
        };

        return dropdown;
    }

    private static void list_factory_setup (Object object) {
        var item = object as Gtk.ListItem;

        var row = new DropDownRow ();
        item.child = row;
    }

    private static void list_factory_bind (Object object) {
        var item = object as Gtk.ListItem;
        var model = item.item as StringIdObject;
        var row = item.child as DropDownRow;

        row.label.label = model.display_text;
    }
}
