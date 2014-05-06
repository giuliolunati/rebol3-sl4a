REBOL [
	Type: module
	Name: sl4a-r3-gui
	Exports: [alert close-window get-face view ]
	Needs: [sl4a]
	Title: "Android UI"
	File: %sl4a-r3-gui.reb
	Version: 0.1.0
	Date: 25-Apr-2014
	Author: "Giulio Lunati <giuliolunati@gmail.com>"
]
close-window: function [face [word!]] [
	sl4a fullDismiss none
]
get-face: function [face [word!]] [
	o: sl4a fullQueryDetail face
	o/result/text
]
alert: function [text [any-string!]] [
	sl4a makeToast text
]
quote: function [ {Quote \ and " with \ in string s}
		s
	] [
	q: charset {\"}
	parse to string! s [any[to q insert "\" skip]]
	ajoin[{"} s {"}]
]
view: function [code] [
	v: make string! 64
	r: make string! 512
	actions: make block! 8
	faces: make block! 8
	stack: make block! 8
	nid: 0
	level: 0
	style: [ 'area | 'button | 'field | 'hpanel | 'label | 'pad | 'title ]
	cols: 1 col: 0
	layout: [any cell]
	table: [ any [
		(append stack tail r)
		cell
		( p: take/last stack
			if col = 0 [insert p {^/<TableRow android:layout_width="match_parent">}]
			col: mod col + 1 cols
			if col = 0 [append r {^/</TableRow>}]
		)
	] ]
	cell: [
		[	(++ nid id: to lit-word! join 'id nid) here:
			opt [
				set v set-word!
				(append faces
					reduce[v to lit-word! id]
				)
			]
		]
		[
			'hpanel set v integer!
					( append stack cols cols: v
						append r {^/<TableLayout android:layout_width="match_parent" android:orientation="vertical">}
					)
				into table (cols: take/last stack
					append r {^/</TableLayout>}
				)
			| 'hpanel
					(append r {^/<LinearLayout android:layout_width="match_parent" android:orientation="horizontal">})
				into layout (append r {^/</LinearLayout>})
			| set v style
					(	switch v [
							area   [append r {^/<EditText android:minLines="2" android:layout_width="0dp" android:layout_weight="1"}]
							button [append r {^/<Button}]
							field  [append r {^/<EditText android:singleLine="true" android:layout_width="0dp" android:layout_weight="1"}]
							label  [append r {^/<TextView}]
							pad    [append r {^/<TextView}]
							title  [append r {^/<TextView android:gravity="center" android:textSize="30px" android:layout_width="match_parent"}]
						]
						append r ajoin [
							{ android:id="@+id/} id {"}
						]
					)
				any [
					set v string!
						(	append r { android:text=}
							append r quote v
						)
					| 'on-action set v block!
						(	unless empty? v
							[
								append actions
								reduce[id v]
							]
						)
					| 'options block!
					|	and not style and not set-word!
						set v skip (probe v)
				]
				(append r { />})
		]
	]
	r: {<?xml version="1.0" encoding="utf-8"?>^/<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android" android:orientation="vertical" android:background="#000044">}
	ok: parse code layout
	append r {^/</LinearLayout>^/}
	print {--- XML Layout ---}
	probe r
	unless ok [ probe here quit ]
	print {--- fullShow ---}
 probe sl4a fullShow [r 'Title]
	print {--- faces ---}
 probe faces: object faces
	forever [
	 print {--- event ---}
		probe ev: sl4a eventWait 1000000
		if ev/error [continue]
		face: attempt[to lit-word! ev/result/data/id]
		unless face [continue]
		c: select actions face
		if c [do bind bind c 'face faces]
	]
]
