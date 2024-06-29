/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: elementary Tweaks Developers, 2014-2020
 *                         Pantheon Tweaks Developers, 2020-2024
 */

public class PantheonTweaks.Categories : Gtk.Box {
    private Gee.ArrayList<Categories.Pane> panes;
    private Gtk.ListBox pane_list;

    construct {
        panes = new Gee.ArrayList<Categories.Pane> ();
        panes.add (new Panes.AppearancePane ());
        panes.add (new Panes.FontsPane ());
        panes.add (new Panes.MiscPane ());
        panes.add (new Panes.FilesPane ());
        panes.add (new Panes.TerminalPane ());

        // Left: Add PaneListItems to PaneList
        pane_list = new Gtk.ListBox ();
        pane_list.set_size_request (176, 10);

        // Right: Add Pane itself to Stack
        var stack = new Gtk.Stack ();

        var toast = new Granite.Toast (_("Reset settings successfully"));

        var overlay = new Gtk.Overlay () {
            child = stack
        };
        overlay.add_overlay (toast);

        foreach (var pane in panes) {
            pane_list.append (pane.pane_list_item);
            stack.add_child (pane);
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

        pane_list.row_selected.connect ((row) => {
            var list_item = ((Categories.Pane.PaneListItem) row);
            stack.visible_child = list_item.pane;
        });

        pane_list.set_header_func ((row, before) => {
            var list_item = ((Categories.Pane.PaneListItem) row);

            switch (list_item.pane.name) {
                case "appearance":
                    list_item.set_header (new Granite.HeaderLabel (_("General")));
                    break;
                case "files":
                    list_item.set_header (new Granite.HeaderLabel (_("Applications")));
                    break;
                default:
                    break;
            }
        });
    }

    public void set_visible_view (string location) {
        panes.foreach ((pane) => {
            if (pane.name == location) {
                pane_list.select_row (pane.pane_list_item);
                return false;
            }

            return true;
        });
    }

    public abstract class Pane : Switchboard.SettingsPage {
        public signal void restored ();

        protected delegate void Reset ();

        public PaneListItem pane_list_item { get; private set; }
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
            pane_list_item = new PaneListItem (this);

            content_area = new Gtk.Grid () {
                column_spacing = 12,
                row_spacing = 12,
                vexpand = true,
                hexpand = true
            };
            child = content_area;
        }

        protected bool if_show_pane (string[] schemas) {
            foreach (var schema in schemas) {
                if (schema_exists (schema)) {
                    return true;
                }
            }

            pane_list_item.visible = false;
            return false;
        }

        protected bool schema_exists (string schema) {
            return (SettingsSchemaSource.get_default ().lookup (schema, true) != null);
        }

        protected void on_click_reset (owned Reset reset_func) {
            var reset = add_button (_("Reset to default"));

            reset.clicked.connect (() => {
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
                    if (response_id == Gtk.ResponseType.ACCEPT) {
                        reset_func ();
                        restored ();
                    }

                    reset_confirm_dialog.destroy ();
                });
                reset_confirm_dialog.show ();
            });
        }

        protected class PaneListItem : Gtk.ListBoxRow {
            public unowned Pane pane { get; construct; }

            public PaneListItem (Pane pane) {
                Object (
                    pane: pane
                );
            }

            construct {
                var label = new Gtk.Label (pane.title);
                label.hexpand = true;
                label.halign = Gtk.Align.START;

                var image = new Gtk.Image.from_gicon (pane.icon) {
                    icon_size = Gtk.IconSize.LARGE
                };

                var row_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 6);
                row_box.margin_top = 3;
                row_box.margin_bottom = 3;
                row_box.margin_start = 12;
                row_box.margin_end = 3;
                row_box.append (image);
                row_box.append (label);

                child = row_box;
            }
        }

        protected Gtk.SpinButton spin_button_new (Gtk.Adjustment adjustment) {
            var spin_button = new Gtk.SpinButton (adjustment, 1, 0);
            spin_button.set_size_request (150, 0);
            return spin_button;
        }

        protected Gtk.Switch switch_new () {
            var switch = new Gtk.Switch () {
                halign = Gtk.Align.START
            };
            return switch;
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

        protected Gtk.Label summary_label_new (string text) {
            var label = new Gtk.Label (text) {
                halign = Gtk.Align.END
            };
            return label;
        }

        protected Gtk.Label dim_label_new (string text) {
            var label = new Gtk.Label (text) {
                max_width_chars = 60,
                margin_bottom = 18,
                wrap = true,
                xalign = 0
            };
            label.add_css_class (Granite.STYLE_CLASS_DIM_LABEL);
            return label;
        }

        protected Gtk.FontButton font_button_new () {
            var font_button = new Gtk.FontButton () {
                halign = Gtk.Align.START,
                use_font = true
            };
            return font_button;
        }
    }
}
