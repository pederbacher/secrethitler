tool
extends TextEdit



func _enter_tree():
    connect("text_changed", self, "clicked")

func clicked():
    print("You clicked me!")