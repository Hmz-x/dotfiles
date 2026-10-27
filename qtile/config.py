# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

import os
import random
import subprocess

from libqtile import bar, hook, layout, qtile, widget
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy

# --- Programs ---------------------------------------------------------------
mod = "mod4"
terminal = "kitty"
browser = "librewolf"
filemanager = "dolphin"
prg_launcher = "rofi -show run"

# --- Colors -----------------------------------------------------------------
pink = "#fdcaff"
purple = "#d11aff"
yellow = "#ffef8a"

# --- Paths ------------------------------------------------------------------
wallpaper_dir = os.path.expanduser("~/Wallpapers")
lock_image = os.path.expanduser("~/Documents/pics/wallpaper/lofty_gooned_out.png")
image_exts = (".png", ".jpg", ".jpeg")

is_laptop = os.path.exists("/proc/acpi/button/lid")


def pick_wallpaper(root):
    """Random image from root and all its subfolders; None if there are none."""
    images = [
        os.path.join(dirpath, name)
        for dirpath, _, filenames in os.walk(root)
        for name in filenames
        if name.lower().endswith(image_exts)
    ]
    return random.choice(images) if images else None


@hook.subscribe.startup_once
def autostart():
    subprocess.run([os.path.expanduser("~/.config/qtile/autostart.sh")])


# --- Keys -------------------------------------------------------------------
keys = [
    # Focus
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "space", lazy.layout.next(), desc="Move focus to next window"),

    # Move windows
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(), desc="Move window right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),

    # Resize windows
    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window left"),
    Key([mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window right"),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod, "control"], "n", lazy.layout.normalize(), desc="Reset window sizes"),
    Key([mod, "control"], "Return", lazy.layout.toggle_split(), desc="Toggle split/unsplit stack"),

    # Launchers
    Key([mod, "shift"], "Return", lazy.spawn(terminal), desc="Terminal"),
    Key([mod, "shift"], "f", lazy.spawn(filemanager), desc="File manager"),
    Key([mod, "shift"], "w", lazy.spawn(browser), desc="Browser"),
    Key([mod, "shift"], "e", lazy.spawn("firefox"), desc="Firefox"),
    Key([mod, "shift"], "Space", lazy.spawn(prg_launcher), desc="Program launcher"),
    Key([mod, "shift"], "b", lazy.spawn("blueman-manager"), desc="Bluetooth manager"),
    Key([mod, "shift"], "p", lazy.spawn("pavucontrol"), desc="pavucontrol"),
    Key([mod, "shift"], "m", lazy.spawn("rofimoji"), desc="rofimoji"),
    Key([mod, "shift"], "l", lazy.spawn("pick_pass.sh"), desc="pick_pass.sh"),
    Key([mod, "shift"], "g", lazy.spawn("grim"), desc="Screenshot"),

    # Audio
    Key([], "XF86AudioLowerVolume", lazy.spawn("pamixer --decrease 10"), desc="Lower volume"),
    Key([], "XF86AudioRaiseVolume", lazy.spawn("pamixer_increase.sh"), desc="Raise volume"),
    Key([], "XF86AudioMute", lazy.spawn("pamixer --toggle-mute"), desc="Toggle mute"),

    # Brightness
    Key([], "XF86MonBrightnessDown", lazy.spawn("brightnessctl set 5%-"), desc="Brightness down"),
    Key([], "XF86MonBrightnessUp", lazy.spawn("brightnessctl set +5%"), desc="Brightness up"),

    # Windows & layouts
    Key([mod], "Tab", lazy.next_layout(), desc="Next layout"),
    Key([mod], "F4", lazy.window.kill(), desc="Kill focused window"),
    Key([mod], "f", lazy.window.toggle_fullscreen(), desc="Toggle fullscreen"),
    Key([mod], "t", lazy.window.toggle_floating(), desc="Toggle floating"),

    # Groups
    Key([mod], "m", lazy.screen.next_group(), desc="Next group"),
    Key([mod], "n", lazy.screen.prev_group(), desc="Previous group"),

    # Session
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Quit qtile"),
    Key(
        [mod, "control"],
        "s",
        lazy.spawn(
            f"swaylock --daemonize -s tile -i {lock_image} "
            "--clock --indicator --inside-color '#CD14EC'"
        ),
        desc="Lock screen",
    ),
    Key([mod], "r", lazy.spawncmd(), desc="Run prompt"),

    # Power
    Key([mod, "control"], "F4", lazy.spawn("shutdown now"), desc="Shut down"),
    Key([mod, "control", "shift"], "F4", lazy.spawn("sudo reboot now"), desc="Reboot"),
]

# VT switching (Wayland only; checked at keypress since config loads before qtile starts)
for vt in range(1, 8):
    keys.append(
        Key(
            ["control", "mod1"],
            f"f{vt}",
            lazy.core.change_vt(vt).when(func=lambda: qtile.core.name == "wayland"),
            desc=f"Switch to VT{vt}",
        )
    )

# --- Groups -----------------------------------------------------------------
groups = [Group(i) for i in "123456789"]

for i in groups:
    keys.extend(
        [
            Key([mod], i.name, lazy.group[i.name].toscreen(),
                desc=f"Switch to group {i.name}"),
            Key([mod, "shift"], i.name, lazy.window.togroup(i.name, switch_group=True),
                desc=f"Move window to group {i.name} and follow"),
        ]
    )

# --- Layouts ----------------------------------------------------------------
layouts = [
    layout.Columns(
        border_focus=pink,
        border_normal=yellow,
        border_width=16,
        margin=4,
        single_border_width=8,
        margin_on_single=0,
        border_on_single=True,
    ),
    layout.Max(border_focus=pink, border_normal=yellow, border_width=8),
    layout.TreeTab(active_fg=purple, border_width=8, font="Drafting* Mono", fontsize=12),
]

widget_defaults = dict(
    font="Drafting* Mono",
    fontsize=18,
    padding=6,
)
extension_defaults = widget_defaults.copy()

# --- Screens ----------------------------------------------------------------
screens = [
    Screen(
        wallpaper=pick_wallpaper(wallpaper_dir),
        wallpaper_mode="stretch",
        bottom=bar.Bar(
            [
                widget.CurrentLayout(),
                widget.GroupBox(),
                widget.WindowName(),
                widget.Chord(
                    chords_colors={"launch": ("#ff0000", "#ffffff")},
                    name_transform=lambda name: name.upper(),
                ),
                widget.CPU(),
                widget.TextBox("REAL LINUX FUCKIN SOLDIER", name="default", foreground=purple, font="mono"),
                widget.GenPollCommand(cmd="mullvad status | head -n 1 | cut -d ' ' -f 1", shell=True),
                widget.Clock(format="%d/%m/%y %a %I:%M %p"),
                widget.Battery(charge_char="+", discharge_char="-", format="{char}{percent: 2.0%}")
                if is_laptop
                else widget.TextBox("", name="empty"),
            ],
            24,
        ),
    ),
]

# --- Mouse ------------------------------------------------------------------
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

# --- Misc -------------------------------------------------------------------
dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
floats_kept_above = True
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG passphrase prompt
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True
auto_minimize = True
wl_input_rules = None

# Java UI toolkits misbehave unless the WM claims to be on their whitelist.
wmname = "LG3D"
