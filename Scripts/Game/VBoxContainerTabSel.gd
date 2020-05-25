extends VBoxContainer

var texts = ["MyTxt","Encrpt","Mykey","EnDeEn","EnDeDe","ENcrpt","DEcrpt","EnDe","Names"]

func _ready():
	for i in texts.size()-1:
		self.add_child($Button.duplicate())
	# Connect the buttons, with argument
	for i in self.get_children().size():
		self.get_child(i).connect("pressed", self,"_on_Button_pressed",[i])
		# Set the text
		self.get_child(i).text = texts[i]
		# The color
		if i < 3:
			self.get_child(i).add_color_override("font_color", D.colors[D.playerColorIndex[G.playerIndex]])
			self.get_child(i).add_color_override("font_color_pressed", D.colors[D.playerColorIndex[G.playerIndex]])
			self.get_child(i).add_color_override("font_color_hover", D.colors[D.playerColorIndex[G.playerIndex]])


func update():
	# The color of the selected player
	for i in self.get_children().size():
		if 3 <= i and i < texts.size()-1:
			self.get_child(i).add_color_override("font_color", D.colors[D.playerColorIndex[G.selectedPlayerIndex]])
			self.get_child(i).add_color_override("font_color_pressed", D.colors[D.playerColorIndex[G.selectedPlayerIndex]])
			self.get_child(i).add_color_override("font_color_hover", D.colors[D.playerColorIndex[G.selectedPlayerIndex]])


func _on_Button_pressed(i):
	get_node("../TabContainer").current_tab = i
	for ii in self.get_children().size():
		if ii != i:
			self.get_child(ii).pressed = false