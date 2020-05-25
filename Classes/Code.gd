extends Node

# The groups of letters
var letterGroups = Dictionary()
var letters = ""

# To keep the keys in list of dictionaries: looked up by playerIndex
var keys = []
# The keys for the other players (the keys my player keeps for the others are in theirskeys[G.playerIndex][other.playerIndex])
var theirskeys = []
# Which symbols has been disclosed to each player
var disclosed = []
# Which symbols was altered
var altered = []

# Holding the texts (make it synced with rpc and filled the right amount when initialized)
var theirtexts = ["", "", "", "", "", "", "", ""]
var theirtexts_decrypted = ["", "", "", "", "", "", "", ""]


# --------------------------------------------------------
func _ready():
	# Define the groups of letters
	letterGroups["cons"] = "BDFGHJKLMNPRSTV"
	letterGroups["spcs"] = "CQZX"
	letterGroups["vows"] = "AEIOUYÆØÅ"
	# Keep the letters in one string
	for i in letterGroups.size():
		letters = letters + letterGroups.values()[i]
	# The Key objects for their keys
	var newlist
	var key
	for i in D.nMaxPlayers:
		newlist = []
		for ii in D.nMaxPlayers:
			key = load('res://Classes/Key.tscn').instance()
			key.init(letters)
			newlist.append(key)
		theirskeys.append(newlist)
		#
		# The disclosed is dictionaries of bools
		newlist = []
		var dict
		for ii in D.nMaxPlayers:
			dict = Dictionary()
			for i in letters.length():
				dict[letters[i]] = false
			newlist.append(dict)
		disclosed.append(newlist)

		# The altered is dictionaries of bools
		newlist = []
		for ii in D.nMaxPlayers:
			dict = Dictionary()
			for i in letters.length():
				dict[letters[i]] = false
			newlist.append(dict)
		altered.append(newlist)
# --------------------------------------------------------


# ----------------------------------------------------------------
# Encrypt a text
func encrypt(text, playerIndex, selectedPlayerIndex):
	text = text.to_upper()
	# Use the real key?
	if playerIndex == selectedPlayerIndex:
		# Use the dict in keys to encrypt with
		for i in text.length():
			if text[i].is_subsequence_ofi(letters):
				text[i] = keys[playerIndex][text[i]]
	else:
		# Use the key to encrypt with
		for i in text.length():
			if text[i].is_subsequence_ofi(letters):
				text[i] = theirskeys[playerIndex][selectedPlayerIndex].dict[text[i]]
	#
	return(text.to_lower())
# ----------------------------------------------------------------


# ----------------------------------------------------------------
# Decrypt a text
func decrypt(text, playerIndex, selectedPlayerIndex):
	text = text.to_upper()
	# Use the inverse key to decrypt with
	for i in text.length():
		if text[i].is_subsequence_ofi(letters):
			text[i] = theirskeys[playerIndex][selectedPlayerIndex].dictinv[text[i]]
	#
	return(text.to_lower())
# ----------------------------------------------------------------


# ----------------------------------------------------------------
func generate():
	# The keys are only generated at the server 
	# (the peers will call and get them and fill them in their Code, they have to get each key, since class cannot be send via RPC)
	randomize()
	# Generate the codes
	var lettersRnd = ""
	var dict
	for i in D.nMaxPlayers:
		dict = Dictionary()
		# Permutate each group
		for i in letterGroups.size():
			lettersRnd = lettersRnd + G.sample(letterGroups.values()[i])
		for i in letters.length():
			dict[letters[i]] = lettersRnd[i]
		keys.append(dict)
# --------------------------------------------------------


# --------------------------------------------------------
# Check that the key and value both belong to same letter gruop
func in_same_lettergroup(key, value):
	# Check that both key and value belong to the same groups
	var ok = false
	for i in letterGroups.size():
		if key.is_subsequence_ofi(letterGroups.values()[i]) and value.is_subsequence_ofi(letterGroups.values()[i]):
			ok = true
			break
	return(ok)
# --------------------------------------------------------


