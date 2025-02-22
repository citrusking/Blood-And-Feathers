extends CharacterBody2D

@export var feather_scene : PackedScene
@export var speed : int
var player_node : CharacterBody2D
var player_position : Vector2
var hp : int = 1

var is_dying : bool = false
var in_radius : bool = false

func _ready():
    $AnimatedSprite2D.play("walk")

func _physics_process(delta):
    if !is_dying:
        if !in_radius:
            if (player_node != null):
                velocity = (player_position - global_position).normalized() * speed * delta
                look_at(player_node.global_position)
            player_position = player_node.global_position
            move_and_slide()
            if position.distance_to(player_position) < 300:
                in_radius = true
        else:
            velocity = (player_position - global_position).normalized() * speed * delta
            move_and_slide()
            if get_slide_collision_count() != 0:
                die(false)
        if position.distance_to(player_position) < 3:
            die(false)
    
func die(feather_drop : bool):
    $AnimatedSprite2D.play("die")
    $AnimatedSprite2D.scale = Vector2(1.5, 1.5)
    $CollisionShape2D.scale = Vector2(2.5, 2.5)
    $AnimatedSprite2D.z_index = 15
    #set_collision_layer_value(3, false)
    #set_collision_layer_value(4, true)
    if feather_drop && !is_dying:
        var feather_spawn = feather_scene.instantiate()
        feather_spawn.global_position = global_position
        get_tree().current_scene.add_child(feather_spawn)
    is_dying = true

func _on_animated_sprite_2d_animation_finished():
    if $AnimatedSprite2D.animation == "die":
        remove_from_group("enemies")
        queue_free()

func _on_area_2d_body_entered(body):
    print(body)
    if is_dying:
        if body == player_node:
            body.take_damage(1)
