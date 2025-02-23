extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
    play("flymetothemoon")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass


func _on_area_2d_body_entered(body):
    GameState.feathers = GameState.feathers + 1
    queue_free()
