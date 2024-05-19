/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: elementary Tweaks Developers, 2014-2020
 *                         Pantheon Tweaks Developers, 2020-2024
 */

public class PantheonTweaks.Categories : Gtk.Paned {
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

        var toast = new Granite.Widgets.Toast (_("Reset settings successfully"));

        var overlay = new Gtk.Overlay ();
        overlay.add (stack);
        overlay.add_overlay (toast);

        foreach (var pane in panes) {
            pane_list.add (pane.pane_list_item);
            stack.add (pane);
            pane.restored.connect (() => {
                toast.send_notification ();
            });
        }

        add1 (pane_list);
        add2 (overlay);

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

    public abstract class Pane : Granite.SimpleSettingsPage {
        public signal void restored ();

        protected delegate void Reset ();

        public PaneListItem pane_list_item { get; private set; }

        protected Pane (string name, string title, string icon_name, string? description = null) {
            Object (
                name: name,
                title: title,
                icon_name: icon_name,
                description: description
            );
        }

        construct {
            pane_list_item = new PaneListItem (this);

            content_area.expand = true;
            content_area.margin_start = 60;
        }

        protected bool if_show_pane (string[] schemas) {
            foreach (var schema in schemas) {
                if (schema_exists (schema)) {
                    return true;
                }
            }

            pane_list_item.no_show_all = true;
            return false;
        }

        protected bool schema_exists (string schema) {
            return (SettingsSchemaSource.get_default ().lookup (schema, true) != null);
        }

        protected void on_click_reset (owned Reset reset_func) {
            var reset = new Gtk.LinkButton (_("Reset to default"));
            reset.can_focus = false;

            reset.activate_link.connect (() => {
                var reset_confirm_dialog = new Granite.MessageDialog.with_image_from_icon_name (
                    _("Are you sure you want to reset personalization?"),
                    _("All settings in this pane will be restored to the factory defaults. This action can't be undone."),
                    "dialog-warning", Gtk.ButtonsType.CANCEL
                ) {
                    modal = true,
                    transient_for = (Gtk.Window) get_toplevel ()
                };
                var reset_button = reset_confirm_dialog.add_button (_("Reset"), Gtk.ResponseType.ACCEPT);
                reset_button.get_style_context ().add_class (Gtk.STYLE_CLASS_DESTRUCTIVE_ACTION);
                reset_confirm_dialog.response.connect ((response_id) => {
                    if (response_id == Gtk.ResponseType.ACCEPT) {
                        reset_func ();
                        restored ();
                    }

                    reset_confirm_dialog.destroy ();
                });
                reset_confirm_dialog.show ();

                return true;
            });

            action_area.add (reset);
            show_all ();
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

                var image = new Gtk.Image.from_icon_name (pane.icon_name, Gtk.IconSize.DND);

                var rowgrid = new Gtk.Grid ();
                rowgrid.orientation = Gtk.Orientation.HORIZONTAL;
                rowgrid.column_spacing = 6;
                rowgrid.margin = 3;
                rowgrid.margin_start = 12;
                rowgrid.add (image);
                rowgrid.add (label);

                add (rowgrid);
            }
        }

        protected class SpinButton : Gtk.SpinButton {
            public SpinButton (Gtk.Adjustment adjustment) {
                Object (adjustment: adjustment);
            }

            construct {
                climb_rate = 1;
                digits = 0;
                set_size_request (150, 0);
            }
        }

        protected class Switch : Gtk.Switch {
            construct {
                halign = Gtk.Align.START;
            }
        }

        protected class ComboBoxText : Gtk.ComboBoxText {
            public ComboBoxText (Gee.HashMap<string, string> items) {
                foreach (var item in items.entries) {
                    append (item.key, item.value);
                }
            }

            public ComboBoxText.from_list (Gee.List<string> items) {
                for (int i = 0; i < items.size; i++) {
                    append (items.get (i), items.get (i));
                }
            }

            construct {
                set_size_request (180, 0);
                halign = Gtk.Align.START;
            }
        }

        protected class DestinationButton : Gtk.Button {
            public string destination_uri { private get; construct; }

            public DestinationButton (string destination) {
                Object (
                    image: new Gtk.Image.from_icon_name ("folder-open", Gtk.IconSize.BUTTON),
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
                    transient_for = (Gtk.Window) get_toplevel ()
                };
                error_dialog.show_error_details (error_message);
                error_dialog.response.connect ((response_id) => {
                    error_dialog.destroy ();
                });
                error_dialog.show ();
            }
        }

        protected class SummaryLabel : Gtk.Label {
            public SummaryLabel (string label) {
                Object (label: label);
            }

            construct {
                halign = Gtk.Align.END;
            }
        }

        protected class DimLabel : Gtk.Label {
            public DimLabel (string label) {
                Object (label: label);
            }

            construct {
                max_width_chars = 60;
                margin_bottom = 18;
                wrap = true;
                xalign = 0;
                get_style_context ().add_class (Gtk.STYLE_CLASS_DIM_LABEL);
            }
        }

        protected class FontButton : Gtk.FontButton {
            construct {
                halign = Gtk.Align.START;
                use_font = true;
            }
        }
    }
}
