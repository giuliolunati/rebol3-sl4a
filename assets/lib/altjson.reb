REBOL [
	Title: "JSON Parser for Rebol 3"
	Author: "Christopher Ross-Gill"
	Type: 'module
	Date: 15-Jul-2011
	Home: http://www.ross-gill.com/page/JSON_and_REBOL
	File: %altjson.r
	Version: 0.2.8
	Rights: http://creativecommons.org/licenses/by-sa/3.0/
	Name: 'altjson
	Exports: [load-json to-json]
	Purpose: "Convert a Rebol block to a JSON string"
	History: [
		22-May-2005 0.1.0 "Original Version"
		6-Aug-2010 0.2.2 "Issue! composed of digits encoded as integers"
		28-Aug-2010 0.2.4 "Encodes tag! any-type! paired blocks as an object"
		2-Dec-2010 0.2.5 "Support for time! added"
		15-July-2011 0.2.6 "Flattens Flickr '_content' objects"
	]
	Notes: {
		- Simple Escaping
		- Converts date! to RFC 822 Date String ('to-idate)
	}
]

load-json: use [
	tree branch here val flat? emit new-child to-parent neaten
	space comma number string block object _content value
][
	branch: make block! 10

	emit: func [val][here: insert/only here val]
	new-child: [(insert/only branch insert/only here here: copy [])]
	to-parent: [(here: take branch)]
	neaten: [
		(new-line/all head here true)
		(new-line/all/skip head here true 2)
	]

	space: use [space][
		space: charset " ^-^/^M"
		[any space]
	]

	comma: [space #"," space]

	number: use [dg ex nm as-num][
		dg: charset "0123456789"
		ex: [[#"e" | #"E"] opt [#"+" | #"-"] some dg]
		nm: [opt #"-" some dg opt [#"." some dg] opt ex]

		as-num: func [val][
			either parse val [opt "-" some dg][
				any [attempt [to integer! val] to issue! val]
			][
				to decimal! val
			]
		]

		[copy val nm (val: as-num val)]
	]

	string: use [ch dq es hx mp decode][
		ch: complement charset {\"}
		es: charset {"\/bfnrt}
		hx: charset "0123456789ABCDEFabcdef"
		mp: [#"^"" "^"" #"\" "\" #"/" "/" #"b" "^H" #"f" "^L" #"r" "^M" #"n" "^/" #"t" "^-"]

		decode: use [ch mk escape][
			escape: [
				mk: #"\" [
					  es (mk: change/part mk select mp mk/2 2)
					| #"u" copy ch 4 hx (
						mk: change/part mk to char! to integer! to issue! ch 6
					)
				] :mk
			]

			func [text [string! none!] /mk][
				either none? text [copy ""][
					all [parse/all text [any [to "\" escape] to end] text]
				]
			]
		]

		[#"^"" copy val [any [some ch | #"\" [#"u" 4 hx | es]]] #"^"" (val: decode val)]
	]

	block: use [list][
		list: [space opt [value any [comma value]] space]

		[#"[" new-child list #"]" neaten/1 to-parent]
	]

	_content: [#"{" space {"_content"} space #":" space value space "}"] ; Flickr

	object: use [name list as-object][
		name: [
			string space #":" space
			(emit to either flat? [tag!][set-word!] val)
		]
		list: [space opt [name value any [comma name value]] space]
		as-object: [(unless flat? [here: change back here make object! pick back here 1])]

		[#"{" new-child list #"}" neaten/2 to-parent as-object]
	]

	value: [
		  "null" (emit none)
		| "true" (emit true)
		| "false" (emit false)
		| number (emit val)
		| string (emit val)
		| _content (emit val)
		| object | block
	]

	func [
		[catch] "Convert a json string to rebol data"
		json [string! binary! file! url!] "JSON string"
		/flat "Objects are imported as tag-value pairs"
	][
		flat?: :flat
		tree: here: copy []
		if any [file? json url? json][
			if error? json: try [read (json)][
				throw :json
			]
		]
		unless parse/all json [space opt value space][
			make error! "Not a valid JSON string"
		]
		pick tree 1
	]
]

to-json: use [
	json emit emits escape emit-issue
	here comma block object value
][
	emit: func [data][repend json data]
	emits: func [data][emit {"} emit data emit {"}]

	escape: use [mp ch es encode][
		mp: [#"^/" "\n" #"^M" "\r" #"^-" "\t" #"^"" "\^"" #"\" "\\" #"/" "\/"]
		ch: complement es: charset extract mp 2
		encode: func [here][change/part here select mp here/1 1]

		func [txt][
			parse/all txt [any [txt: some ch | es (txt: encode txt) :txt]]
			head txt
		]
	]

	emit-issue: use [dg nm mk][
		dg: charset "0123456789"
		nm: [opt "-" some dg]

		[(either parse next form here/1 [copy mk nm][emit mk][emits here/1])]
	]

	comma: [(if not tail? here [emit ","])]
	block: [(emit "[") any [here: value here: comma] (emit "]")]
	object: [
		(emit "{")
		any [
			here: [tag! | set-word!]
			(emit [{"} escape to string! either tag? here/1 [here/1][to word! here/1] {":}])
			here: value here: comma
		]
		(emit "}")
	]

	value: [
		  number! (emit here/1)
		| [logic! | 'true | 'false] (emit form here/1)
		| [none! | 'none] (emit 'null)
		| date! (emits to-idate here/1)
		| issue! emit-issue
		| [
			any-string! | word! | lit-word! | tuple! | pair! | money! | time!
		] (emits escape form here/1)

		| into [some [tag! skip]] :here (change/only here copy first here) into object
		| any-block! :here (change/only here copy first here) into block
		| object! :here (change/only here body-of first here) into object

		| any-type! (emits [type? here/1 "!"])
	]

	func [data][
		json: make string! ""
		if parse compose/only [(data)][here: value][json]
	]
]