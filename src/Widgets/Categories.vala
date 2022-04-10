/*
 * Copyright (C) Elementary Tweaks Developers, 2014 - 2020
 *               Pantheon Tweaks Developers, 2020 - 2021
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

public class PantheonTweaks.Categories : Gtk.Paned {
    private const string[] PANE_NAME = { "appearance", "fonts", "misc", "files", "terminal" };

    private Gtk.ListBox pane_list;

    construct {
        var appearance_pane = new Panes.AppearancePane ();
        var files_pane = new Panes.FilesPane ();

        var panes = new Gee.ArrayList<Categories.Pane> ();
        panes.add (appearance_pane);
        panes.add (new Panes.FontsPane ());
        panes.add (new Panes.MiscPane ());
        panes.add (files_pane);
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

        pack1 (pane_list, false, false);
        add2 (overlay);

        pane_list.row_selected.connect ((row) => {
            var list_item = ((Categories.Pane.PaneListItem) row);
            stack.visible_child = list_item.pane;
        });

        pane_list.set_header_func ((row, before) => {
            var list_item = ((Categories.Pane.PaneListItem) row);

            if (list_item.pane == appearance_pane) {
                list_item.set_header (new Granite.HeaderLabel (_("General")));
            } else if (list_item.pane == files_pane) {
                list_item.set_header (new Granite.HeaderLabel (_("Applications")));
            }
        });
    }

    public void set_visible_view (string location) {
        int index;
        for (index = 0; index < PANE_NAME.length; index++) {
            if (PANE_NAME[index] == location) {
                break;
            }
        }

        pane_list.select_row (pane_list.get_row_at_index (index));
    }

    public abstract class Pane : Granite.SimpleSettingsPage {
        public signal void restored ();

        protected delegate void Reset ();

        public PaneListItem pane_list_item { get; private set; }

        protected Pane (string title, string icon_name, string? description = null) {
            Object (
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
                            warning (e.message);
                        }
                    }

                    try {
                        GLib.AppInfo.launch_default_for_uri (destination_uri, null);
                    } catch (Error e) {
                        warning (e.message);
                    }
                });
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
    }
}