# --------------------------------------------------------
# Set a key in playerIndex code for selectedPlayerIndex
func set_key(key, value, playerIndex, selectedPlayerIndex):
	# Work in upper case
	key = key.to_upper()
	value = value.to_upper()
	
	if in_same_lettergroup(key, value):
		# Set the key
		var disclosed
		var keyforvalue
		#
		# If the value has already been disclosed as a correct value, then don't set it
		keyforvalue = theirskeys[playerIndex][selectedPlayerIndex].dictinv[value]
		disclosed = Code.disclosed[playerIndex][selectedPlayerIndex]
		if not disclosed[key]:
			if not disclosed[keyforvalue]:
				# Set on the other peers
				rpc("_set_theirkey", key, value, playerIndex, selectedPlayerIndex)
				# Set locally (in order to gui update right after)
				_set_theirkey(key, value, playerIndex, selectedPlayerIndex)
				

# Change a key character value, if not disclosed and if value as not been
remote func _set_theirkey(key, value, playerIndex, selectedPlayerIndex):
	theirskeys[playerIndex][selectedPlayerIndex].set_character(key, value)
	# Remember that it is altered
	altered[playerIndex][selectedPlayerIndex][key] = true
	# Don't think anything needs update here, it's only the player doing it that needs update
#	# Should here find the name of the childs, instead of indexes (which will fail when changed)
#	var current_scene = get_tree().get_current_scene()
#	current_scene.get_child(0).get_child(0).get_child(1).get_child(3).update()
#	current_scene.get_child(0).get_child(0).get_child(1).get_child(4).update()
#	current_scene.get_child(0).get_child(0).get_child(1).get_child(5).update()
# ----------------------------------------------------------------


# ----------------------------------------------------------------
# Disclose and set a character
func disclose_and_set_key(key, value, playerIndex, selectedPlayerIndex):
	# Work in upper case
	key = key.to_upper()
	value = value.to_upper()
	#
	if in_same_lettergroup(key, value):
		rpc("_disclose", key, value, playerIndex, selectedPlayerIndex)


remotesync func _disclose(key, value, playerIndex, selectedPlayerIndex):
	theirskeys[selectedPlayerIndex][playerIndex].set_character(key, value)
	disclosed[selectedPlayerIndex][playerIndex][key] = true
	# Should here find the name of the childs, instead of indexes (which will fail when changed)
	var current_scene = get_tree().get_current_scene()
	current_scene.get_child(0).get_child(0).get_child(1).get_child(3).update()
	current_scene.get_child(0).get_child(0).get_child(1).get_child(4).update()
	current_scene.get_child(0).get_child(0).get_child(1).get_child(5).update()
# ----------------------------------------------------------------



# ################################################################
# Make a full disclose from one to another player
# ----------------------------------------------------------------
func share_keys_and_full_disclose(playerIndex, selectedPlayerIndex):
	rpc("_share_keys_and_full_disclose", playerIndex, selectedPlayerIndex)

remotesync func _share_keys_and_full_disclose(playerIndex, selectedPlayerIndex):
	# Just copy the key (they all have every others keys)
	keys[selectedPlayerIndex] = keys[playerIndex]
	for key in letters:
		## Set and disclose one way
		theirskeys[selectedPlayerIndex][playerIndex].set_character(key, keys[playerIndex][key]) # don't know if player or selected player should be here, but when shared keys_cons, then it doesn't matter
		disclosed[selectedPlayerIndex][playerIndex][key] = true
		## Set and disclose the other way
		theirskeys[playerIndex][selectedPlayerIndex].set_character(key, keys[playerIndex][key]) # don't know if player or selected player should be here, but when shared keys_cons, then it doesn't matter
		disclosed[playerIndex][selectedPlayerIndex][key] = true
	# This is sketchy, if changes in structure it maybe must be updated
	# Update the dependent gui
#	var current_scene = get_tree().get_current_scene()
#	current_scene.get_child(0).get_child(0).get_child(1).get_child(3).update()
#	current_scene.get_child(0).get_child(0).get_child(1).get_child(5).update()
# ################################################################



# --------------------------------------------------------
# For sending the true keys via rpc (only done from server to all peers once)
func get_info():
	# Return a dictionary holding all the information
	var info = {}
	# The true keys (only these values are send, the others key arrays hold the key class, which cannot be send directly over rpc, so the values are set in other functions instead)
	info["keys"] = keys
	info["disclosed"] = disclosed
	return(info)

func init(info):
	# Set with dictionary holding all the information
	keys = info["keys"]
	disclosed = info["disclosed"]
# --------------------------------------------------------
