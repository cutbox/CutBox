
# CutBox

a pasteboard helper inspired by [Flycut](https://github.com/TermiT/Flycut)

CutBox saves and pastes any text copied or cut to the Mac pasteboard.

When you activate it, it'll allow you to type text to search for and
pastes the top match when you press enter.

Right now CutBox is Alpha/minimum viable product and doesn't do much,
I'll be adding a richer visual UI and more control to allow selection
and previewing of your copied text.


# Dev Task list

- [ ] Use https://github.com/yichizhang/SwiftyStringScore for fuzzy search
- [ ] More Keyboard controls
  - [x] Global hotkey to show/hide popup
  - [x] Enter to paste selected item (default to top item)
  - [ ] TODO: up and down arrow to select pasteboard items shown
- [ ] preview full text item (like spotlight preview panel)
- [ ] mouse selection of items from list
- [ ] preferences panel
  - [ ] limit number of copied items
  - [ ] customise hotkeys
- [ ] Make app an auto-start at login item

If you have suggestions or bugs, please add to https://github.com/jasonm23/CutBox/issues

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
