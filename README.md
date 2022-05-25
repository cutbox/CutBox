<p align="center">
  <img src="CutBox/CutBox/GraphicAssets/cutbox-icon.png">
</p>

<p align="center">
  <a href="https://gitter.im/CutBox/Lobby" title="Chat about CutBox"/><img src="https://badges.gitter.im/cutbox/CutBox.png"/></a>
  &nbsp;
  <a href="https://www.codacy.com/gh/cutbox/CutBox/dashboard?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=cutbox/CutBox&amp;utm_campaign=Badge_Grade"><img src="https://app.codacy.com/project/badge/Grade/ae11b1b41bbe432c88c02ba9a50d5f2d"/></a>
</p>



<div align="center">
  <h1>CutBox</h1>
  <p>it'll make your pasteboard awesome!</p>
</div>

# IMPORTANT

CutBox is designed as OpenSource and you are encouraged to [Compile yourself](#compilation-setup--tooling)

## About CutBox

CutBox keeps your pasteboard cut/copy history and lets you paste
anything back to your current app by searching for items.

Inspired by [JumpCut](https://github.com/snark/jumpcut) & [Flycut](https://github.com/TermiT/Flycut)

![](CutBox/CutBox/GraphicAssets/cutbox-search-bar.png)

![](CutBox/CutBox/GraphicAssets/cutbox-search-fuzzy.png)

As well as copy / paste history you can:

- Make items favorite
- Select and paste multiple items joined as a single piece of text.

Anything else?

- You can send your pasted text through [Javascript functions](https://github.com/cutbox/CutBox/wiki/Javascript-support)

_NOTE: Javascript pre-processing will be removed in a future release. (protest if you use it!) _

# Download / install...

Get the current release:

https://github.com/cutbox/CutBox/releases/download/1.4.12/CutBox.dmg

You can also compile yourself... [Compile instructions](#compilation-setup--tooling)

# Enable Clipboard pasting.

Before CutBox can paste for you, enable it to control the keyboard.

Go to **System Preferences -> Security & Privacy -> Privacy -> Accessibility**

Unlock and add CutBox to the list of apps (and check the box next to it). 



## Using CutBox

Any text you copy on MacOS is saved to CutBox's history.

![](CutBox/CutBox/GraphicAssets/cutbox-menu.png)

CutBox Search is activated using a global hotkey:

<kbd>**Cmd**</kbd> + <kbd>**Shift**</kbd> + <kbd>**V**</kbd>

(This can be customized in preferences.)

### Searching and pasting

![](CutBox/CutBox/GraphicAssets/cutbox-search-fuzzy.png)

With the CutBox window open, search for anything you copied.

Press <kbd>**Enter**</kbd> and the selected item will paste into your
current app.

To exit just press <kbd>**Esc**</kbd>.

![](CutBox/CutBox/GraphicAssets/cutbox-search-mode.gif)

Press <kbd>Cmd</kbd> + <kbd>s</kbd> to toggle through search modes,
fuzzy match, regexp/i or regexp.

# Would you like to know more?

[More information is in the wiki](https://github.com/cutbox/CutBox/wiki)

# Bugs...

If you find a bug, [click here to tell me what happened.](https://github.com/cutbox/CutBox/issues/new?template=ISSUE_TEMPLATE.md)

# Developers

- Pull requests must have test cover, existing tests should not break.
- Open an issue if tests are already failing, so I know I need to fix them.
- Code must pass the quality checks as used by Codacy.

### Clone and setup dependencies

    git clone --recurse-submodules git@github.com:CutBox/CutBox

### Compilation setup / tooling

  `bin/setup`

To build **CutBox.app**:

  `bin/build`

# Troubleshooting

There's a Gitter channel if you have problems getting up and running (https://gitter.im/CutBox)

# Licence

> CutBox is free software: you can redistribute it and/or modify
> it under the terms of the GNU General Public License as published by
> the Free Software Foundation, either version 3 of the License, or
> (at your option) any later version.
>
> CutBox is distributed in the hope that it will be useful,
> but WITHOUT ANY WARRANTY; without even the implied warranty of
> MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> GNU General Public License for more details.
>
> You should have received a copy of the GNU General Public License
> along with this program.  If not, see <http://www.gnu.org/licenses/>.
