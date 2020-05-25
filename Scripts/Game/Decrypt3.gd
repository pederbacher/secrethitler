extends VBoxContainer


func _ready():
	pass


func update():
	$Label.add_color_override("font_color", D.colors[G.selectedPlayerIndex])
	# Coloring of disclosed letters
	$PhraseDecrypted.set_color(Code, G.playerIndex, G.selectedPlayerIndex)
	# Do the decrypt again (code can be updated)
	var currentLine = $PhraseDecrypted.cursor_get_line()
	var current = $PhraseDecrypted.cursor_get_column()
	# Decrypt the text and put it into Decrypted
	$PhraseDecrypted.text = $PhraseDecrypted.insert_separator(Code.decrypt(Code.theirtexts[G.selectedPlayerIndex], G.playerIndex, G.selectedPlayerIndex))
	# Set the cursor
	$PhraseDecrypted.cursor_set_line(currentLine)
	$PhraseDecrypted.cursor_set_column(current)


func _on_PhraseDecrypted_text_changed():
	# Linked without "Deffered"
	# Update the encrypted text
	$PhraseDecrypted.update_code_on_text_change(Code, G.playerIndex, G.selectedPlayerIndex)
	# Update, tror allerede, at det er kaldt 2 gange igennem Code.set_key og Code.altered (måske før set_key, så behøves ikke at kalde update)
