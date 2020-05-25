tool
extends TextEdit

# separator symbol used
var separator = "|"

#
#
var cursorCol
var cursorLine = 0

var phrase = ""

var oneLineOnly = false


func _enter_tree():
	connect("text_changed", self, "_on_text_changed")
	connect("cursor_changed", self, "_on_cursor_changed")
	self.syntax_highlighting = true
	self.add_color_override("font_color", Color(1,0.5,0.5))



func set_color(Code, playerIndex, selectedPlayerIndex):
	self.clear_colors()
	for i in range(Code.letters.length()):
		if Code.altered[playerIndex][selectedPlayerIndex].values()[i]:
			self.add_keyword_color(Code.encrypt(Code.letters[i], playerIndex, selectedPlayerIndex), Color(0.75,0,75,1))
		if Code.disclosed[playerIndex][selectedPlayerIndex].values()[i]:
			self.add_keyword_color(Code.encrypt(Code.letters[i], playerIndex, selectedPlayerIndex), Color(0.75,1,0.75))


func insert_separator(text):
	var newtext = text + text
	for i in text.length():
		newtext[i*2] = text[i]
		newtext[i*2+1] = separator
	return(newtext)


func _on_text_changed():
	# if it's one line more than one line: Don't do any change
	if oneLineOnly and "\n" in self.text:
		self.text = insert_separator(phrase)
		self.cursor_set_line(0)
		self.cursor_set_column(cursorCol)
	else:
		var lastlen = phrase.length()
		# Keep the cursor position
		var currentLine = self.cursor_get_line()
		#
		var currentCol = self.cursor_get_column()
		# Remove the separator
		phrase = self.text.replace(separator,"")
		if phrase.length() == lastlen:
			# It was a delete
			var tmp = self.text
			tmp.erase(currentCol-1,1)
			phrase = tmp.replace(separator,"")
		# Insert the separator
		self.text = insert_separator(phrase)
		# Set the cursor position
		cursorLine = currentLine
		self.cursor_set_line(currentLine)
		self.cursor_set_column(currentCol)


func _on_cursor_changed():
	var currentLine = self.cursor_get_line()
	var currentCol = self.cursor_get_column()
	if cursorCol == (currentCol - 1):
		self.cursor_set_column(currentCol + 1)
		if self.is_selection_active():
			if self.get_selection_from_column() > 0:
				self.select(1,self.get_selection_from_column(),1,self.get_selection_to_column()+1)
	else: 
		if cursorCol == (currentCol + 1):
			self.cursor_set_column(currentCol - 1)
		if self.is_selection_active():
			if self.get_selection_from_column() > 0:
				self.select(1,self.get_selection_from_column()-1,1,self.get_selection_to_column())
	# Always set it even
	cursorLine = currentLine
	self.cursor_set_column(floor(self.cursor_get_column()/2)*2)
	cursorCol = self.cursor_get_column()
