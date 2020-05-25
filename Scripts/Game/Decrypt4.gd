extends VBoxContainer


func _ready():
	pass


func update():
	$Label.add_color_override("font_color", D.colors[G.selectedPlayerIndex])
	# Coloring of disclosed letters
	$PhraseEncrypted.set_color(Code, G.playerIndex, G.selectedPlayerIndex)
	$PhraseDecrypted.set_color(Code, G.playerIndex, G.selectedPlayerIndex)
	# Load the text for the selected player
	$PhraseEncrypted.text = $PhraseEncrypted.insert_separator(Code.theirtexts[G.selectedPlayerIndex])
	# Do the decrypt again (code can be updated)
	var currentLine = $PhraseDecrypted.cursor_get_line()
	var current = $PhraseDecrypted.cursor_get_column()
	# fix the text to no sep
	var phrase = $PhraseEncrypted.text.replace($PhraseEncrypted.separator,"")
	# Decrypt the text and put it into Decrypted
	$PhraseDecrypted.text = $PhraseEncrypted.insert_separator(Code.decrypt(phrase, G.playerIndex, G.selectedPlayerIndex))
	# Set the cursor
	$PhraseDecrypted.cursor_set_line(currentLine)
	$PhraseDecrypted.cursor_set_column(current)


func _on_PhraseDecrypted_text_changed():
	# Linked without "Deffered"
	# Update the encrypted text
	$PhraseDecrypted.update_code_on_text_change(Code, G.playerIndex, G.selectedPlayerIndex)
	# Update, tror allerede, at det er kaldt 2 gange igennem Code.set_key og Code.altered (måske før set_key, så behøves ikke at kalde update)
	update()


func _on_PhraseEncrypted_text_changed():
	# Linked with "Deffered"
	# Put the phrase decrypted into the other textedit
	var phrase = $PhraseEncrypted.text.replace($PhraseEncrypted.separator,"")
	#
	Code.theirtexts[G.selectedPlayerIndex] = phrase
	#
	$PhraseDecrypted.text = $PhraseEncrypted.insert_separator(Code.decrypt(phrase, G.playerIndex, G.selectedPlayerIndex))

