/*
 * Copyright (C) Elementary Tweaks Developers, 2014
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
 *
 */

namespace ElementaryTweaks {

    /**
     * A Switchboard plugin to tweak the Elementary OS system.
     */
    public class TweaksPlug : Switchboard.Plug {
        private Granite.Widgets.ThinPaned main_view;
        private Granite.Widgets.SourceList sidebar;
        private Gtk.Notebook tweak_content;
        private Gee.HashMap<string, Granite.Widgets.SourceList.ExpandableItem> categories;
        private Gee.HashMap<Granite.Widgets.SourceList.Item, int> page_lookup;

        /**
         * Creates a new Tweak Plug
         */
        public TweaksPlug () {
            // init plugin stuff
            Object (category: Category.PERSONAL,
                    code_name: Build.PLUGCODENAME,
                    display_name: _("Tweaks"),
                    description: _("Tweak elementary OS settings"),
                    icon: "applications-development");

            // make sure that UI is created.
            // TODO: there might be a better way of doing this.
            get_widget();

            // add all the tweaks

            // Appearance Tweaks; make sure to select as default page on open
            sidebar.selected = add_tweak_page (new AppearanceGrid (), _("Appearance"), _("General"), "preferences-desktop-wallpaper");

            // Font Tweaks
            add_tweak_page (new FontsGrid (), _("Fonts"), _("General"), "font-x-generic");

            // Animation Tweaks
            if (schema_exists("org.pantheon.desktop.gala.animations"))
                add_tweak_page (new AnimationsGrid (), _("Animations"), _("General"), "preferences-tweaks-anim");

            // Shadow Tweaks
            if (schema_exists("org.pantheon.desktop.gala.shadows"))
                add_tweak_page (new ShadowsGrid (), _("Shadows"), _("General"), "preferences-tweaks-shadows");

            // Shortcut Tweaks
            add_tweak_page (new ShortcutsGrid (), _("Shortcuts"), _("General"), "preferences-desktop-keyboard");

            // Misc Tweaks
            add_tweak_page (new MiscGrid (), _("Miscellaneous"), _("General"), "preferences-system-session");

            // Plank Tweaks
            if (file_exists("/plank/dock1/settings"))
                add_tweak_page (new PlankGrid (), _("Plank"), _("Applications"), "plank");

            // File browser Tweaks
            if (schema_exists("org.pantheon.files.preferences"))
                add_tweak_page (new FilesGrid (), _("Files"), _("Applications"), "system-file-manager");

            // Synapse Tweaks
            if (schema_exists("net.launchpad.synapse-project.indicator"))
                add_tweak_page (new SynapseGrid (), _("Search Indicator"), _("Applications"), "system-search");

            // Slingshot Tweaks
            if (schema_exists("org.pantheon.desktop.slingshot"))
                add_tweak_page (new SlingshotGrid (), _("Slingshot"), _("Applications"), "preferences-tweaks-slingshot");

            // Cerbere Tweaks
            if (schema_exists("org.pantheon.cerbere"))
                add_tweak_page (new CerbereGrid (), _("Cerbere"), _("Applications"), "preferences-tweaks-cerbere");

            /* Terminal Tab*/
            if (schema_exists("org.pantheon.terminal.settings"))
                add_tweak_page (new TerminalGrid (), _("Terminal"), _("Applications"), "utilities-terminal");

            /* Wingpanel-slim Tab*/
            if (schema_exists("org.pantheon.desktop.wingpanel-slim"))
                add_tweak_page (new WingpanelslimGrid (), _("Wingpanel Slim"), _("Applications"), "wingpanel");

            /* Super-wingpanel Tab*/
            if (schema_exists("org.pantheon.desktop.super-wingpanel"))
                add_tweak_page (new SuperwingpanelGrid (), _("Super Wingpanel"), _("Applications"), "wingpanel");

            // expand all of the tabs
            sidebar.root.expand_all ();
        }

