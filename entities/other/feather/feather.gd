extends AnimatedSprite2D

@onready var pickup = preload("res://assets/sounds/pickupfeather.wav")

var collected : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
    play("flymetothemoon")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass


func _on_area_2d_body_entered(body):
    if !collected:
        GameState.feathers = GameState.feathers + 1
        $SFX.stream = pickup
        $SFX.pitch_scale = randf_range(.85, 1.15)
        $SFX.play()


func _on_sfx_finished() -> void:
    queue_free()
    pass # Replace with function body.
