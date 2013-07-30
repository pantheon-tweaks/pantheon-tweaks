//  
//  Copyright (C) 2013 Michael Langfermann, Tom Beckmann
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
//

class SidebarItem : Granite.Widgets.SourceList.Item
{
        public int index { get; set; }
 
        public SidebarItem (int index, string title, string icon)
        {
            Object (index : index, name : title, icon : new ThemedIcon (icon));
        }
}
 
public class TweaksPlug : Pantheon.Switchboard.Plug
{
    Gtk.Notebook notebook;
    Granite.Widgets.SourceList sidebar;

    public TweaksPlug ()
    {
        var paned = new Granite.Widgets.ThinPaned ();

        sidebar = new Granite.Widgets.SourceList ();
        sidebar.width_request = 120;
        sidebar.item_selected.connect (selected);
        sidebar.get_style_context ().add_class ("sidebar");

        /* Notebook */
        notebook = new Gtk.Notebook ();
        notebook.set_margin_top (0);
        notebook.show_tabs = false;
        notebook.get_style_context ().add_class ("content-view");

        /* Sidebar Categories */
        var cat_general = new Granite.Widgets.SourceList.ExpandableItem (_("General"));
        var cat_applications = new Granite.Widgets.SourceList.ExpandableItem (_("Applications"));
        sidebar.root.add (cat_general);
        sidebar.root.add (cat_applications);


        /**** General Category ****/

        /* Appearances Tab */
        sidebar.selected = add_page (new AppearanceGrid (), _("Appearance"), "preferences-desktop-wallpaper", cat_general);

        /* Font Tab*/
        add_page (new FontsGrid (), _("Fonts"), "font-x-generic", cat_general);

        /* Animations Tab */
        add_page (new AnimationsGrid (), _("Animations"), "preferences-tweaks-anim", cat_general);

        /* Shadows Tab*/
        add_page (new ShadowsGrid (), _("Shadows"), "preferences-tweaks-shadows", cat_general);

        /* Misc Tab*/
        add_page (new MiscGrid (), _("Miscellaneous"), "preferences-system-session", cat_general);


        /**** Applications Category ****/

        /* Dock Tab*/
        add_page (new PlankGrid (), _("Plank"), "plank", cat_applications);

        /* Files Tab*/
        add_page (new FilesGrid (), _("Files"), "system-file-manager", cat_applications);

        /* Search Indicator Tab*/
        if (schema_exists("net.launchpad.synapse-project.indicator"))
            add_page (new SynapseGrid (), _("Search Indicator"), "system-search", cat_applications);

        /* Slingshot Tab*/
        add_page (new SlingshotGrid (), _("Slingshot"), "preferences-tweaks-slingshot", cat_applications);

        /* Terminal Tab*/
        add_page (new TerminalGrid (), _("Terminal"), "utilities-terminal", cat_applications);

        /* Wingpanel Tab*/
        if (schema_exists("org.pantheon.desktop.wingpanel-slim"))
            add_page (new WingpanelslimGrid (), _("Wingpanel Slim"), "wingpanel", cat_applications);

        paned.pack1 (sidebar, false, false);
        paned.pack2 (notebook, false, true);
        sidebar.root.expand_all ();
        add (paned);
    }

        SidebarItem add_page (Gtk.Widget page, string title, string icon, Granite.Widgets.SourceList.ExpandableItem parent) {
            var index = notebook.append_page (page, new Gtk.Label (title));
            var item = new SidebarItem (index, title, icon);
            parent.add (item);
            return item;
        }

        void selected (Granite.Widgets.SourceList.Item? item) {
            if (item != null)
                notebook.page = (item as SidebarItem).index;
        }

        bool schema_exists(string schema) {
            return schema in Settings.list_schemas ();
        }
}
 
public static int main (string[] args) {
    Gtk.init (ref args);

    var plug = new TweaksPlug ();
    plug.register ("Tweaks");
    plug.show_all ();

    Gtk.main ();

    return 0;
}
