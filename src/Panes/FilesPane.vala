/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: elementary Tweaks Developers, 2016-2020
 *                         Pantheon Tweaks Developers, 2020-2025
 */

public class PantheonTweaks.Panes.FilesPane : BasePane {
    public class ListItemModel : Object {
        public string value { get; construct; }
        public string display_text { get; construct; }

        public ListItemModel (string value, string display_text) {
            Object (
                value: value,
                display_text: display_text
            );
        }
    }

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

    private const string FILES_SCHEMA = "io.elementary.files.preferences";

    private Settings settings;
    private ListStore date_format_list;
    private Gtk.DropDown date_format_combo;

    public FilesPane () {
        base ("files", _("Files"), "system-file-manager");
    }

    construct {
        if (!if_show_pane ({ FILES_SCHEMA })) {
            return;
        }

        settings = new Settings (FILES_SCHEMA);

        /*************************************************/
        /* Restore Tabs                                  */
        /*************************************************/
        var restore_tabs_label = new Granite.HeaderLabel (_("Restore Tabs")) {
            secondary_text = _("Restore tabs from previous session when launched."),
            hexpand = true
        };
        var restore_tabs_switch = new Gtk.Switch () {
            valign = Gtk.Align.CENTER
        };
        var restore_tabs_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 12);
        restore_tabs_box.append (restore_tabs_label);
        restore_tabs_box.append (restore_tabs_switch);

        /*************************************************/
        /* Date Format                                   */
        /*************************************************/
        date_format_list = new ListStore (typeof (ListItemModel));
        date_format_list.append (new ListItemModel ("locale", _("Locale")));
        date_format_list.append (new ListItemModel ("iso", _("ISO")));
        date_format_list.append (new ListItemModel ("informal", _("Informal")));

        var date_format_label = new Granite.HeaderLabel (_("Date Format")) {
            secondary_text = _("Date format used in the properties dialog or the list view."),
            hexpand = true
        };
        date_format_combo = dropdown_new (date_format_list);

        var date_format_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 12);
        date_format_box.append (date_format_label);
        date_format_box.append (date_format_combo);

        content_area.attach (restore_tabs_box, 0, 0, 1, 1);
        content_area.attach (date_format_box, 0, 1, 1, 1);

        settings.bind ("restore-tabs", restore_tabs_switch, "active", SettingsBindFlags.DEFAULT);

        settings.changed["date-format"].connect ((key) => {
            string selected_value = settings.get_string (key);
            uint selected_pos = liststore_get_position (date_format_list, selected_value);
            date_format_combo.selected = selected_pos;
        });

        date_format_combo.notify["selected"].connect (() => {
            uint selected_pos = date_format_combo.selected;
            string? selected_value = liststore_get_value (date_format_list, selected_pos);
            if (selected_value != null) {
                settings.set_string ("date-format", selected_value);
            }
        });
    }

    private uint liststore_get_position (ListStore list, string value) {
        assert (list.item_type == typeof (ListItemModel));

        uint pos;

        bool found = date_format_list.find_with_equal_func (
            new ListItemModel (value, ""),
            (a, b) => {
                return ((ListItemModel) a).value == ((ListItemModel) b).value;
            },
            out pos
        );

        if (!found) {
            return Gtk.INVALID_LIST_POSITION;
        }

        return pos;
    }

    private string? liststore_get_value (ListStore list, uint position) {
        assert (list.item_type == typeof (ListItemModel));

        // No item is selected
        if (position == Gtk.INVALID_LIST_POSITION) {
            return null;
        }

        var item = list.get_item (position) as ListItemModel;
        if (item == null) {
            return null;
        }

        return item.value;
    }

    private void list_factory_setup (Object object) {
        var item = object as Gtk.ListItem;

        var row = new DropDownRow ();
        item.child = row;
    }

    private void list_factory_bind (Object object) {
        var item = object as Gtk.ListItem;
        var model = item.item as ListItemModel;
        var row = item.child as DropDownRow;

        row.label.label = _(model.display_text);
    }

    protected Gtk.DropDown dropdown_new (owned ListModel? list_model) {
        var list_factory = new Gtk.SignalListItemFactory ();
        list_factory.setup.connect (list_factory_setup);
        list_factory.bind.connect (list_factory_bind);

        var expression = new Gtk.PropertyExpression (
            typeof (ListItemModel), null, "display_text"
        );
        var dropdown = new Gtk.DropDown (list_model, expression) {
            list_factory = list_factory
        };

        return dropdown;
    }

    protected override void do_reset () {
        string[] keys = {"restore-tabs", "date-format"};

        foreach (var key in keys) {
            settings.reset (key);
        }
    }
}
