extends Node

class_name Weapon


export var fire_rate = 0.5
export var clip_size = 25
export var reload_rate = 1
var life =80;
onready var anime = $"../enemy/animation"
onready var ammo_label = $"/root/world/ui/Label"
onready var raycast = $"../head/Camera/RayCast"
var current_ammo = 0
var can_fire = true
var reloading = false
var mag_size = 10


onready var animationPlayer = $"../head/Camera/gun/anime"

func _ready():
	current_ammo = mag_size
	
func _process(delta):
	if reloading:
		ammo_label.set_text("Reloading...")
	
	else:
		ammo_label.set_text("AMMO \n %d / %d" % [current_ammo, clip_size])
	
	if Input.is_action_just_pressed("primary_fire") and can_fire:
		if current_ammo > 0 and not reloading:
			fire()
		
		elif not reloading:
			reload()
	
	if Input.is_action_just_pressed("reload") and not reloading:
		reload()

func check_collision():
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		if collider.is_in_group("enemies"):
			life =life - 40
		
			if(life == 0):
				#anime.play("dead")
			
				collider.queue_free()
				life=80
			print(life)
			print("Killed " + collider.name)


func fire():
	$gunshot.play()
	animationPlayer.play("fire2")
	
	print("Fired weapon")
	can_fire = false
	current_ammo -= 1
	check_collision()
	yield(get_tree().create_timer(fire_rate), "timeout")
	
	can_fire = true

func reload():
	if(clip_size != 0):
		print("Reloading")
		$reload.play()
		reloading = true
		yield(get_tree().create_timer(reload_rate), "timeout")
		current_ammo = mag_size
		clip_size = clip_size - 5
		reloading = false
		print("Reload complete")
	else:
		ammo_label.set_text("NO AMMO")

func _on_Area_area_entered(area):
	if area.is_in_group("ammo"):
		clip_size = 25
		area.queue_free()