extends Node

# The dictionary with the key
var dict = {}
# The dictionary inversed
var dictinv = {}


func init(characters):
	# Fill the dictionary
	for i in characters.length():
		dict[characters[i]] = characters[i]
	# Copy
	dictinv = dict.duplicate()


# ----------------------------------------------------------------
func set_character(key, value):
	# Set the key to the new value and move the old value...
	# Example:
	# dict: a=b, b=c, c=d, d=a
	# dictinv: a=d, b=a, c=b, d=c
	
	# Call with: key=a, value=d
	
	# oldvalue = b
	var oldvalue = dict[key]
	# dict: a=d, b=c, c=d, d=a
	dict[key] = value
	# dict: a=d, b=c, c=b, d=a
	dict[dictinv[value]] = oldvalue
	
	# dictinv: a=d, b=a, c=b, d=c
	#         a=d, b=c, c=b, d=a
	# oldinvvalue = c
	var oldinvvalue = dictinv[value]
	# a=d, b=a, c=b, d=a
	dictinv[value] = key
	dictinv[oldvalue] = oldinvvalue
# ----------------------------------------------------------------
