extends KinematicBody

const GRAVITY = -24.8
var vel = Vector3()
const MAXIMUM_SPEED = 15
const JUMP_SPEED = 8
const ACCELERATION = 4.5
var camera_angle = 0
var dir = Vector3()

var footstepSounIsPlaying = false
var timer = 0.5
const DEACCELERATION= 16
const MAX_SLOPE_ANGLE = 40

var camera
var rotation_helper
var musicMenu

var MOUSE_SENSITIVITY = 0.05
var x=0
const MAX_HEALTH = 100
var health = MAX_HEALTH
var inDamageArea = false
var dead = false
onready var health_label = $"/root/world/ui/Label2"

onready var hurting = get_node("hurt")
onready var shot = get_node("gunshot")
func _ready():
	$bgm.play()

	camera = $head/Camera
	rotation_helper = $head

	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	if health <= 0:
			dead = true
			x=1
			health_label.set_text("DEAD")
			
	if inDamageArea and not dead:
			health -= 10 * delta
			health_label.set_text("%d / %d" % [health,MAX_HEALTH] )
	process_input(delta)
	process_movement(delta)

func process_input(delta):

  
    dir = Vector3()
    var cam_xform = camera.get_global_transform()

    var input_movement_vector = Vector2()

    if Input.is_action_pressed("movement_forward"):
      
       input_movement_vector.y += 1
    if Input.is_action_pressed("movement_backward"):
        input_movement_vector.y -= 1
    if Input.is_action_pressed("movement_left"):
        input_movement_vector.x -= 1
    if Input.is_action_pressed("movement_right"):
        input_movement_vector.x += 1

    input_movement_vector = input_movement_vector.normalized()

    dir += -cam_xform.basis.z * input_movement_vector.y
    dir += cam_xform.basis.x * input_movement_vector.x
 
    if is_on_floor():
        if Input.is_action_just_pressed("movement_jump"):
            vel.y = JUMP_SPEED

    if Input.is_action_just_pressed("ui_cancel"):
        if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
            Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
        else:
            Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func process_movement(delta):
    dir.y = 0
    dir = dir.normalized()

    vel.y += delta * GRAVITY

    var hvel = vel
    hvel.y = 0

    var target = dir
    target *= MAXIMUM_SPEED

    var accel
    if dir.dot(hvel) > 0:
        accel = ACCELERATION
    else:
        accel = DEACCELERATION

    hvel = hvel.linear_interpolate(target, accel * delta)
    vel.x = hvel.x
    vel.z = hvel.z
    vel = move_and_slide(vel, Vector3(0, 1, 0), 0.05, 4, deg2rad(MAX_SLOPE_ANGLE))

func _input(event):
     if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
        rotation_helper.rotate_x(deg2rad(-event.relative.y * MOUSE_SENSITIVITY))
        self.rotate_y(deg2rad(event.relative.x * MOUSE_SENSITIVITY * -1))

        var camera_rot = rotation_helper.rotation_degrees
        camera_rot.x = clamp(camera_rot.x, -70, 70)


func _on_Area_body_entered(body):
	if body.is_in_group("enemies"):
		inDamageArea = true
		$hurt.play()
		$zombie.play()
		print("body entered")
	


func _on_Area_body_exited(body):
	if body.is_in_group("enemies"):
		inDamageArea = false
		print("body exited")

func _on_Area_area_entered(area):
	if area.is_in_group("medkit"):
		if health < 100:
			if health > 70:
				health = 100
				health_label.set_text("%d / %d" % [health,MAX_HEALTH] )
			else:
				health += 30
				health_label.set_text("%d / %d" % [health,MAX_HEALTH] )
			area.queue_free()
	if area.is_in_group("over"):
			get_tree().change_scene("res://won.tscn")
func _process(delta):
	if x==1:
		health_label.set_text("DEAD")
		get_tree().change_scene("res://GameOver.tscn")
		



func _on_Area_body_shape_entered(body_id, body, body_shape, area_shape):
	pass # Replace with function body.
