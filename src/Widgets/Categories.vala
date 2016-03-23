/*
 * Copyright (C) Elementary Tweaks Developers, 2014 - 2016
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

namespace ElementaryTweaks {
    public class Categories : Gtk.ScrolledWindow {
        private Gtk.Stack stack;
        private Gtk.ListBox list_box;

        public Categories () {

        }

        construct {
            hscrollbar_policy = Gtk.PolicyType.NEVER;
            list_box = new Gtk.ListBox ();
            list_box.expand = true;
            set_size_request (176, 10);
            add (list_box);

            var appearance = new Panes.AppearancePane ();
            list_box.add (appearance);

            //var fonts = new Panes.FontsPane ();
            //list_box.add (fonts);

            list_box.row_activated.connect ((row) => {
                var page = ((Pane) row);
                if (page.added == false) {
                    page.added = true;
                    stack.add (page.pane);
                }

                stack.set_visible_child (page.pane);
            });

            list_box.set_header_func ((row, before) => {
                if (row == appearance) {
                    row.set_header (new Header (_("General")));
                }
            });
        }

        public void set_stack (Gtk.Stack stack) {
            this.stack = stack;
            weak Gtk.ListBoxRow first = list_box.get_row_at_index (0);
            list_box.select_row (first);
            first.activate ();
        }

        public class Pane : Gtk.ListBoxRow {
            public Gtk.Label label;
            Gtk.Image image;
            public bool added = false;
            public Gtk.ScrolledWindow pane { public get; private set; }
            public Gtk.Grid grid { public get; private set; }
            public Widgets.SettingsBox settings_box { public get; private set; }

            public Pane (string label_string, string icon_name) {
                label.label = label_string;
                image.icon_name = icon_name;
            }

            construct {
                var rowgrid = new Gtk.Grid ();
                pane = new Gtk.ScrolledWindow (null, null);
                rowgrid.orientation = Gtk.Orientation.HORIZONTAL;
                rowgrid.column_spacing = 6;
                rowgrid.margin = 3;
                rowgrid.margin_start = 12;
                add (rowgrid);

                label = new Gtk.Label (null);
                label.hexpand = true;
                label.halign = Gtk.Align.START;

                image = new Gtk.Image ();
                image.icon_size = Gtk.IconSize.DND;

                rowgrid.add (image);
                rowgrid.add (label);

                grid = new Gtk.Grid ();
                grid.orientation = Gtk.Orientation.VERTICAL;
                grid.margin = 12;
                grid.margin_top = 24;
                grid.row_spacing = 12;
                grid.column_spacing = 0;
                grid.expand = true;
                grid.show ();
                pane.add (grid);
                pane.show ();
            }
        }

        public class Header : Gtk.Label {
            public Header (string header) {
                label = "%s".printf (GLib.Markup.escape_text (header));
                show_all ();
            }

            construct {
                halign = Gtk.Align.START;
                get_style_context ().add_class ("h4");
            }
        }
    }
}
