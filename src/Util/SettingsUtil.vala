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

    public const string PANEL_SOUND_SCHEMA = "io.elementary.desktop.wingpanel.sound";

    public const string TERMINAL_SCHEMA = "io.elementary.terminal.settings";

    public const string XSETTINGS_SCHEMA = "org.gnome.settings-daemon.plugins.xsettings";

    public static bool schema_exists (string schema) {
        return (SettingsSchemaSource.get_default ().lookup (schema, true) != null);
    }

    namespace Binding {
        /**
         * Convert string representation of font to Pango.FontDescription.
         *
         * Note: String format is described at https://docs.gtk.org/Pango/type_func.FontDescription.from_string.html
         * @see SettingsBindGetMappingShared
         */
        public static bool to_fontbutton_fontdesc (Value value, Variant variant, void* user_data) {
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
        public static Variant from_fontbutton_fontdesc (Value value, VariantType expected_type, void* user_data) {
            var desc = (Pango.FontDescription) value.get_boxed ();
            string font = desc.to_string ();
            return new Variant.string (font);
        }

        public static bool to_dropdown_selected (Value selected, Variant settings_value, void* user_data) {
            string selected_id = settings_value.get_string ();
            var list = (Gtk.StringList) user_data;

            uint selected_pos = StringListUtil.find (list, selected_id);
            if (selected_pos == uint.MAX) {
                selected.set_uint (Gtk.INVALID_LIST_POSITION);
                // Never returns false because it causes intentional crash
                return true;
            }

            selected.set_uint (selected_pos);
            return true;
        }

        public static Variant from_dropdown_selected (Value selected, VariantType value_type, void* user_data) {
            uint selected_pos = selected.get_uint ();
            var list = (Gtk.StringList) user_data;

            unowned string? selected_id = list.get_string (selected_pos);
            if (selected_id == null) {
                return new Variant.string ("");
            }

            return new Variant.string (selected_id);
        }

        public static bool to_dropdownid_selected (Value selected, Variant settings_value, void* user_data) {
            string selected_id = settings_value.get_string ();
            var list = (ListStore) user_data;

            uint selected_pos = StringIdListUtil.find (list, selected_id);
            if (selected_pos == Gtk.INVALID_LIST_POSITION) {
                selected.set_uint (selected_pos);
                // Never returns false because it causes intentional crash
                return true;
            }

            selected.set_uint (selected_pos);
            return true;
        }

        public static Variant from_dropdownid_selected (Value selected, VariantType value_type, void* user_data) {
            uint selected_pos = selected.get_uint ();
            var list = (ListStore) user_data;

            string? selected_id = StringIdListUtil.get_id (list, selected_pos);
            if (selected_id == null) {
                return new Variant.string ("");
            }

            return new Variant.string (selected_id);
        }
    }
}
