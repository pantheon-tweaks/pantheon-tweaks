/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: elementary Tweaks Developers, 2016-2020
 *                         Pantheon Tweaks Developers, 2020-2025
 */

namespace PantheonTweaks.SettingsUtil {
    public const string INTERFACE_SCHEMA = "org.gnome.desktop.interface";
    public const string SOUND_SCHEMA = "org.gnome.desktop.sound";
    public const string GNOME_WM_SCHEMA = "org.gnome.desktop.wm.preferences";

    public const string FILES_SCHEMA = "io.elementary.files.preferences";

    public const string INPUT_SCHEMA = "org.gnome.desktop.input-sources";
    public const string KEYBINDING_SCHEMA = "io.elementary.desktop.wm.keybindings";

    public const string PANEL_SOUND_SCHEMA = "io.elementary.desktop.wingpanel.sound";

    public const string TERMINAL_SCHEMA = "io.elementary.terminal.settings";

    public const string XSETTINGS_SCHEMA = "org.gnome.settings-daemon.plugins.xsettings";

    public static bool schema_exists (string schema) {
        return (SettingsSchemaSource.get_default ().lookup (schema, true) != null);
    }

    namespace Binding {
        // string value in Settings → Gtk.FontDialogButton.font_desc
        public static bool to_fontbutton_fontdesc (Value font_desc, Variant settings_value, void* user_data) {
            string font = settings_value.get_string ();
            var desc = Pango.FontDescription.from_string (font);
            font_desc.set_boxed (desc);
            return true;
        }

        // Gtk.FontDialogButton.font_desc → string value in Settings
        public static Variant from_fontbutton_fontdesc (Value font_desc, VariantType expected_type, void* user_data) {
            var desc = (Pango.FontDescription) font_desc.get_boxed ();
            string font = desc.to_string ();
            return new Variant.string (font);
        }

        // string value in Settings → Gtk.DropDown.selected
        public static bool to_dropdown_selected (Value selected, Variant settings_value, void* str_list) {
            string selected_id = settings_value.get_string ();
            var list = (Gtk.StringList) str_list;

            uint selected_pos = StringListUtil.find (list, selected_id);
            if (selected_pos == uint.MAX) {
                selected.set_uint (Gtk.INVALID_LIST_POSITION);
                // Never returns false because it causes intentional crash
                return true;
            }

            selected.set_uint (selected_pos);
            return true;
        }

        // Gtk.DropDown.selected → string value in Settings
        public static Variant from_dropdown_selected (Value selected, VariantType expected_type, void* str_list) {
            uint selected_pos = selected.get_uint ();
            var list = (Gtk.StringList) str_list;

            unowned string? selected_id = list.get_string (selected_pos);
            if (selected_id == null) {
                return new Variant.string ("");
            }

            return new Variant.string (selected_id);
        }

        // string value in Settings → Gtk.DropDown.selected
        public static bool to_dropdownid_selected (Value selected, Variant settings_value, void* str_id_list) {
            string selected_id = settings_value.get_string ();
            var list = (ListStore) str_id_list;

            uint selected_pos = StringIdListUtil.find (list, selected_id);
            if (selected_pos == Gtk.INVALID_LIST_POSITION) {
                selected.set_uint (selected_pos);
                // Never returns false because it causes intentional crash
                return true;
            }

            selected.set_uint (selected_pos);
            return true;
        }

        // Gtk.DropDown.selected → string value in Settings
        public static Variant from_dropdownid_selected (Value selected, VariantType expected_type, void* str_id_list) {
            uint selected_pos = selected.get_uint ();
            var list = (ListStore) str_id_list;

            string? selected_id = StringIdListUtil.get_id (list, selected_pos);
            if (selected_id == null) {
                return new Variant.string ("");
            }

            return new Variant.string (selected_id);
        }
    }
}
