extends Node

# Member variables:

# Constants, only on server:
# Number of max players (length of code arrays etc.)
var nMaxPlayers = 8

## ----------------------------------------------------------------
# Gamesettings (set only by the server, but updated on all peers):

# Number of players in current game
var nPlayers = 4
var nTeams = 2

# Functionalities:
var shareDisclosedInTeam = true # Control if a key which is disclosed are disclosed to the other players team or individually
## ----------------------------------------------------------------


## ----------------------------------------------------------------
# Data for game
# Order of the players in the game (their playerIndex)
# !!must be made according to number of players and able to edit
var orderPlayers = []

# These are the colors, simply an Array of colors
var colors = []
var isColorFree = []
## ----------------------------------------------------------------


# ----------------------------------------------------------------
# For each player an array with the guesses of character name
var characterNameGuesses = []
# ----------------------------------------------------------------


## ----------------------------------------------------------------
# Player related (looked up with playerIndex
var playerName = []

var playerCharacterName = []

var playerColorIndex = []
# An integer for each indicating the team
var playerTeam = []
## ----------------------------------------------------------------


func _read():
	# ONLY FOR DEBUG
	init_new_game_on_server()

func init_new_game_on_server():
	# This is carried out on the server, and each peer joining the server will request the needed data after this
	
	# Re-init these
	orderPlayers = []
	isColorFree = []
	colors = []
	playerTeam = []
	characterNameGuesses = []
	
	#
	var tmp = []
	
	for i in nPlayers:
		# Set the colors in colors
		colors.append(Color.from_hsv(float(i)/6, 0.8, 0.8, 1))#grad.interpolate()
		isColorFree.append(true)
		#
		orderPlayers.append(i)
		#
		tmp = []
		for ii in nPlayers:
			tmp.append("")
		characterNameGuesses.append(tmp)
	
	# Make the teams
	for i in nTeams:
		for ii in nPlayers/nTeams:
			playerTeam.append(i)
	playerTeam.shuffle()


# When loading the game scene, this is run on the server
func on_game_start_on_server():
	# Share and disclose the key between players in the team
	for i in nPlayers:
		for ii in nPlayers:
			if playerTeam[i] == playerTeam[ii] and i < ii:
				# Same team so share their codekey (this is done once, i.e. for i < ii)
				Code.share_keys_and_full_disclose(i, ii)


# --------------------------------------------------------
# For sending all needed fields the values via rpc 
func get_info():
	# Return a dictionary holding all the information
	var info = {}
	info["nPlayers"] = nPlayers
	info["orderPlayers"] = orderPlayers
	info["colors"] = colors
	info["isColorFree"] = isColorFree
	info["playerName"] = playerName
	info["playerCharacterName"] = playerCharacterName
	info["playerColorIndex"] = playerColorIndex
	info["playerTeam"] = playerTeam
	info["characterNameGuesses"] = characterNameGuesses
	return(info)

func init(info):
	# Set with dictionary holding all the information
	nPlayers = info["nPlayers"]
	orderPlayers = info["orderPlayers"]
	colors = info["colors"]
	isColorFree = info["isColorFree"]
	playerName = info["playerName"]
	playerCharacterName = info["playerCharacterName"]
	playerColorIndex = info["playerColorIndex"]
	playerTeam = info["playerTeam"]
	characterNameGuesses = info["characterNameGuesses"]
# --------------------------------------------------------


func dict_playerIndex_for_playerName():
	var val = {}
	for i in playerName.size():
		val[playerName[i]] = i
	return(val)


func get_players_on_teams():
	# Return an array
	var val = []
	var team
	for ii in nTeams:
		team = []
		for i in playerTeam.size():
			if playerTeam[i] == ii:
				team.append(i)
		val.append(team)
	return(val)
