extends VBoxContainer
#
#var flag_updating_text = false
#var box_width = 50
#var box_height = 24
#
#
#func _ready():
#	var te
#	var new
#	te = TextEdit.new()
#	te.size_flags_horizontal = 0
#	te.size_flags_vertical = 0
#	te.rect_min_size = Vector2(box_width,box_height)
#	# How many cons
#	$Cons.columns = floor(Code.letters.length()+1) / 2
#
#	# Add the letters
#	for i in Code.letters.length():
#		# Make the edits with the key and value
#		new = te.duplicate()
#		new.text = Code.letters[i] + "=" + Code.theirskeys[G.playerIndex][G.selectedPlayerIndex].dict.values()[i]
#		new.connect("text_changed",self,"_on_text_changed_cons",[i])
#		new.connect("focus_entered",self,"_on_focus_entered_cons",[i])
#		new.connect("cursor_changed",self,"_on_cursor_changed_cons",[i])
#		$Cons.add_child(new)
##	# Add the vows
##	for i in Code.chars_vows.length():
##		# Make the edits with the key and value
##		new = te.duplicate()
##		new.text = Code.chars_vows[i] + "=" + Code.vows[G.playerIndex][G.selectedPlayerIndex].dict.values()[i]
##		new.connect("text_changed",self,"_on_text_changed_vows",[i])
##		new.connect("focus_entered",self,"_on_focus_entered_vows",[i])
##		new.connect("cursor_changed",self,"_on_cursor_changed_vows",[i])
##		$Vows.add_child(new)
##	# Add the spcs
##	for i in Code.chars_spcs.length():
##		# Make the edits with the key and value
##		new = te.duplicate()
##		new.text = Code.chars_spcs[i] + "=" + Code.spcs[G.playerIndex][G.selectedPlayerIndex].dict.values()[i]
##		new.connect("text_changed",self,"_on_text_changed_spcs",[i])
##		new.connect("focus_entered",self,"_on_focus_entered_spcs",[i])
##		new.connect("cursor_changed",self,"_on_cursor_changed_spcs",[i])
##		$Spcs.add_child(new)
#
#
#func update():
#	# Change the key to the selected player
#	self.flag_updating_text = true
#	var keyvalue
#	for i in Code.letters.length():
#		keyvalue = Code.theirskeys[G.playerIndex][G.selectedPlayerIndex].dictinv.values()[i]
#		$Cons.get_child(i).text = Code.letters[i] + "=" + keyvalue
#		# Is it disclosed? then color green
#		if Code.disclosed[G.playerIndex][G.selectedPlayerIndex][keyvalue]:
#			$Cons.get_child(i).add_color_override("font_color", Color(0,1,0))
#		else:
#			$Cons.get_child(i).add_color_override("font_color", Color(1,1,1))
##	for i in Code.chars_vows.length():
##		keyvalue = Code.vows[G.playerIndex][G.selectedPlayerIndex].dictinv.values()[i]
##		$Vows.get_child(i).text = Code.chars_vows[i] + "=" + keyvalue
##		# Is it disclosed? then color green
##		if Code.vows_disclosed[G.selectedPlayerIndex][G.playerIndex][keyvalue]:
##			$Vows.get_child(i).add_color_override("font_color", Color(0,1,0))
##		else:
##			$Vows.get_child(i).add_color_override("font_color", Color(1,1,1))
##	for i in Code.chars_spcs.length():
##		keyvalue = Code.spcs[G.playerIndex][G.selectedPlayerIndex].dictinv.values()[i]
##		$Spcs.get_child(i).text = Code.chars_spcs[i] + "=" + keyvalue
##		# Is it disclosed? then color green
##		if Code.spcs_disclosed[G.selectedPlayerIndex][G.playerIndex][keyvalue]:
##			$Spcs.get_child(i).add_color_override("font_color", Color(0,1,0))
##		else:
##			$Spcs.get_child(i).add_color_override("font_color", Color(1,1,1))
#	self.flag_updating_text = false
#
#
#
## ---------------------------------------------------------------
#func _on_focus_entered_cons(i):
#	$Cons.get_child(i).cursor_set_column(3)
#
#func _on_cursor_changed_cons(i):
#	$Cons.get_child(i).cursor_set_column(3)
#
#func _on_text_changed_cons(i):
#	# Text in one of the textedits has changed
#	# i is the changed one
#	var newtext = $Cons.get_child(i).text
#	var oldtext = Code.letters[i] + "=" + Code.theirskeys[G.playerIndex][G.selectedPlayerIndex].dictinv.values()[i]
#	# Check the new text, should we change the value?
#	if newtext != oldtext and newtext.length() == 4:
#		Code.set_key(newtext[3], Code.letters[i], G.playerIndex, G.selectedPlayerIndex)
#	update()
## ---------------------------------------------------------------
#
##
### ---------------------------------------------------------------
##func _on_focus_entered_vows(i):
##	$Vows.get_child(i).cursor_set_column(3)
##
##func _on_cursor_changed_vows(i):
##	$Vows.get_child(i).cursor_set_column(3)
##
##func _on_text_changed_vows(i):
##	# Text in one of the textedits has changed
##	# i is the changed one
##	var newtext = $Vows.get_child(i).text
##	var oldtext = Code.chars_vows[i] + "=" + Code.vows[G.playerIndex][G.selectedPlayerIndex].dictinv.values()[i]
##	# Check the new text, should we change the value
##	if newtext != oldtext and newtext.length() == 4:
##		Code.set_key(newtext[3], Code.chars_vows[i], G.playerIndex, G.selectedPlayerIndex)
##	update()
### ---------------------------------------------------------------
##
##
### ---------------------------------------------------------------
##func _on_focus_entered_spcs(i):
##	$Spcs.get_child(i).cursor_set_column(3)
##
##func _on_cursor_changed_spcs(i):
##	$Spcs.get_child(i).cursor_set_column(3)
##
##func _on_text_changed_spcs(i):
##	# Text in one of the textedits has changed
##	# i is the changed one
##	var newtext = $Spcs.get_child(i).text
##	var oldtext = Code.chars_spcs[i] + "=" + Code.spcs[G.playerIndex][G.selectedPlayerIndex].dictinv.values()[i]
##	# Check the new text, should we change the value
##	if newtext != oldtext and newtext.length() == 4:
##		var new = newtext[3]
##		Code.set_key(new, Code.chars_spcs[i], G.playerIndex, G.selectedPlayerIndex)
##	update()
### ---------------------------------------------------------------
