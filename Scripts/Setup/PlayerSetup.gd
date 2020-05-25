extends HBoxContainer

func _ready():
	_on_GetAnother_pressed()

# ----------------------------------------------------------------
func _on_SaveToGame_pressed():
	$Info/Message.text = ""
	var info = {}
	# Player related
	info["name"] = $Settings/PlayerName.text
	# Game related
	info["colorIndex"] = $Settings/Color.selectedColor
	# Character related
	info["characterName"] = $Settings/CharacterName.text
	# Check fields
	if $Settings/PlayerName.text == "":
		$Info/Message.text = "PlayerName cannot be empty"
		return
#	if $C/C/C2/CharacterName.text == "":
#		$C/C/C3/Message.text = "CharacterName cannot be empty"
#		return
	
	# Check if the playerName is in use
	if D.dict_playerIndex_for_playerName().has($Settings/PlayerName.text):
		# Check if it's another player
		if D.dict_playerIndex_for_playerName()[$Settings/PlayerName.text] != G.playerIndex:
			# Here check if that other player is not in the game anymore, and then allow to take over
			#   checking the currently connected peers 
			$Info/Message.text = "Player Name is already in use by other player"
			return
	
	# if G.playerIndex was not yet set, it will be -1 and a new player will be added by the server, otherwise updated
	if not get_tree().is_network_server():
		rpc_id(1, "_request_add_player", info, get_tree().get_network_unique_id(), G.playerIndex)
	else:
		_request_add_player(info, get_tree().get_network_unique_id(), G.playerIndex)
	$Info/Message.text = "Added (or updated) player"
# ----------------------------------------------------------------


# ----------------------------------------------------------------
# Player handling
remote func _request_add_player(info, networkID, playerIndex):
	# Now add (or update) the player on all peers
	rpc('_add_player', info, networkID, playerIndex)

remotesync func _add_player(info, networkID, playerIndex):
	if playerIndex == -1:
		# New player
		D.playerName.append(info["name"])
		D.playerCharacterName.append(info["characterName"])
		D.playerColorIndex.append(info["colorIndex"])
		playerIndex = D.playerName.size() - 1
		# If it was the peer calling, then keep the playerIndex for the session
		if networkID == get_tree().get_network_unique_id():
			G.playerIndex = playerIndex
	else:
		# Update the player
		D.playerName[playerIndex] = info["name"]
		D.playerCharacterName[playerIndex] = info["characterName"]
		D.playerColorIndex[playerIndex] = info["colorIndex"]
# ----------------------------------------------------------------


# ----------------------------------------------------------------
# Get another characterName from the server
func _on_GetAnother_pressed():
	if get_tree().is_network_server():
		_set_characterName(G.get_another_characterName())
	else:
		rpc_id(1, "_request_characterName", get_tree().get_network_unique_id())

remote func _request_characterName(requestFromID):
	# Send a new characterName
	rpc_id(requestFromID, "_set_characterName", G.get_another_characterName())

remote func _set_characterName(newName):
	$Settings/CharacterName.text = newName
# ----------------------------------------------------------------
