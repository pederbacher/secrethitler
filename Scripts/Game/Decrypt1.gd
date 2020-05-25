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
	$PhraseDecryptedAll.set_color(Code, G.playerIndex, G.selectedPlayerIndex)
	# --------
	# Load only the lines
	var text = Code.theirtexts[G.selectedPlayerIndex].split("\n")
	if $PhraseDecryptedAll.cursorLine > text.size() - 1:
		$PhraseDecryptedAll.cursorLine = text.size() - 1
	_change_text($PhraseEncrypted, $PhraseEncrypted.insert_separator(text[$PhraseDecryptedAll.cursorLine]))
	# --------
	# Do the decrypt again (code can be updated)
	# fix the text to no sep
	var phrase = $PhraseEncrypted.text.replace($PhraseEncrypted.separator,"")
	# Decrypt the text and put it into Decrypted
	_change_text($PhraseDecrypted, $PhraseEncrypted.insert_separator(Code.decrypt(phrase, G.playerIndex, G.selectedPlayerIndex)))
	# --------
	# Do the decrypt again (code can be updated)
	# fix the text to no sep
	phrase = Code.theirtexts[G.selectedPlayerIndex]
	# Decrypt the text and put it into Decrypted
	_change_text($PhraseDecryptedAll, $PhraseEncrypted.insert_separator(Code.decrypt(phrase, G.playerIndex, G.selectedPlayerIndex)))


func _on_PhraseDecrypted_text_changed():
	# Linked without "Deffered"
	# Update the code
	$PhraseDecrypted.update_code_on_text_change(Code, G.playerIndex, G.selectedPlayerIndex)
	# Update gui
	update()

func _on_PhraseDecryptedAll_text_changed():
	# Linked without "Deffered"
	# Update the code
	$PhraseDecryptedAll.update_code_on_text_change(Code, G.playerIndex, G.selectedPlayerIndex)
	# Update gui
	update()


func _on_PhraseEncrypted_text_changed():
	# Linked with "Deffered"
	# Put the phrase decrypted into the other textedit
	var phrase = $PhraseEncrypted.text.replace($PhraseEncrypted.separator,"")
	#
	var tmp = Code.theirtexts[G.selectedPlayerIndex].split("\n")
	tmp[$PhraseDecryptedAll.cursorLine] = phrase
	Code.theirtexts[G.selectedPlayerIndex] = tmp.join("\n")
	#
	_change_text($PhraseDecrypted, $PhraseEncrypted.insert_separator(Code.decrypt(phrase, G.playerIndex, G.selectedPlayerIndex)))
	_change_text($PhraseDecryptedAll, $PhraseEncrypted.insert_separator(Code.decrypt(Code.theirtexts[G.selectedPlayerIndex], G.playerIndex, G.selectedPlayerIndex)))


func _on_PhraseDecryptedAll_cursor_changed():
	# Linked with "Deffered"
	# Load only the phrase
	_change_text($PhraseEncrypted, $PhraseEncrypted.insert_separator(Code.theirtexts[G.selectedPlayerIndex].split("\n")[$PhraseDecryptedAll.cursorLine]))
	# --------
	# Do the decrypt again (code can be updated)
	# fix the text to no sep
	var phrase = $PhraseEncrypted.text.replace($PhraseEncrypted.separator,"")
	# Decrypt the text and put it into Decrypted
	_change_text($PhraseDecrypted, $PhraseEncrypted.insert_separator(Code.decrypt(phrase, G.playerIndex, G.selectedPlayerIndex)))
	
