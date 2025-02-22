extends CharacterBody2D

@export var speed : int
var player_node : CharacterBody2D
var hp : int = 1

var is_dying : bool = false

func _ready():
    $AnimatedSprite2D.play("walk")

func _physics_process(delta):
    if !is_dying:
        if (player_node != null):
            velocity = (player_node.global_position - global_position).normalized() * speed * delta
        look_at(player_node.global_position)
        move_and_slide()
    
func die():
    $AnimatedSprite2D.play("die")
    is_dying = true
    remove_from_group("enemies") # this is so that the bullet will go through it while dying

func _on_animated_sprite_2d_animation_finished():
    if $AnimatedSprite2D.animation == "die":
        queue_free()
