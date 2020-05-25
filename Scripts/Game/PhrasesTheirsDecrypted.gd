extends TextEdit

func update():
	# Decrypt the phrases with Theirs key
	# Flip the key
	var phrase = Code.theirtexts[G.selectedPlayerIndex].to_upper()
	# The use the inverse key to decrypt with
	for i in phrase.length():
			if phrase[i].is_subsequence_ofi(Code.chars_cons):
				phrase[i] = Code.cons[G.playerIndex][G.selectedPlayerIndex].dictinv[phrase[i]]
			else:
				if phrase[i].is_subsequence_ofi(Code.chars_vows):
					phrase[i] = Code.vows[G.playerIndex][G.selectedPlayerIndex].dictinv[phrase[i]]
				else :
					if phrase[i].is_subsequence_ofi(Code.chars_spcs):
						phrase[i] = Code.spcs[G.playerIndex][G.selectedPlayerIndex].dictinv[phrase[i]]
	self.text = phrase.to_lower()
	Code.theirtexts_decrypted[G.selectedPlayerIndex] = self.text
