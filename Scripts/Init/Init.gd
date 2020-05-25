extends HBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	# Connect network signals to functions here
	get_tree().connect("connection_failed",self,"_on_connection_failed")
	get_tree().connect("connected_to_server",self,"_on_connected_to_server")
	# !! debug: set to 127...
	$VC2/IP.text = '192.168.1.'#'127.0.0.1' # IP.get_local_addresses()[1]
	# Find the relevant IP addresses
	var regex = RegEx.new()
	regex.compile("^127|^192")#((127\\.)|(10\\.)|(172\\.1[6-9]\\.)|(172\\.2[0-9]\\.)|(172\\.3[0-1]\\.)|(192\\.168\\.))")
	var x = IP.get_local_addresses()
	for i in x.size():
		if regex.search(x[i]) != null:
			$VC2/LanIPs.add_item(x[i])
	$VC2/LanIPs.select(0)

# --------------------------------------------------------
# Here network management
func _on_connection_failed():
	$VC1/Message.text = "Connection failed"

func _on_connected_to_server():
	$VC1/Message.text = "Connection successful"
	G.goto_scene("res://Setup.tscn")
# --------------------------------------------------------


func _on_CreateGame_pressed():
	G.serverIP = $VC2/LanIPs.get_item_text($VC2/LanIPs.get_selected_items()[0])
	# Init server
	var peer = NetworkedMultiplayerENet.new()
	#peer.set_bind_ip(G.serverIP)
	peer.create_server(8003, 4)
	get_tree().set_network_peer(peer)
	get_tree().set_meta("network_peer", peer)
	G.goto_scene("res://Setup.tscn")


func _on_JoinGame_pressed():
	# Init client and connection to server
	$VC1/Message.text = "Connecting to " + $VC2/IP.text
	G.serverIP = $VC2/IP.text
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client($VC2/IP.text, 8003) # 
	get_tree().set_network_peer(peer)
	get_tree().set_meta("network_peer", peer)


func _on_SetIPto127_pressed():
	$VC2/IP.text = '127.0.0.1'

func _on_SetIPto192_pressed():
	$VC2/IP.text = '192.168.1.'
