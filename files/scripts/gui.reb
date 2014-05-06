import 'sl4a-r3-gui
probe view [
	title "SL4A R3 GUI"
	hpanel 2 [
		label "Name"
		field
		label "Message"
		area
	]
	button "Close" on-action [close-window face]
]
