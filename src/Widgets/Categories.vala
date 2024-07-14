/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: elementary Tweaks Developers, 2014-2020
 *                         Pantheon Tweaks Developers, 2020-2024
 */

public class PantheonTweaks.Categories : Gtk.Box {
    private Gee.ArrayList<Categories.Pane> panes;

    construct {
        panes = new Gee.ArrayList<Categories.Pane> ();
        panes.add (new Panes.AppearancePane ());
        panes.add (new Panes.FontsPane ());
        panes.add (new Panes.MiscPane ());
        panes.add (new Panes.FilesPane ());
        panes.add (new Panes.TerminalPane ());

        var stack = new Gtk.Stack ();
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
        paned.set_start_child (pane_list);
        paned.set_end_child (overlay);

        append (paned);
    }

    public abstract class Pane : Switchboard.SettingsPage {
        public signal void restored ();

        protected abstract void do_reset ();

        protected Gtk.Grid content_area;

        protected Pane (string name, string title, string icon_name, string? description = null) {
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
                row_spacing = 12,
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
                halign = Gtk.Align.START
            };

            foreach (var item in items.entries) {
                combobox_text.append (item.key, item.value);
            }

            combobox_text.set_size_request (180, 0);
            return combobox_text;
        }

        protected Gtk.ComboBoxText combobox_text_new_from_list (Gee.List<string> items) {
            var combobox_text = new Gtk.ComboBoxText () {
                halign = Gtk.Align.START
            };

            for (int i = 0; i < items.size; i++) {
                combobox_text.append (items.get (i), items.get (i));
            }

            combobox_text.set_size_request (180, 0);
            return combobox_text;
        }

        protected class DestinationButton : Gtk.Button {
            public string destination_uri { private get; construct; }

            public DestinationButton (string destination) {
                Object (
                    icon_name: "folder-open",
                    destination_uri: "file://%s/%s".printf (Environment.get_home_dir (), destination),
                    valign: Gtk.Align.START,
                    tooltip_text: _("Open destination folder")
                );
            }

            construct {
                clicked.connect (() => {
                    var dir = File.new_for_uri (destination_uri);
                    if (!dir.query_exists ()) {
                        try {
                            dir.make_directory_with_parents ();
                        } catch (Error e) {
                            show_folder_action_error (
                                _("Failed to create the destination folder"),
                                _("The destination folder doesn't exist and tried to create new but failed. The following error message might be helpful:"),
                                e.message
                            );

                            return;
                        }
                    }

                    try {
                        GLib.AppInfo.launch_default_for_uri (destination_uri, null);
                    } catch (Error e) {
                        show_folder_action_error (
                            _("Failed to open the destination folder"),
                            _("Tried to open the destination folder but failed. The following error message might be helpful:"),
                            e.message
                        );
                    }
                });
            }

            private void show_folder_action_error (string primary_text, string secondary_text, string error_message) {
                var error_dialog = new Granite.MessageDialog.with_image_from_icon_name (
                    primary_text, secondary_text, "dialog-error", Gtk.ButtonsType.CLOSE
                ) {
                    modal = true,
                    transient_for = (Gtk.Window) get_root ()
                };
                error_dialog.show_error_details (error_message);
                error_dialog.response.connect ((response_id) => {
                    error_dialog.destroy ();
                });
                error_dialog.show ();
            }
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
}
