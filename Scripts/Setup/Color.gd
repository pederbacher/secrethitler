extends HBoxContainer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var isFreeImg = load("res://assets/images/whiteWithSmallOuter256x256.png")
var isMyImg = load("res://assets/images/whiteWithOuter256x256.png")
var isTheirImg = load("res://assets/images/whiteWithSmallOuterDot256x256.png")

var selectedColor = -1


func update():
	for i in self.get_children().size()-1:
		self.remove_child(self.get_child(1))
	# Add the buttons
	for i in D.nPlayers-1:
		self.add_child($Button.duplicate())
	# Set the colors
	for i in D.nPlayers:
		self.get_child(i).modulate = D.colors[i]
	# Connect the buttons, with argument
	for i in self.get_children().size():
		if self.get_child(i).is_connected("pressed", self,"_on_Button_pressed"):
			self.get_child(i).disconnect("pressed", self,"_on_Button_pressed")
		self.get_child(i).connect("pressed", self,"_on_Button_pressed",[i])
	_update_colors()


remotesync func _update_colors():
	for i in D.nPlayers:
		if D.isColorFree[i]:
			self.get_child(i).set_normal_texture(isFreeImg)
		else:
			if i == selectedColor:
				self.get_child(i).set_normal_texture(isMyImg)
			else:
				self.get_child(i).set_normal_texture(isTheirImg)


remotesync func _select_color(iselect, iunselect):
	if iselect >= 0:	
		D.isColorFree[iselect] = false
	if iunselect >= 0:
		D.isColorFree[iunselect] = true
	

func _on_Button_pressed(i):
	if selectedColor == i:
		# Unselect it
		selectedColor = -1
		rpc("_select_color", selectedColor, i)
		rpc("_update_colors")
	else: 
		if D.isColorFree[i]:
			# Button is pressed
			rpc("_select_color", i, selectedColor)
			selectedColor = i
			rpc("_update_colors")
			# Debug init
			get_node("../../")._on_SaveToGame_pressed()
					#self.get_child(i). = D.colors[D.freeColorIndex[i-1]]
	#	get_node("../TabContainer/PhrasesTheirs").update()
#	get_node("../TabContainer/PhrasesTheirsDecrypted").update()
