extends VBoxContainer


func _ready():
	# Set the buttons
	var new
	var b = Button.new()
	b.rect_min_size = Vector2(28,56)
	b.size_flags_horizontal = 0
	b.toggle_mode = true
	#
	var l = Label.new()
	l.align = l.ALIGN_CENTER
	l.valign = l.VALIGN_CENTER
	l.rect_min_size = b.rect_min_size
	# A string of the letters
	var x = Code.letters
	for i in x.length():
		new = b.duplicate()
		l.text = x[i] # x.values()[i] + "\n=\n" + x.keys()[i]
		new.add_child(l.duplicate())
		new.connect("pressed", self,"_on_Button_pressed",[i])
		# Which one to put it in
		if x[i].is_subsequence_ofi(Code.letterGroups["cons"]):
			$Cons.add_child(new)
		else:
			if x[i].is_subsequence_ofi(Code.letterGroups["vows"]):
				$Vows.add_child(new)
			else:
				if x[i].is_subsequence_ofi(Code.letterGroups["spcs"]):
					$Spcs.add_child(new)
	


# --------------------------------------------------------
func update():
	# Avoid running before the children are added
	if $Cons.get_child_count() > 0:
		# Set the pressed state of the buttons
		var x = Code.letterGroups["cons"]
		for i in x.length():
			$Cons.get_child(i).pressed = Code.disclosed[G.selectedPlayerIndex][G.playerIndex][x[i]]
		x = Code.letterGroups["vows"]
		for i in x.length():
			$Vows.get_child(i).pressed = Code.disclosed[G.selectedPlayerIndex][G.playerIndex][x[i]]
		x = Code.letterGroups["spcs"]
		for i in x.length():
			$Spcs.get_child(i).pressed = Code.disclosed[G.selectedPlayerIndex][G.playerIndex][x[i]]
# --------------------------------------------------------


# --------------------------------------------------------
func _on_Button_pressed(i):
	# Disclose to the selected
	Code.disclose_and_set_key(Code.letters[i], Code.keys[G.playerIndex].values()[i], G.playerIndex, G.selectedPlayerIndex)
	# Disclose it to the other team members?
	if D.shareDisclosedInTeam:
		for ii in D.nPlayers:
			if ii != G.selectedPlayerIndex:
				if ii != G.playerIndex:
					if D.playerTeam[ii] == D.playerTeam[G.selectedPlayerIndex]:
						# ii is on the selected players team
						Code.disclose_and_set_key(Code.letters[i], Code.keys[G.playerIndex].values()[i], G.playerIndex, ii)
	# Finally just update the pressed states with
	update()
	#$Cons.get_child(i).pressed = true
# --------------------------------------------------------
