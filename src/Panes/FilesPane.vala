/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: elementary Tweaks Developers, 2016-2020
 *                         Pantheon Tweaks Developers, 2020-2025
 */

public class PantheonTweaks.Panes.FilesPane : BasePane {
    private Gtk.Switch restore_tabs_switch;
    private Gtk.DropDown date_format_dropdown;

    private Settings settings;
    private ListStore date_format_list;

    public FilesPane () {
        Object (
            name: "files",
            title: _("Files"),
            icon: new ThemedIcon ("system-file-manager"),
            header: _("Applications")
        );
    }

    construct {
        /*************************************************/
        /* Restore Tabs                                  */
        /*************************************************/
        var restore_tabs_label = new Granite.HeaderLabel (_("Restore Tabs")) {
            secondary_text = _("Restore tabs from previous session when launched."),
            hexpand = true
        };

        restore_tabs_switch = new Gtk.Switch () {
            valign = Gtk.Align.CENTER
        };

        var restore_tabs_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 12);
        restore_tabs_box.append (restore_tabs_label);
        restore_tabs_box.append (restore_tabs_switch);

        /*************************************************/
        /* Date Format                                   */
        /*************************************************/
        date_format_list = new ListStore (typeof (StringIdObject));
        date_format_list.append (new StringIdObject ("locale", _("Locale")));
        date_format_list.append (new StringIdObject ("iso", _("ISO")));
        date_format_list.append (new StringIdObject ("informal", _("Informal")));

        var date_format_label = new Granite.HeaderLabel (_("Date Format")) {
            secondary_text = _("Date format used in the properties dialog or the list view."),
            hexpand = true
        };

        date_format_dropdown = DropDownId.new (date_format_list);

        var date_format_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 12);
        date_format_box.append (date_format_label);
        date_format_box.append (date_format_dropdown);

        content_area.append (restore_tabs_box);
        content_area.append (date_format_box);
    }

    public override bool load () {
        if (!SettingsUtil.schema_exists (SettingsUtil.FILES_SCHEMA)) {
            warning ("Could not find settings schema %s", SettingsUtil.FILES_SCHEMA);
            return false;
        }
        settings = new Settings (SettingsUtil.FILES_SCHEMA);

        settings.bind ("restore-tabs", restore_tabs_switch, "active", SettingsBindFlags.DEFAULT);

        settings.bind_with_mapping ("date-format",
            date_format_dropdown, "selected",
            SettingsBindFlags.DEFAULT,
            (SettingsBindGetMappingShared) SettingsUtil.Binding.to_dropdownid_selected,
            (SettingsBindSetMappingShared) SettingsUtil.Binding.from_dropdownid_selected,
            date_format_list, null);

        is_load_success = true;
        return true;
    }

    protected override void do_reset () {
        string[] keys = {"restore-tabs", "date-format"};

        foreach (unowned var key in keys) {
            settings.reset (key);
        }
    }
}
