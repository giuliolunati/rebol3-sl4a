# DESCRIPTION

This is a Rebol3 interface to the [Scripting Layer for Android (SL4A)](http://en.wikipedia.org/wiki/Scripting_Layer_for_Android). If you are running a Rebol interpreter on an Android device, this provides access to facilities ranging from interacting with the clipboard, to building layouts, to interacting with the speech interface.

See the SL4A documentation for information on what it can do.

# CONFIG

**WARNING**: you *MUST* provide an android CLI `rebol3` executable; place it in `assets/bin/`. You can found prebuilt one at [rebolsource](http://rebolsource.net)

Config file: `assets/bin/rebol.r`

Modules: `assets/lib/`

Scripts: `assets/scripts/`

# BUILD

[Prebuilt APK](http://giuliolunati.altervista.org/Rebol3/)

Tested building with [AIDE](http://www.android-ide.com/).

Anyone can test Eclipse?

# INSTALL

First run after app install: button "Install" place `rebol3` executable and `rebol.r` config file in `$HOME/bin`, modules in `$HOME/lib/`, scripts in `/sdcard/sl4a/scripts/` 

`HOME` is `/data/data/github/giuliolunati/rebol3sl4a/files/`

# SYNTAX

All invocations are of the form `sl4a method params`.

Method can be a `string!` or a `word!`. Note that if you want to suppress evaluation of a word in order to pass it in literally, you will need to precede it with a single quote.

Params can be a `block!` of values, but as a shortcut single values are treated as if they had been passed in a block. *(So `value => [value]`.)* If you would prefer you can also pass `none` as an alternative to the empty block `[]`.

Some examples:

;-- Get the clipboard, requires no parameters: `sl4a getClipboard none`

;-- Set the clipboard to the string "Rebol": `sl4a setClipboard "Rebol"`

;-- Show a layout (coded in xml-layout string!), then dismiss it: `sl4a fullShow [xml-layout title] sl4a 'fullDismiss none`

;-- Use text-to-speech to say "The voice of Rebol": `sl4a ttsSpeak "The voice of Rebol"`