        /**
         * Returns the navigation sidebar, which will control which page that the
         * content_area will render.
         */
        private Gtk.Widget get_sidebar () {
            // create sidebar if not already created
            if (sidebar == null) {
                sidebar = new Granite.Widgets.SourceList ();
                sidebar.width_request = 120;
                sidebar.get_style_context ().add_class ("sidebar");
                sidebar.item_selected.connect (selected);

                categories = new Gee.HashMap<string, Granite.Widgets.SourceList.ExpandableItem> ();
                page_lookup = new Gee.HashMap<Granite.Widgets.SourceList.Item, int> ();
            }

            return sidebar;
        }

        /**
         * Returns the content area that contains all of the UI for selections made
         * in the sidebar.
         */
        private Gtk.Widget get_content_area () {
            // create content area if not already created
            if (tweak_content == null) {
                tweak_content = new Gtk.Notebook ();
                tweak_content.set_margin_top (0);
                tweak_content.show_tabs = false;
                tweak_content.get_style_context ().add_class ("content-view");
                //tweak_content.width_request = 500;

                // TODO: actually load something in here
            }

            return tweak_content;
        }

        /**
         * Returns true if the schema exists.
         */
        bool schema_exists(string schema) {
            return schema in Settings.list_schemas ();
        }

        /**
         * Returns true if the file exists.
         */
        bool file_exists(string dir) {
            var checkfile = File.new_for_path (Environment.get_user_config_dir () + dir);
            return checkfile.query_exists ();
        }

        /**
         * Returns the main Gtk.Widget that contains all of our UI for Switchboard.
         */
        public override Gtk.Widget get_widget () {
            // create main view if not already created
            if (main_view == null) {
                // get the sidebar and the content area
                var navigation_sidebar = get_sidebar ();
                var content_area = get_content_area ();

                // create our main_view; holds side navigation and content area
                main_view = new Granite.Widgets.ThinPaned ();

                // pack the side bar on the left and content on the right
                main_view.pack1 (navigation_sidebar, false, false);
                main_view.pack2 (content_area, true, false);

                // render out the main_view
                main_view.show_all ();
            }

            return main_view;
        }

        /**
         * Add a Gtk.Widget to the content area hooked to navigation in the
         * sidebar.
         */
        public Granite.Widgets.SourceList.Item add_tweak_page (Gtk.Widget page, string title, string category, string? icon = null) {
            // check category to see if it exists, create if doesn't
            if (!categories.has_key (category)) {
                var new_cat = new Granite.Widgets.SourceList.ExpandableItem (category);
                sidebar.root.add (new_cat);
                categories.set (category, new_cat);
            }

            // make sure that the page is visable
            // TODO: does this screw anything up?
            page.show_all ();

            // create navigation sidebar entry and add it to the category
            // TODO: set icon
            var cat = categories.get (category);
            var new_item = new Granite.Widgets.SourceList.Item (title);
            if (icon != null) {
                new_item.icon = new ThemedIcon(icon);
            }
            cat.add (new_item);

            // add widget to tweak_content notebook
            // TODO: this should be a gint, but I don't know how to use it.
            int new_page_index = tweak_content.append_page (page, new Gtk.Label (title));

            // link navigation entry to passed in page
            page_lookup.set (new_item, new_page_index);

            return new_item;
        }

        /**
         * Callback method for sidebar selection
         */
        private void selected (Granite.Widgets.SourceList.Item? item) {
            if (item != null && page_lookup.has_key (item)) {
                tweak_content.page = page_lookup.get (item);
            }
        }

        public override void shown () {
        }

        public override void hidden () {
        }

        public override void search_callback (string location) {
        }

        public override async Gee.TreeMap<string, string> search (string search) {
            return new Gee.TreeMap<string, string> (null, null);
        }
    }
}

public Switchboard.Plug get_plug (Module module) {
    debug ("Activating Tweak plug");
    var plug = new ElementaryTweaks.TweaksPlug ();
    return plug;
}
