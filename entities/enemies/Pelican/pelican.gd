extends CharacterBody2D

@export var bullet_scene : PackedScene
@export var feather_scene : PackedScene
@export var speed : int
@onready var hit = preload("res://assets/sounds/gunhit.wav")
@onready var death = preload("res://assets/sounds/pelican-blowup.mp3")
@onready var fish = preload("res://assets/sounds/pelican-spit.mp3")
var player_node : CharacterBody2D
var player_position : Vector2
var hp : int = 3

var is_dying : bool = false
var in_range : bool = false

func _ready():
    $AnimatedSprite2D.play("walk")

func _physics_process(delta):
    if !is_dying:
        if (player_node != null):
            player_position = player_node.global_position
            if position.distance_to(player_position) < 175 && position.distance_to(player_position) > 150:
                in_range = true
            elif position.distance_to(player_position) < 150:
                velocity = -(player_node.global_position - global_position).normalized() * speed * delta
            else:
                velocity = (player_node.global_position - global_position).normalized() * speed * delta
                in_range = false
            look_at(player_node.global_position)
        move_and_slide()
        if in_range:
            $Timer.paused = false;
        else:
            $Timer.paused = true;

func die(feather_drop : bool):
    $AnimatedSprite2D.play("die")
    is_dying = true
    set_collision_layer_value(3, false)
    set_collision_layer_value(4, false)
    remove_from_group("enemies") # this is so that the bullet will go through it while dying
    var feather_spawn = feather_scene.instantiate()
    feather_spawn.global_position = global_position
    get_tree().current_scene.add_child(feather_spawn)

func _on_animated_sprite_2d_animation_finished():
    if $AnimatedSprite2D.animation == "die":
        $CollisionShape2D.disabled = true
        $AnimatedSprite2D.visible = false
    if $AnimatedSprite2D.animation == "shoot":
        if is_dying:
            $AnimatedSprite2D.play("die")
        else:
            $AnimatedSprite2D.play("walk")

func _on_timer_timeout() -> void:
    $AnimatedSprite2D.play("shoot")
    var bullet_spawn = bullet_scene.instantiate()
    bullet_spawn.position = $BulletOrigin.global_position
    bullet_spawn.rotation = $BulletOrigin.global_rotation
    bullet_spawn.direction = ($BulletOrigin.global_position - global_position).normalized()
    get_tree().current_scene.add_child(bullet_spawn)
    bullet_spawn.player_node = player_node
    $SFX/BirdSFX.stream = fish
    $SFX/BirdSFX.pitch_scale = randf_range(.85, 1.15)
    $SFX/BirdSFX.play()
    pass # Replace with function body.

func hurtAudio():
    if hp > 0:
        $SFX/HurtSFX.stream = hit
        $SFX/HurtSFX.pitch_scale = randf_range(.85, 1.15)
        $SFX/HurtSFX.play()
    else:
        $SFX/HurtSFX.stream = death
        $SFX/HurtSFX.pitch_scale = randf_range(.85, 1.15)
        $SFX/HurtSFX.play()

func _on_hurt_sfx_finished() -> void:
    if $SFX/HurtSFX.stream == death:
        remove_from_group("enemies")
        queue_free()
    pass # Replace with function body.
