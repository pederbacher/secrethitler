extends VBoxContainer

var selImg = load("res://assets/images/whiteWithOuter256x256.png")
var noselImg = load("res://assets/images/whiteWithSmallOuter256x256.png")

var dynamic_font = DynamicFont.new()

var allPlayerbuttons = []



func _ready():
	#
	dynamic_font.font_data = load("res://assets/fonts/Font1.ttf")
	dynamic_font.size = 10
	#
	#
	# First add a vertical container for each team
	# subtract 1 because there already is one VC
	for i in D.nTeams-1:
		self.add_child($VCForTeam.duplicate())
	#
	#
	var iteam
	var playersOdered
	var vc
	var iplayer
	var button
	var label
	# For each team
	for ii in D.nTeams:
		iteam = G.orderTeams[ii]
		vc = self.get_child(ii)
		# subtract 1 because there already is one button
		for i in G.playersOnTeamOrdered[iteam].size()-1:
			vc.add_child($VCForTeam/Button.duplicate())
		# Connect the buttons, with playerIndex as argument, and add label text and color
		# First order the players on the team according to G.orderPlayers
		for i in G.playersOnTeamOrdered[iteam].size():
			iplayer = G.playersOnTeamOrdered[iteam][i]
			button = vc.get_child(i)
			button.connect("pressed", self,"_on_Button_pressed",[iplayer,button])
			# Set the color
			button.modulate = D.colors[D.playerColorIndex[iplayer]]
			# Set the texture
			button.set_normal_texture(noselImg)
			# Set the size of label
			label = button.get_child(0)
			label.rect_size = Vector2(self.rect_size[0], self.rect_size[1] / D.nPlayers)
			label.text = D.playerName[iplayer].to_upper()
			label.add_font_override("font", dynamic_font)
			label.add_color_override("font_color", Color(1,1,1))
			# Keep it for later easy reset of selected state
			allPlayerbuttons.append(button)
	# The first is selected as init, it's always G.playerIndex because of the order set in G.orderPlayers is from the peer player
	self.get_child(0).get_child(0).set_normal_texture(selImg)
	self.get_child(0).get_child(0).get_child(0).add_color_override("font_color", Color(0,0,0))
	G.selectedPlayerIndex = G.playerIndex
	# Update the fields in the tabcontainer
	get_node("../TabContainer/MyKey").update()
	get_node("../TabContainer/Decrypt1").update()
	get_node("../TabContainer/Decrypt1a").update()
	get_node("../TabContainer/Decrypt2").update()
	get_node("../TabContainer/Decrypt3").update()
	get_node("../TabContainer/Decrypt4").update()
	get_node("../VBoxContainerTabSel").update()

func _on_Button_pressed(iplayer,button):
	for bt in allPlayerbuttons:
		bt.set_normal_texture(noselImg)
		bt.get_child(0).add_color_override("font_color", Color(1,1,1))
	button.set_normal_texture(selImg)
	button.get_child(0).add_color_override("font_color", Color(0,0,0))
#	for ii in self.get_children().size():
#		if i == ii:
#			self.get_child(ii).set_normal_texture(selImg)
#		else:
#			self.get_child(ii).set_normal_texture(noselImg)
	G.selectedPlayerIndex = iplayer
	# Update the fields in the tabcontainer
	get_node("../TabContainer/MyKey").update()
	get_node("../TabContainer/Decrypt1").update()
	get_node("../TabContainer/Decrypt1a").update()
	get_node("../TabContainer/Decrypt2").update()
	get_node("../TabContainer/Decrypt3").update()
	get_node("../TabContainer/Decrypt4").update()
	get_node("../VBoxContainerTabSel").update()

