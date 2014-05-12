insert system/options/module-paths join to file! get-env 'HOME %/lib/
import 'sl4a
unless any [system/options/script system/options/args] [do join
	pick split-path system/options/boot 1
	%../lib/start.reb]
; vim: set syn=rebol :
