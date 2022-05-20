<p align="center">
  <img src="CutBox/CutBox/GraphicAssets/cutbox-icon.png">
</p>

<p align="center">
  <a href="https://gitter.im/CutBox/Lobby" title="Chat about CutBox"/><img src="https://badges.gitter.im/cutbox/CutBox.png"/></a>
  &nbsp;
  <a href="https://www.codacy.com/app/cutbox/CutBox?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=cutbox/CutBox&amp;utm_campaign=Badge_Grade"> <img src="https://api.codacy.com/project/badge/Grade/1e2514342ff44f24ab5e2eb8c79f4f2b"/> </a>
</p>

<div align="center">
  <h1>CutBox</h1>
  <p>it'll make your pasteboard awesome!</p>
</div>

# IMPORTANT

First thing to know about using CutBox yourself is that you'll need to compile it.  If you need an out of the box solution, and you want new features that you don't want to add yourself, please move along to the next clipboard history app.

If you think compiling your own apps is a fun thing to do, keep reading.  My project goals are now:

- Make this easy for you to compile on your own Mac.

My other goal is to only attract users who want to use CutBox in a plain-text / developer setting, any non-text pasteboard items are not in the scope of CutBox.

[Compile instructions](#compilation-setup--tooling)

## About CutBox

CutBox keeps your pasteboard cut/copy history and lets you paste
anything back to your current app by searching for items.

Inspired by [JumpCut](https://github.com/snark/jumpcut) & [Flycut](https://github.com/TermiT/Flycut)

![](CutBox/CutBox/GraphicAssets/cutbox-search-bar.png)

What does it do? Let's you search from your pasteboard history....

![](CutBox/CutBox/GraphicAssets/cutbox-search-fuzzy.png)

What else...

- Make items favorite
- Select and paste multiple items as one

Anything else?

- You can send your pasted text through [Javascript functions](https://github.com/cutbox/CutBox/wiki/Javascript-support)

# Download / install...

CutBox is Free OpenSource software. It isn't available via Apple's AppStore. or possible to download and install a CutBox.app. This is thanks to Apple's poorly thought through (or deliberately toxic to Open Source apps?) Gatekeeper / Notarization policy.

[Compile instructions](#compilation-setup--tooling)

## Using CutBox

Any text you copy on MacOS is saved to CutBox's history.

![](CutBox/CutBox/GraphicAssets/cutbox-menu.png)

CutBox Search is activated using a global hotkey:

<kbd>**Cmd**</kbd> + <kbd>**Shift**</kbd> + <kbd>**V**</kbd>

(This can be customized in preferences.)

### Searching and pasting

![](CutBox/CutBox/GraphicAssets/cutbox-search-fuzzy.png)

When you activate CutBox you can search for anything copied, just type
what you're searching for or navigate with the arrow keys (or
mouse/trackpad).

Press <kbd>**Enter**</kbd> and the selected item will paste into your
current app.

You can exit without pasting, just press <kbd>**Esc**</kbd>.

If fuzzy matching isn't specific enough for you, regexp matching is
also available.

![](CutBox/CutBox/GraphicAssets/cutbox-search-mode.gif)

Press <kbd>Cmd</kbd> + <kbd>s</kbd> to toggle through search modes,
fuzzy match, regexp/i or regexp.

# Would you like to know more?

I'm moving more help and information to the project wiki, [read more...](https://github.com/cutbox/CutBox/wiki)

# Bugs...

If you find a bug, [click here to tell me
what happened.](https://github.com/cutbox/CutBox/issues/new?template=ISSUE_TEMPLATE.md)

# Developers

If you'd like to contribute to CutBox development, especially if you find bugs you'd like to fix, please follow the guidelines below.

- Pull requests should be covered by tests (Quick/Nimble or XCUITest)
- Code must pass the quality checks as used by Codacy

### Compilation setup / tooling

The following tools were used to build CutBox. You will
need them:

- `ruby` - Used by cocoapods `pod` and `carthage`
- `npm/node` - Used by `semver`

- XCode Version 11.6 (11E708)
- Cocopods 1.9.3
- Carthage 0.35.0

- `semver` - Semantic version manager `npm install -g semver`
- `gsort` - GNU sort `brew install coreutils`

Also, since assuming assumptions isn't great,  to be clear you're going to be building on MacOS compatible with XCode 11.6 which has the following installed:

- `git` 2.20.1
- `osascript`
- `unexpand`
- `PListBuddy` (You should beable to find it at `/usr/libexec/PlistBuddy`)

### Clone and setup dependencies

Get the CutBox source via git:

    git clone --recurse-submodules git@github.com:CutBox/CutBox

Once cloned, move to the cloned folder: `cd CutBox`

Now run:

  `bin/setup`

To build **CutBox.app**:

  `bin/make_local_app`

There's a Gitter channel if you have problems getting up and running (https://gitter.im/CutBox)

# Troubleshooting

CutBox requires you to allow it access to keyboard control (it will simulate a **Cmd+v** to paste)

Go to **System Preferences -> Security & Privacy -> Privacy -> Accessibility**

Here you will need to set CutBox to allow Accessibility (unlock &
check box) or it won't paste your selected clipboard item.

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
