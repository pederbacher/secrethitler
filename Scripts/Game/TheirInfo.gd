extends VBoxContainer

var allHCs = []




func _ready():
	var iteam
	var playerIndex
	var vc
	var sub
	var hc
	var score
	var container
	
	## A HC/HC (Score labels) for each team
	for ii in D.nTeams-1:
		$VC/HC.add_child($VC/HC/HC.duplicate())
	## A HC for each team
	for ii in D.nTeams-1:
		self.add_child($VC.duplicate())
	
	# Duplicate to fill in
	for ii in D.nTeams:
		vc = self.get_child(ii+1) # +1 because of label
		# If the first one: subtract 1 because there already is one in the first
		for i in G.playersOnTeamOrdered[G.orderTeams[ii]].size():
			# Don't add if the first (it's already there)
			if i == 0:
				# Just the first hc as the already existing
				hc = vc.get_child(0)
			else:
				hc = $VC/HC.duplicate()
				vc.add_child(hc)
			# Keep ref to the hc to later iterate through
			allHCs.append(hc)
			# Now add the score labels
			if i == 0:
				for iii in D.nPlayers:
					if iii == 0:
						score = hc.get_child(2).get_child(0)
					else:
						score = hc.get_child(2).get_child(0).duplicate()
						hc.get_child(2).add_child(score)
		# Add space below if not the last one
		if ii < D.nTeams - 1:
			container = Container.new()
			container.rect_min_size = Vector2(0,10)
			vc.add_child(container)
	
	# Fill texts and scores
	for i in D.nPlayers:
		# Which player
		playerIndex = G.playersOrdered[i]
		hc = allHCs[i]
		# Connect to the changed function
		hc.get_child(1).connect("text_changed", self, "_on_TextEdit_text_changed", [i])
		# Set the color of the button
		hc.get_child(0).modulate = D.colors[D.playerColorIndex[playerIndex]]
		# Set the texts
		if i == 0:
			hc.get_child(1).text = D.playerCharacterName[G.playerIndex]
			hc.get_child(1).readonly = true
		else:
			hc.get_child(1).text = D.characterNameGuesses[G.playerIndex][playerIndex]
		# Set the scores (empty if it's the same player)
		for ii in D.nPlayers:
			score = hc.get_child(2).get_child(ii)
			if G.playersOrdered[ii] == playerIndex:
				score.text = ""
			else:
				score.text = str(round(D.characterNameGuesses[G.playersOrdered[ii]][playerIndex].similarity(D.playerCharacterName[playerIndex])*100))
			if ii > 0:
				score.add_color_override("font_color", D.colors[D.playerColorIndex[G.playersOrdered[ii]]])



func _on_TextEdit_text_changed(i):
	var guess = allHCs[i].get_child(1).text
	var forplayerIndex = G.playersOrdered[i]
	# Update the score field (the hcs only needed for this player)
	allHCs[i].get_child(2).get_child(0).text = str(round(guess.similarity(D.playerCharacterName[forplayerIndex])*100))
	# Save and update on all
	rpc("_save_on_all", G.playerIndex, guess, forplayerIndex)



remote func _save_on_all(playerIndex, guess, forplayerIndex):
	# Keep the guess
	D.characterNameGuesses[playerIndex][forplayerIndex] = guess
	# Update the text fields with score for the player
	var ii = G.playersOrdered.find(playerIndex)
	var i = G.playersOrdered.find(forplayerIndex)
	allHCs[i].get_child(2).get_child(ii).text = str(round(guess.similarity(D.playerCharacterName[forplayerIndex])*100))
		
		
	# Go through all
#	for i in allHCs.size():
#		similarity(
#
#		D.  allHCs[i].get_child(1).text
#		val = D.playerCharacterName[)
#		allHCs[i].get_child(2).text = str(val)
##		val = D.playerCharacterName[G.selectedPlayerIndex].similarity($HB/VB1/TextEdit.text)
