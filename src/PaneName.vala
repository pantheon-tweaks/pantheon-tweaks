/*
 * Copyright (C) Pantheon Tweaks Developers, 2020
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

public enum PantheonTweaks.PaneName {
    APPEARANCE,
    FONTS,
    ANIMATIONS,
    MISC,
    FILES,
    DOCK,
    TERMINAL,
    AUDIENCE;

    public string get_id () {
        switch (this) {
            case PaneName.APPEARANCE:
                return "appearance";
            case PaneName.FONTS:
                return "fonts";
            case PaneName.ANIMATIONS:
                return "animations";
            case PaneName.MISC:
                return "miscellaneous";
            case PaneName.FILES:
                return "files";
            case PaneName.DOCK:
                return "dock";
            case PaneName.TERMINAL:
                return "terminal";
            case PaneName.AUDIENCE:
                return "audience";
            default:
                return "";
        }
    }

    public string get_display_name () {
        switch (this) {
            case PaneName.APPEARANCE:
                return _("Appearance");
            case PaneName.FONTS:
                return _("Fonts");
            case PaneName.ANIMATIONS:
                return _("Animations");
            case PaneName.MISC:
                return _("Miscellaneous");
            case PaneName.FILES:
                return _("Files");
            case PaneName.DOCK:
                return _("Dock");
            case PaneName.TERMINAL:
                return _("Terminal");
            case PaneName.AUDIENCE:
                return _("Videos");
            default:
                return "";
        }
    }

    public string get_icon_name () {
        switch (this) {
            case PaneName.APPEARANCE:
                return "applications-graphics";
            case PaneName.FONTS:
                return "applications-fonts";
            case PaneName.ANIMATIONS:
                return "go-jump";
            case PaneName.MISC:
                return "applications-utilities";
            case PaneName.FILES:
                return "system-file-manager";
            case PaneName.DOCK:
                return "plank";
            case PaneName.TERMINAL:
                return "utilities-terminal";
            case PaneName.AUDIENCE:
                return "multimedia-video-player";
            default:
                return "";
        }
    }

    public string? get_description () {
        switch (this) {
            case PaneName.APPEARANCE:
                return _("Change theme and button layout of windows. Changing theme may cause visibility issue.");
            case PaneName.FONTS:
                return _("Changes fonts used in your system or document by default.");
            case PaneName.ANIMATIONS:
                return _("Adjust length of animations for window management or multitasking.");
            case PaneName.MISC:
                return _("Configure some hidden settings for indicators.");
            case PaneName.FILES:
            case PaneName.DOCK:
            case PaneName.TERMINAL:
            case PaneName.AUDIENCE:
            default:
                return null;
        }
    }
}
