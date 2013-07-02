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

class LLabel : Gtk.Label
{
    public LLabel (string label)
    {
        this.set_halign (Gtk.Align.START);
        this.label = label;
    }
    public LLabel.indent (string label) 
    {
        this (label);
        this.use_markup = true;
        this.margin_left = 12;
    }
    public LLabel.markup (string label) 
    {
        this (label);
        this.use_markup = true;
    }
    public LLabel.right (string label) 
    {
        this.set_halign (Gtk.Align.END);
        this.label = label;
    }
    public LLabel.right_with_markup (string label)
    {
        this.set_halign (Gtk.Align.END);
        this.use_markup = true;
        this.label = label;
    }
    public LLabel.left (string label) 
    {
        this.set_halign (Gtk.Align.START);
        this.label = label;
    }
    public LLabel.left_with_markup (string label)
    {
        this.set_halign (Gtk.Align.START);
        this.use_markup = true;
        this.label = label;
    }
    public LLabel.center (string label) 
    {
        this.set_halign (Gtk.Align.CENTER);
        this.label = label;
    }
    public LLabel.center_with_markup (string label)
    {
        this.set_halign (Gtk.Align.CENTER);
        this.use_markup = true;
        this.label = label;
    }
}
