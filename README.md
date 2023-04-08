<p align="center">
  <img src="https://github.com/cutbox/CutBox/raw/master/CutBox/CutBox/GraphicAssets/cutbox-icon.png">
</p>

<p align="center">
  <a href="https://gitter.im/CutBox/Lobby" title="Chat about CutBox"/><img src="https://badges.gitter.im/cutbox/CutBox.png"/></a>&nbsp;<a href="https://www.codacy.com/gh/cutbox/CutBox/dashboard?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=cutbox/CutBox&amp;utm_campaign=Badge_Grade"><img src="https://app.codacy.com/project/badge/Grade/ae11b1b41bbe432c88c02ba9a50d5f2d"/></a>&nbsp;<a href="https://github.com/cutbox/CutBox/actions/workflows/xcode-build.yml"><img src="https://github.com/cutbox/CutBox/actions/workflows/xcode-build.yml/badge.svg" /></a>
</p>
<div align="center">
    <h1>CutBox</h1>
  <p>Text Clipboard Manager for MacOS</p>

  <a href="https://github.com/cutbox/CutBox/releases/latest"><img alt="GitHub release (latest SemVer)" src="https://img.shields.io/github/v/release/cutbox/cutbox?color=%230099AA&label=CutBox&sort=semver&style=for-the-badge"></a>

</div>

