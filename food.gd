class_name Food

var name : String
var calorie : float
var flavor : Flavorvect
var smellfactor : float 
var size : Vector2
var effect : Callable

func _init(nam,calori,flavo,smellfacto,siz,effec) -> void:
	name = nam
	calorie = calori
	flavor = flavo
	smellfactor = smellfacto
	size = siz
	effect = effec
