import 'sl4a-r3-gui
view [
	title "Enter the StackOverflow Chat Parameters"
	hpanel 2 [
		label "Fkey: " fkey-fld: field 120 "pippo"
		label "Cookie: " cookie-area: area 400x80 "" options [min-hint: 400x80]
		pad 50x10
		hpanel [
			button "OK" on-action [
				either any [
					empty? fkey: get-face fkey-fld
					empty? cookie: get-face cookie-area
				]
				[alert "Both fields required!"]
				[
					either parse get-face cookie-area [to "usr=" copy cookie to "&" to end] [
						set 'bot-cookie get-face cookie-area
						set 'fkey get-face fkey-fld
						save %rsoconfig.r3 make object! compose [
							fkey: (fkey) bot-cookie: (bot-cookie)
						]
						alert clean-path %rsoconfig.r3
						close-window face
					] [
						alert "usr cookie not present"
					]
				]
			]
			button "Cancel" red on-action [
				close-window face
			]
		]
	]
]
