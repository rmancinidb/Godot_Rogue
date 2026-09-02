extends CanvasLayer

@onready var healt_container = $HealthContainer
var hearts : Array = []

@onready var score_text : Label = $ScoreText

#parent because it is the main where everything is attached
@onready var player = get_parent()

#this is when we start
func _ready ():
	#here we get all the childen nodes, in this case 3 hearts
	hearts = healt_container.get_children()

	#when tyhe signal happen im unpdate the signals, and applyting the corresponding functions	
	player.OnUpdateHealt.connect(_update_hearts)
	player.OnUpdateScore.connect(_update_score)

	#this is to start the game with the right values
	_update_hearts(PlayerStats.health)
	_update_score(PlayerStats.score)


func _update_hearts (health:int):
	for i in len(hearts):
		hearts[i].visible = i < health
	
func  _update_score (score:int):
	score_text.text = "Score: " + str(score)
	
	
	