[![Sponsor](https://img.shields.io/badge/Sponsor-%E2%9D%A4-pink.svg)](https://github.com/sponsors/cutbox)

CutBox is a clipboard manager for MacOS, designed for developers. It is used to manage and organize text copied from various sources. Some of its features include fuzzy matching, regular expression search, favorites, and the ability to transform text by pasting multiple clipboard entries at once. CutBox works by saving any text copied on MacOS to its history, which can be accessed using a global hotkey. The program supports shortcuts for exiting the search, pasting selected items, and opening the preferences. CutBox can be installed using Homebrew Cask or Homebrew.

- - -

CutBox has JavaScript features that allow you to process text before pasting it. To use this feature, you need to have a file named ~/.cutbox.js in your home directory. This file can contain custom JavaScript code that will be executed when you paste text using CutBox.

You can access this feature by selecting an item from the CutBox clipboard history and then pressing <kbd>Cmd</kbd><kbd>Enter</kbd>. This will open the JavaScript processing dialog where you can enter or modify the JavaScript code to process the text. When you're done, press <kbd>Enter</kbd> to apply the processing and paste the modified text.

Note that the JavaScript code should be safe and not contain any malicious code. Always be careful when running code from untrusted sources.

- - -

Cutbox also has a command-line interface called `cutbox`. It allows you to fetch items from history, filter by search, and get n entries from the most recent or searched items. [See below](https://github.com/cutbox/CutBox/blob/master/README.md#command-line-access)

- - -

Originally Inspired by [JumpCut](https://github.com/snark/jumpcut) & [Flycut](https://github.com/TermiT/Flycut)

![](CutBox/CutBox/GraphicAssets/cutbox-search-bar.png)

![](CutBox/CutBox/GraphicAssets/cutbox-search-fuzzy.png)

## Using CutBox

Any text you copy on MacOS is saved to CutBox's history.

CutBox Search is activated using a global hotkey:

<kbd>**Cmd**</kbd> + <kbd>**Shift**</kbd> + <kbd>**V**</kbd>

(This can be customized in preferences.)

### Searching and pasting

With the CutBox window open, search for anything you copied.

Press <kbd>**Enter**</kbd> and the selected item will paste into your
current app.

To exit press <kbd>**Esc**</kbd>.

# Shortcuts / Key commands:

| Shortcut Keys | Action |
|---|---|
| <kbd>Esc</kbd> | exit search |
| <kbd>Ctrl</kbd><kbd>g</kbd> | exit search |
| <kbd>Enter</kbd> | Paste selected |
| <kbd>Cmd</kbd><kbd>Enter</kbd> | Paste through JavaScript Functions selected (you'll need `~/.cutbox.js` set up) |
| <kbd>Cmd</kbd><kbd>Comma</kbd> | open preferences |
| <kbd>Cmd</kbd><kbd>Delete</kbd> | Delete selected item(s) |
| <kbd>Cmd</kbd><kbd>Comma</kbd> | open preferences |
| <kbd>Cmd</kbd><kbd>t</kbd> |  toggle color themes |
| <kbd>Cmd</kbd><kbd>p</kbd> |  toggle preview |
| <kbd>Cmd</kbd><kbd>Shift</kbd><kbd>=</kbd>  |  zoom/scale up text |
| <kbd>Cmd</kbd><kbd>Shift</kbd><kbd>-</kbd> |  zoom/scale down text |
| <kbd>Cmd</kbd><kbd>Shift</kbd><kbd>0</kbd> |  reset text scale/zoom |
| <kbd>Cmd</kbd><kbd>s</kbd> | toggle search modes, fuzzy match, regexp/i or regexp |
| <kbd>Cmd</kbd><kbd>f</kbd> | toggle search favorites / everything (use the right click menu, to favorite) |

### Status bar menu

![](CutBox/CutBox/GraphicAssets/cutbox-menu.png)

# Install via Homebrew Cask

Install the compiled package.
```
brew tap cutbox/cutbox
brew install --cask cutbox
```

# Install via Homebrew

For advanced users. Builds the package from source, full Xcode installation needed.
```
brew tap cutbox/cutbox
brew install cutbox
```

# First run

When you first run CutBox Macos will prompt you that the developer cannot be identified.

[Please read this post from Apple.](https://support.apple.com/en-us/HT202491#:~:text=If%20you%20want%20to%20open%20an%20app%20that%20hasn%E2%80%99t%20been%20notarized%20or%20is%20from%20an%20unidentified%20developer)

If you prefer to install open source software that isn't notarized (such as CutBox, or Chromium) on your Mac, you can do this in the terminal.

```
sudo spctl --master-disable
```

I only recommend this if you feel comfortable using free software that you can code audit.  CutBox is [code audited by Codacy](https://www.codacy.com/gh/cutbox/CutBox/dashboard?utm_source=github.com&utm_medium=referral&utm_content=cutbox/CutBox&utm_campaign=Badge_Grade).  However it doesn't participate in Apple's anti opensource gatekeeper / notarisation system or any other parts of [Apple's Walled Garden.](https://seekingalpha.com/article/4525092-apple-mr-cook-tear-down-walled-garden)

CutBox will be free and open forever, and is licensed under GNU/GPL3, so the source is always available.

Dmg/.app builds are produced by Github Workflow actions, so you can also inspect the entire test/deploy/delivery chain. (as of Sept 2022)

# Enable automatic paste.

Before CutBox can paste for you (when you select something and hit enter that is.) You have to enable it to control the keyboard.

Go to **System Preferences -> Security & Privacy -> Privacy -> Accessibility**

Unlock and add CutBox to the list of apps (also switch on the check box next to its icon). 

Do the same for input monitoring...:

Go to **System Preferences -> Security & Privacy -> Privacy -> Input Monitoring**

Make sure CutBox is in the list and its checkbox is on.

These work best before CutBox is run. (Macos will suggest restarting CutBox anyway, wait for the CutBox icon to appear before changing a checkbox in security preferences.)

FYI If you're upgrading, you'll need to remove and re-add the new CutBox.app.

# Command line access

The CutBox repo includes a command line tool to access history.

```
Usage:

cutbox [-f query] [limit]

History items can be filtered by Query (string contained in a history item)

Limit will show the top n items (after filtering if used.)
```

The command line tool must be compiled at the moment, from the `cutbox_command` folder you can run:

```sh
swift build -c release; cp .build/release/cutbox /usr/local/bin/
```

This will build and install the command to `/usr/local/bin`

The command will fail to run if CutBox is not installed and has history.

# Would you like to know more?

[More information is in the wiki](https://github.com/cutbox/CutBox/wiki)

# Found something wrong?

If you find a bug, [click here to tell me what happened.](https://github.com/cutbox/CutBox/issues/new?template=ISSUE_TEMPLATE.md)

# Contributing

- Pull requests must have test cover, existing tests should not break.
- Open an issue if tests are already failing, so I know I need to fix them.
- Code must pass the quality checks as used by Codacy.

### Clone and setup dependencies

    git clone git@github.com:CutBox/CutBox

### Compilation setup / tooling

```
gem install cocoapods
cd CutBox
pod install
cd ..
```

To build **CutBox.app**:

```
bin/build
open CutBox/build/
```

Run the local CutBox.app with terminal logging...

```
CutBox/build/CutBox.app/Contents/MacOS/CutBox
```

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
