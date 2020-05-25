extends Node

# ----------------------------------------------------------------
# Data needed for the game, but only for this session, hence not stored in D
# The playerIndex for the peer player
var playerIndex = -1

# The order of players, where the peer player is the first
var orderPlayers
# The order of teams, where the peer players team is the first, and then according to the other teams first players order in orderPlayers
var orderTeams
# An array with an array for each team, ordered according to orderPlayers 
# Keeps the order of the buttons on the left, so one for each player divided in teams, with peer player first
# Generated with orderPlayersSorter, see below
var playersOnTeamOrdered = []
## The order of the players in playersOnTeamOrdered in a single array (i.e. the order of the players in the left column)
var playersOrdered = []
# ----------------------------------------------------------------


# ----------------------------------------------------------------
# More variables used during the game
var current_scene = null

# Network related variables
var serverIP = ""

# The current selected playerIndex (the left buttons through G.order)
var selectedPlayerIndex = 1
# ----------------------------------------------------------------


# ----------------------------------------------------------------
# Character name suggestions (should be read from file etc.)
var characterNameSuggestions = ["kugleven","flyvebente","colajoe","kaptajnen","bilisten","flipperen"]
var iListCNS = []
var iNextCNS = 0

# ----------------------------------------------------------------

# Called when the node enters the scene tree for the first time.
func _ready():
	# For scene loading
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)
	
	# Suggestions for character names index vector
#	randomize()
	for i in characterNameSuggestions.size():
		iListCNS.append(i)
#	iListCNS.shuffle()
	
	#VisualServer.set_default_clear_color(Color(0.4, 0.1, 0.4))


func get_another_characterName():
	# Take the next (random) name from the list
	iNextCNS = (iNextCNS + 1)
	var val
	if iNextCNS < characterNameSuggestions.size():
		val = characterNameSuggestions[iListCNS[iNextCNS-1]]
	else:
		val = "No more suggestions available, make up a name yourself"
	return(val)


# --------------------------------------------------------
func goto_scene(path):
	# This function will usually be called from a signal callback,
	# or some other function in the current scene.
	# Deleting the current scene at this point is
	# a bad idea, because it may still be executing code.
	# This will result in a crash or unexpected behavior.
	#
	# The solution is to defer the load to a later time, when
	# we can be sure that no code from the current scene is running:
	call_deferred("_deferred_goto_scene", path)


func _deferred_goto_scene(path):
	# It is now safe to remove the current scene
	current_scene.free()
	
	# Load the new scene.
	var s = ResourceLoader.load(path)
	
	# Instance the new scene.
	current_scene = s.instance()
	
	# Add it to the active scene, as child of root.
	get_tree().get_root().add_child(current_scene)
	
	# Optionally, to make it compatible with the SceneTree.change_scene() API.
	get_tree().set_current_scene(current_scene)
# --------------------------------------------------------


# --------------------------------------------------------
# For sorting playerIndeds in an array on order: give sort to sort_custom on the array of playerIndexes
# e.g. [1,3].sort_custom(G.orderPlayersSorter, "sort")
class orderPlayersSorter:
	static func sort(iplayer1,iplayer2):
		# return who is first in G.orderPlayers
		if G.orderPlayers.find(iplayer1) < G.orderPlayers.find(iplayer2):
			return true
		else:
			return false
# --------------------------------------------------------



# --------------------------------------------------------
# Function for randomize permutation (sampling without replacement)
func sample(x):
	var x_start = x
	var irnd = 0
	var val = 0
	for i in x.length():
		irnd = randi()%x.length()
		val = x[i]
		x[i] = x[irnd]
		x[irnd] = val
	var notok = true
	# Some are ended on the same place, move them randomly again
	while notok:
		notok = false
		for i in x.length():
			if x[i] == x_start[i]:
				irnd = randi()%x.length()
				val = x[i]
				x[i] = x[irnd]
				x[irnd] = val
				notok = true
	return(x)
# --------------------------------------------------------
