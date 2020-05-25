extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	# Connect network signals to functions here
#	get_tree().connect("network_peer_disconnected",self,"_on_network_peer_disconnected")
#	get_tree().connect("server_disconnected",self,"_on_server_disconnected")
	#
	# !!debug: create a random playername
	#randomize()
	#$C/PlayerSetup/Settings/PlayerName.text = G.sample("abcdefg")
	# debugend
	
	$C/PlayerSetup/Info/GameIP.text = G.serverIP
	# Load all the players from the server
	# Eventually, it could be nessecary to wait, somehow, until the playes were added (if any players were there)
	#   otherwise the players cannot be checked, e.g. multiple playerids can be added
	
	if get_tree().is_network_server():
		# Init the game 
		D.init_new_game_on_server()
		Code.generate()
		$C/PlayerSetup/Settings/Color.update()
	else:
		# Request the code object from the server
		rpc_id(1, '_request_code', get_tree().get_network_unique_id())
		# Request the gdata object from the server
		rpc_id(1, '_request_D', get_tree().get_network_unique_id())
		# Hide tabs
		$C.set_tab_disabled(1,true)
		$C.set_tab_title(1, "")
		$C.set_tab_disabled(2,true)
		$C.set_tab_title(2, "")


# ----------------------------------------------------------------
# What to do when disconnections occur?
# Not yet found out...
#func _on_server_disconnected():
#	# On a client when the server disconnects
#	get_tree().paused = true
#
#func _on_network_peer_disconnected(id):
#	# On the server when a client disconnects
#	get_tree().paused = true
# ----------------------------------------------------------------


# ----------------------------------------------------------------
# Communicate the code
remote func _request_code(requestFromID):
	# Send the code
	rpc_id(requestFromID, "_add_code", Code.get_info())

remote func _add_code(info):
	Code.init(info)
# ----------------------------------------------------------------


# ----------------------------------------------------------------
# Communicate the code
remote func _request_D(requestFromID):
	# Send the code
	rpc_id(requestFromID, "_add_D", D.get_info())

# Communicate D
remote func _add_D(info):
	D.init(info)
	$C/PlayerSetup/Settings/Color.update()
# ----------------------------------------------------------------


# ----------------------------------------------------------------
func _on_CheckPlayers_pressed():
	var characters = []
	for i in D.playerName.size():
		characters.append(D.playerName[i])
	$C/GameStart/Info/Players.text = PoolStringArray(characters).join("\n")
	characters = []
	for i in D.playerName.size():
		characters.append(D.colors[D.playerColorIndex[i]])
	$C/GameStart/Info/Color2.text = PoolStringArray(characters).join("\n")
# ----------------------------------------------------------------


# ----------------------------------------------------------------
func _on_startGame_pressed():
	# Only the server has the button to start the game
	if not D.playerName.size() == D.nPlayers:
		$C/GameStart/Go/Message.text = "Exactly " + str(D.nPlayers) + " players must be saved to the game before it can start"
	else:
		# Start the game
		rpc("_join_game")


# Called on each peer when starting the game
remotesync func _join_game():
	
	# Find the order to make the left buttons: Put this peer player first
	# I.e. in G.orderPlayers the players are ordered like in D.orderPlayers, just starting out from the peer player (G.playerIndex)
	var order = D.orderPlayers.duplicate()
	# Find the position of the peer player
	var iplayer
	iplayer = order.find(G.playerIndex)
	# Make order with this peer player first
	#slice() in 3.2: G.orderPlayers = orderPlayers[iplayer:...:(orderPlayers.size()-1)] + orderPlayers.slice(0,iplayer-1)
	G.orderPlayers = order.duplicate()
	for i in order.size():
		G.orderPlayers[i] = order[(iplayer+i) % order.size()]
	
	# Set the order of the teams according to the peer player
	G.orderTeams = []
	for i in G.orderPlayers:
		# Is the team already added?
		if G.orderTeams.find(D.playerTeam[i]) == -1:
			# Not there, so added it
			G.orderTeams.append(D.playerTeam[i])
	
	G.selectedPlayerIndex = G.orderPlayers[0]
	
	# Set the order of the buttons for selecting player on the left
	G.playersOnTeamOrdered = D.get_players_on_teams()
	G.playersOrdered = []
	var iteam
	for ii in D.nTeams:
		iteam = G.orderTeams[ii]
		# Order the players on the team according to G.orderPlayers
		G.playersOnTeamOrdered[iteam].sort_custom(G.orderPlayersSorter,"sort")
		for i in G.playersOnTeamOrdered[iteam].size():
			G.playersOrdered.append(G.playersOnTeamOrdered[iteam][i])
	
	G.goto_scene("res://Game.tscn")
	
	## Do the game start init: make teams and share their keys
	if get_tree().is_network_server():
		D.on_game_start_on_server()
# ----------------------------------------------------------------