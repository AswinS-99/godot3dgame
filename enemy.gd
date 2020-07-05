extends KinematicBody

export var speed = 2
var dir = Vector3()
var vel = Vector3()
const GRAVITY = -15

var life = 80
var dead = false

var following = false
onready var Game = $"/root/world/player"
onready var anime = $"animation"

func _physics_process(delta):
	
	if dead:
		return
	
	
	self.look_at(Game.translation, Vector3(0,1,0))

	dir = Game.translation - self.translation
	

	
	if not following and (dir.x > 14 or dir.z > 14 and dir.y < -3 or dir.y > 3):
		return
	else:
		following = true
	
	dir = dir.normalized()

	vel.y += GRAVITY * delta

	var tmp_vel = vel
	tmp_vel.y = 0

	
	var target = dir * speed

	tmp_vel = tmp_vel.linear_interpolate(target, 12 * delta)

	vel.x = tmp_vel.x
	vel.z = tmp_vel.z

	vel = move_and_slide(vel, Vector3(0, 1, 0))
	


func die():
	anime.play("dead")
	dead = true
	$CollisionShape.disabled = true
	self.queue_free()


