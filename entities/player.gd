extends Node2D

@export var speed : int
var is_moving : bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    look_at_mouse()
    move(delta)


func move(delta):
    position.x += Input.get_axis("left", "right" ) * speed * delta
    position.y += Input.get_axis("up", "down") * speed * delta
    
    # i feel like this can be shortened, but idk how to do it
    if (Input.is_action_pressed("left") or 
    Input.is_action_pressed("right") or 
    Input.is_action_pressed("down") or 
    Input.is_action_pressed("up")):
        is_moving = true;
    else:
        is_moving = false;
    
    if (is_moving):
        $AnimatedSprite2D.play("walk")
    else:
        $AnimatedSprite2D.stop()
    
func look_at_mouse():
    look_at(get_global_mouse_position())
