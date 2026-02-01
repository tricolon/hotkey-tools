# Hotkey Tools
Lots of useful keyboard shortcuts and scripts programmed with [AutoHotkey](https://www.autohotkey.com/) Version 2.


## Install
1. Download [AutoHotkey v2](https://www.autohotkey.com/v2/)
2. Clone this repository to your local computer: `git clone https://github.com/tricolon/hotkey-tools.git`
3. Copy `PRESETS_SAMPLE.ini` and rename the new file to `PRESETS.ini`<br/>
   (so that your customizations becomes ignored via `.gitignore`)
5. Customize the settings and switch on/off some modules in the new `PRESETS.ini` file
6. **Execute** the AHK files you wanna use.


## Usage
### `main.ahk`
Contains some cool basic features like text replacement (»Hotstrings«) or keyboard shortcuts for special characters (»Hotkeys«).

### `apps.ahk`
Contains app shortcuts and APIs like the DeepL translator.

### `regexp.ahk`
Uses the [RegExHotstring library](https://github.com/8LWXpg/RegExHotstring) to enable some powerfull tools, e. g. a straightforward inline calculator, that solves arithmetical problems while typing them in any application.

### `compose.ahk`
A [character composition tool](https://en.wikipedia.org/wiki/Compose_key) similar to the native Linux function:
1. Press CapsLock
2. In the meantime, press the keys you want to combine (incl. function keys like Shift or AltGr)
3. Release CapsLock and the combined character is entered
