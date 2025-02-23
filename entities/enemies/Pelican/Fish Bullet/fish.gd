extends Area2D

@export var bullet_speed : int
@export var bullet_damage : int
var player_node : CharacterBody2D
var direction : Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
    if (direction.x < 0):
        $Sprite2D.flip_v = true
    pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    position += direction * bullet_speed * delta

func _on_despawn_timer_timeout():
    queue_free()

func _on_body_entered(body):
    if (body == player_node):
        player_node.take_damage(1)
    if (!body.is_in_group("enemies")):
        queue_free()
