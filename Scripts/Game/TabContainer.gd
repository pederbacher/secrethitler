extends TabContainer

func _ready():
	$PhrasesMine/Label.add_color_override("font_color", D.colors[G.playerIndex])
	$PhrasesMineEncrypted/Label.add_color_override("font_color", D.colors[G.playerIndex])
	$MyKey/Label.add_color_override("font_color", D.colors[G.playerIndex])


func _on_TabContainer_tab_changed(i_tab):
	if i_tab == 1:
		$PhrasesMineEncrypted/TextEdit.text = Code.encrypt($PhrasesMine/TextEdit.text, G.playerIndex, G.playerIndex)
	if i_tab == 2:
		$MyKey.update()
	if i_tab == 3:
		$Decrypt1.update()
	if i_tab == 4:
		$Decrypt2.update()
	if i_tab == 5:
		$Decrypt3.update()
	if i_tab == 6:
		$Decrypt4.update()


