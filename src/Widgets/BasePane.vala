/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: elementary Tweaks Developers, 2014-2020
 *                         Pantheon Tweaks Developers, 2020-2024
 */

public abstract class BasePane : Switchboard.SettingsPage {
    public signal void restored ();

    protected abstract void do_reset ();

    protected Gtk.Grid content_area;

    protected BasePane (string name, string title, string icon_name, string? description = null) {
        Object (
            name: name,
            title: title,
            icon: new ThemedIcon (icon_name),
            description: description
        );
    }

    construct {
        show_end_title_buttons = true;

        content_area = new Gtk.Grid () {
            column_spacing = 12,
            row_spacing = 18,
            vexpand = true,
            hexpand = true
        };
        child = content_area;

        var reset = add_button (_("Reset to Default"));

        reset.clicked.connect (on_click_reset);
    }

    protected bool if_show_pane (string[] schemas) {
        foreach (var schema in schemas) {
            if (schema_exists (schema)) {
                return true;
            }
        }

        return false;
    }

    protected bool schema_exists (string schema) {
        return (SettingsSchemaSource.get_default ().lookup (schema, true) != null);
    }

    private void on_click_reset () {
        var reset_confirm_dialog = new Granite.MessageDialog.with_image_from_icon_name (
            _("Are you sure you want to reset personalization?"),
            _("All settings in this pane will be restored to the factory defaults. This action can't be undone."),
            "dialog-warning", Gtk.ButtonsType.CANCEL
        ) {
            modal = true,
            transient_for = (Gtk.Window) get_root ()
        };
        var reset_button = reset_confirm_dialog.add_button (_("Reset"), Gtk.ResponseType.ACCEPT);
        reset_button.add_css_class (Granite.STYLE_CLASS_DESTRUCTIVE_ACTION);
        reset_confirm_dialog.response.connect ((response_id) => {
            if (response_id != Gtk.ResponseType.ACCEPT) {
                reset_confirm_dialog.destroy ();
                return;
            }

            do_reset ();
            reset_confirm_dialog.destroy ();
            restored ();
        });
        reset_confirm_dialog.show ();
    }

    protected Gtk.ComboBoxText combobox_text_new (Gee.HashMap<string, string> items) {
        var combobox_text = new Gtk.ComboBoxText () {
            valign = Gtk.Align.CENTER
        };

        foreach (var item in items.entries) {
            combobox_text.append (item.key, item.value);
        }

        combobox_text.set_size_request (180, 0);
        return combobox_text;
    }

    protected Gtk.ComboBoxText combobox_text_new_from_list (Gee.List<string>? items) {
        var combobox_text = new Gtk.ComboBoxText () {
            valign = Gtk.Align.CENTER
        };

        if (items != null) {
            for (int i = 0; i < items.size; i++) {
                combobox_text.append (items.get (i), items.get (i));
            }
        }

        combobox_text.set_size_request (180, 0);
        return combobox_text;
    }

    /**
     * Convert string representation of font to Pango.FontDescription.
     *
     * Note: String format is described at https://docs.gtk.org/Pango/type_func.FontDescription.from_string.html
     * @see SettingsBindGetMappingShared
     */
    protected static bool font_button_bind_get (Value value, Variant variant, void* user_data) {
        string font = variant.get_string ();
        var desc = Pango.FontDescription.from_string (font);
        value.set_boxed (desc);
        return true;
    }

    /**
     * Convert Pango.FontDescription to string representation of font.
     *
     * Note: String format is described at https://docs.gtk.org/Pango/type_func.FontDescription.from_string.html
     * @see SettingsBindSetMappingShared
     */
    protected static Variant font_button_bind_set (Value value, VariantType expected_type, void* user_data) {
        var desc = (Pango.FontDescription) value.get_boxed ();
        string font = desc.to_string ();
        return new Variant.string (font);
    }
}
