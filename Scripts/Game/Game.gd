extends Node

var restartAsServer

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().connect("network_peer_disconnected",self,"_on_network_peer_disconnected")
	get_tree().connect("network_peer_connected",self,"_on_network_peer_connected")
	get_tree().connect("server_disconnected",self,"_on_server_disconnected")
#
#func _notification(what):
#	if what == MainLoop.NOTIFICATION_WM_FOCUS_OUT or what == MainLoop.NOTIFICATION_WM_UNFOCUS_REQUEST:
#		# Remember if was server, then we need to restart it when back
#		restartAsServer = get_tree().is_network_server()
#		# MÅSKE BRUGBART? get_tree().network_peer.get_connection_status()
#		# Disconnect en enkelt (bare close disconnecter alle hvis det er server): get_tree().disconnect_network_peer(id)
#		get_tree().network_peer.close_connection()
#		# End the connection
##		get_tree().set_network_peer(null)
#		# Pause other things
##		get_tree().paused = true
#		# Show the popup
#		if restartAsServer:
#			$PausePopup/Button.text = "Press to restart the server, then the other players can reconnect."
#		else:
#			$PausePopup/Button.text = "Press to reconnect to the server."
#		$PausePopup.show()

# ----------------------------------------------------------------
# What to do when disconnections occur?
func _on_server_disconnected():
	# On clients when the server disconnects
	restartAsServer = false
#	get_tree().paused = true
	$PausePopup/Button.text = "The server disconnected, wait until it restarts, then press connect to reconnect."
	$PausePopup.show()


func _on_network_peer_disconnected(id):
#	if not get_tree().is_network_server():
#		get_tree().network_peer.close_connection()
#	restartAsServer = false
	# On all peers when a client disconnects (except the one that disconnected)
#	get_tree().paused = true
#	if get_tree().is_network_server():
#		$PausePopup/Button.text = "You are the server, game is paused. Press to resume."
#	else:
	$PausePopup/Button.text = "Another peer disconnected, wait until it reconnects."
	$PausePopup.show()


func _on_network_peer_connected(id):
	$PausePopup.hide()
	print("antal connected peers" + String(get_tree().get_network_connected_peers().size()))
	if get_tree().get_network_connected_peers().size() == D.nPlayers:
		$PausePopup.hide()

# ----------------------------------------------------------------


func _on_Button_pressed():
	var peer = NetworkedMultiplayerENet.new()
#	if not get_tree().is_network_server():
	if restartAsServer:
		peer.create_server(8003, 4)
		get_tree().set_network_peer(peer)
		get_tree().set_meta("network_peer", peer)
	else:
		peer.create_client(G.serverIP, 8003)
		get_tree().set_network_peer(peer)
		get_tree().set_meta("network_peer", peer)
#	get_tree().paused = false
	$PausePopup.hide()


func _on_Disconnect_pressed():
	restartAsServer = get_tree().is_network_server()
	get_tree().network_peer.close_connection()
	$PausePopup/Button.text = "You disconnected, Press to connect again"
	$PausePopup.show()
	
	

