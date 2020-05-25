extends VBoxContainer


func _ready():
	$PhraseEncrypted.oneLineOnly = true
	$PhraseDecrypted.oneLineOnly = true
	$PhraseEncrypted.show_line_numbers = false
	$PhraseDecrypted.show_line_numbers = false


func _change_text(te, text):
	var currentLine = te.cursor_get_line()
	var currentCol = te.cursor_get_column()
	te.text = text
	te.cursor_set_line(currentLine)
	te.cursor_set_column(currentCol)


func update():
	$Label.add_color_override("font_color", D.colors[G.selectedPlayerIndex])
	# Coloring of disclosed letters
	$PhraseEncrypted.set_color(Code, G.playerIndex, G.selectedPlayerIndex)
	$PhraseDecrypted.set_color(Code, G.playerIndex, G.selectedPlayerIndex)
	$PhraseEncryptedAll.set_color(Code, G.playerIndex, G.selectedPlayerIndex)
	# Load the text for the selected player
	_change_text($PhraseEncryptedAll, $PhraseEncrypted.insert_separator(Code.theirtexts[G.selectedPlayerIndex]))
	_change_text($PhraseEncrypted, $PhraseEncryptedAll.get_line($PhraseEncryptedAll.cursorLine))
	# Do the decrypt again (code can be updated)
	# fix the text to no sep
	var phrase = $PhraseEncrypted.text.replace($PhraseEncrypted.separator,"")
	_change_text($PhraseDecrypted, $PhraseEncrypted.insert_separator(Code.decrypt(phrase, G.playerIndex, G.selectedPlayerIndex)))


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
	var tmp = Code.theirtexts[G.selectedPlayerIndex].split("\n")
	tmp[$PhraseEncryptedAll.cursorLine] = phrase
	Code.theirtexts[G.selectedPlayerIndex] = tmp.join("\n")
	#
	_change_text($PhraseDecrypted, $PhraseEncrypted.insert_separator(Code.decrypt(phrase, G.playerIndex, G.selectedPlayerIndex)))
	_change_text($PhraseEncryptedAll, $PhraseEncrypted.insert_separator(Code.theirtexts[G.selectedPlayerIndex]))


func _on_PhraseEncryptedAll_text_changed():
	# Linked with "Deffered"
	# Put the phrase decrypted into the other textedit
	_change_text($PhraseEncrypted, $PhraseEncryptedAll.get_line($PhraseEncryptedAll.cursorLine))
	#
	Code.theirtexts[G.selectedPlayerIndex] = $PhraseEncryptedAll.text.replace($PhraseEncrypted.separator,"")
	#
	var phrase = $PhraseEncrypted.text.replace($PhraseEncrypted.separator,"")
	_change_text($PhraseDecrypted, $PhraseEncrypted.insert_separator(Code.decrypt(phrase, G.playerIndex, G.selectedPlayerIndex)))


func _on_PhraseEncryptedAll_cursor_changed():
	# Put the phrase decrypted into the other textedit
	_change_text($PhraseEncrypted, $PhraseEncryptedAll.get_line($PhraseEncryptedAll.cursorLine))
	#
	var phrase = $PhraseEncrypted.text.replace($PhraseEncrypted.separator,"")
	_change_text($PhraseDecrypted, $PhraseEncrypted.insert_separator(Code.decrypt(phrase, G.playerIndex, G.selectedPlayerIndex)))