extends KinematicBody

const speed = 20
var player

func ready():
	 player = $world/player
func _physics_process(del):
  var to_player = translation.direction_to(player.translation)
  del = move_and_slide(to_player * speed)* delta)
  _physics_process()