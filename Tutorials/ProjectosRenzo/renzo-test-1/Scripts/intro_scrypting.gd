extends Node2D

var score : int = 3.2 
var move_speed : float = 3.52
var game_over : bool = false
var ability : String = 'slash'

func _ready ():
	print (score)
	print (move_speed)
	print (game_over)
	print (ability)
	_welcome_message()
	_add(2,3)
	var result = _add(20,30)
	print(result)

# delta is the time between frames
func _process(delta):
	#print('process')
	pass

# begin with _ means it is a privatre function which is
#function that will be use only on this script
func _welcome_message ():
	print('welcome to the game')
	
func _add (a : float, b : float) -> int:
	var sum = a + b
	return sum
