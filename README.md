# Hotkey Tools
Bunch of usefull keyboard shortcuts and scripts programmed with [AutoHotkey v2](https://www.autohotkey.com/).

## Install
Just [download AutoHotkey v2](https://www.autohotkey.com/v2/) and clone this repository to your local computer. After that you can customize the settings and switch on/off some modules in the **PRESETS.ini** and then execute the **AHK files** you wanna use.

## Usage
### main.ahk
Contains some cool basic features like text replacement (»Hotstrings«) or keyboard shortcuts for special characters (»Hotkeys«).

### apps.ahk
Contains app shortcuts and APIs like the DeepL translator.

### regexp.ahk
Uses the [RegExHotstring library](https://github.com/8LWXpg/RegExHotstring) to enable some powerfull tools, e. g. a straightforward inline calculator, that solves arithmetical problems while typing them in any application.

### compose.ahk
A [character composition tool](https://en.wikipedia.org/wiki/Compose_key) similar to the native Linux function:
1. Press CapsLock
2. In the meantime, press the keys you want to combine (incl. function keys like Shift or AltGr)
3. Release CapsLock and the combined character is entered
