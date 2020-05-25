tool
extends TextEdit

# separator symbol used
var separator = "|"

#
var cursorCol
var cursorLine = 0

var phrase = ""

var oneLineOnly = false


func _enter_tree():
#	connect("text_changed", self, "_on_text_changed")
	connect("cursor_changed", self, "_on_cursor_changed")
	self.syntax_highlighting = true
	self.add_color_override("font_color", Color(1,0.5,0.5))


func set_color(Code, playerIndex, selectedPlayerIndex):
	self.clear_colors()
	for i in range(Code.letters.length()):
		if Code.altered[G.playerIndex][G.selectedPlayerIndex].values()[i]:
			self.add_keyword_color(Code.letters[i].to_lower(), Color(0.5,0.5,1))
		if Code.disclosed[G.playerIndex][G.selectedPlayerIndex].values()[i]:
			self.add_keyword_color(Code.letters[i].to_lower(), Color(0.5,1,0.5))


func insert_separator(text):
	var newtext = text + text
	for i in text.length():
		newtext[i*2] = text[i]
		newtext[i*2+1] = separator
	return(newtext)


func update_code_on_text_change(Code, playerIndex, selectedPlayerIndex):
	# if it's one line more than one line: Don't do any change
	if oneLineOnly and "\n" in self.text:
		self.text = self.text.split("\n")[0]
		self.cursor_set_line(0)
		self.cursor_set_column(cursorCol)
	else:
		# Keep the cursor position
		var currentLine = self.cursor_get_line()
		var currentCol = self.cursor_get_column()
		# Remove the separator
		#var tmp = self.text.replace(separator,"")
		# Is it exactly one character added
		if currentCol-1 == cursorCol and currentCol < self.get_line(currentLine).length():
			# Do the replacement of the letters
			# Find the letter that was changed
			var key = self.get_line(currentLine)[currentCol-1]
			# Go and find the value from the previous the Code
			var value = Code.encrypt(self.get_line(currentLine)[currentCol], playerIndex, selectedPlayerIndex)#text[floor(currentCol/2)]
			# Exchange them in the key
			Code.set_key(key, value, playerIndex, selectedPlayerIndex)
		self.cursor_set_line(currentLine)


func _on_cursor_changed():
	var currentLine = self.cursor_get_line()
	var currentCol = self.cursor_get_column()
	if cursorCol == (currentCol - 1):
		self.cursor_set_column(currentCol + 1)
	else: 
		if cursorCol == (currentCol + 1):
			self.cursor_set_column(currentCol - 1)
	# Always set it even
	self.cursor_set_column(floor(self.cursor_get_column()/2)*2)
	self.cursor_set_line(currentLine)
	cursorLine = currentLine
	cursorCol = self.cursor_get_column()
