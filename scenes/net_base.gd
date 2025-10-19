extends StaticBody2D
class_name NetBase



var net = preload("res://scenes/net.tscn")
var is_net_on = false

func build_net():
	is_net_on = true
	var instance = net.instantiate()
	$Anchor.add_child(instance)
