extends VBoxContainer


func _ready():
	pass


func update():
	$Label.add_color_override("font_color", D.colors[G.selectedPlayerIndex])
	# Coloring of disclosed letters
	$PhraseEncrypted.set_color(Code, G.playerIndex, G.selectedPlayerIndex)
	# Load the text for the selected player
	$PhraseEncrypted.text = $PhraseEncrypted.insert_separator(Code.theirtexts[G.selectedPlayerIndex])

	# fix the text to no sep
	var phrase = $PhraseEncrypted.text.replace($PhraseEncrypted.separator,"")


func _on_PhraseEncrypted_text_changed():
	# Linked with "Deffered"
	# Put the phrase decrypted into the other textedit
	var phrase = $PhraseEncrypted.text.replace($PhraseEncrypted.separator,"")
	#
	Code.theirtexts[G.selectedPlayerIndex] = phrase
