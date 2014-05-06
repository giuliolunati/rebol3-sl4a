# DESCRIPTION

This is a Rebol3 interface to the [Scripting Layer for Android (SL4A)](http://en.wikipedia.org/wiki/Scripting_Layer_for_Android). If you are running a Rebol interpreter on an Android device, this provides access to facilities ranging from interacting with the clipboard, to building layouts, to interacting with the speech interface.

See the SL4A documentation for information on what it can do.

# SYNTAX

All invocations are of the form `sl4a method params`.

Method can be a `string!` or a `word!`. Note that if you want to suppress evaluation of a word in order to pass it in literally, you will need to precede it with a single quote.

Params can be a `block!` of values, but as a shortcut single values are treated as if they had been passed in a block. *(So `value => [value]`.)* If you would prefer you can also pass `none` as an alternative to the empty block `[]`.

Some examples:

;-- Get the clipboard, requires no parameters: `sl4a getClipboard none`

;-- Set the clipboard to the string "Rebol": `sl4a setClipboard "Rebol"`

;-- Show a layout (coded in xml-layout string!), then dismiss it: `sl4a fullShow [xml-layout title] sl4a 'fullDismiss none`

;-- Use text-to-speech to say "The voice of Rebol": `sl4a ttsSpeak "The voice of Rebol"`

