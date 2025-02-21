extends Node2D

@export var speed : int


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
    
    
func look_at_mouse():
    look_at(get_global_mouse_position())
