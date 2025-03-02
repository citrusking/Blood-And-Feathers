extends CharacterBody2D

signal health_changed
@export var bullet_scene : PackedScene
@export var speed : int

@onready var ouch1 = preload("res://assets/sounds/hurt_1.mp3")
@onready var ouch2 = preload("res://assets/sounds/hurt_2.mp3")
@onready var hit = preload("res://assets/sounds/hitHurt.wav")
@onready var dead = preload("res://assets/sounds/dead_player.mp3")
@onready var gunshot = preload("res://assets/sounds/pistol-shot.mp3")

var input_vector : Vector2

var is_moving : bool = false
var is_shooting : bool = false
var is_hurt : bool = false
var is_dying : bool = false
var is_dead : bool = false
var can_shoot : bool = true


# Called when the node enters the scene tree for the first time.
func _ready():
    initialize()
    
    
func initialize():
    match GameState.flashlight:
        1:
            $Flashlight_1.visible = true
            $Flashlight_2.visible = false
            $Flashlight_3.visible = false
        2:
            $Flashlight_1.visible = false
            $Flashlight_2.visible = true
            $Flashlight_3.visible = false
        3:
            $Flashlight_1.visible = false
            $Flashlight_2.visible = false
            $Flashlight_3.visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
    if !is_dying and !is_dead:
        look_at(get_global_mouse_position())
        if (Input.is_action_just_pressed("shoot") and can_shoot):
            shoot()
        move(delta)
        move_and_slide()
    animate()


func move(delta):
    input_vector = Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down"))
    velocity = input_vector.normalized() * speed * delta
    
    if (input_vector != Vector2.ZERO):
        is_moving = true
    else:
        is_moving = false
        
        
func shoot():
    is_shooting = true
    can_shoot = false
    $AnimationPlayer.play("muzzle_flash")
    $SFX/PlayerSFX.stream = gunshot
    $SFX/PlayerSFX.pitch_scale = randf_range(.85, 1.15)
    $SFX/PlayerSFX.play()
    var bullet_spawn = bullet_scene.instantiate()
    bullet_spawn.position = $BulletOrigin.global_position
    bullet_spawn.rotation = $BulletOrigin.global_rotation
    bullet_spawn.direction = (get_global_mouse_position() - global_position).normalized()
    get_tree().current_scene.add_child(bullet_spawn)
    await get_tree().create_timer(.5 / GameState.fire_rate).timeout
    can_shoot = true
    if !is_dying and !is_dead:
        if (Input.is_action_pressed("shoot") and can_shoot):
            shoot()


func take_damage(damage : int):
    GameState.player_hp = GameState.player_hp - damage
    health_changed.emit()
    
    match GameState.player_hp:
        2:
            $SFX/HurtSFX.stream = hit
            $SFX/HurtSFX.pitch_scale = 1
            $SFX/HurtSFX.play()
        1:
            $SFX/HurtSFX.stream = hit
            $SFX/HurtSFX.pitch_scale = 1
            $SFX/HurtSFX.play()
        0:
            if !is_dying:
                die()

    if GameState.player_hp > 0:
        is_hurt = true


func die():
    if !is_dying:
        if $SFX/HurtSFX.stream != dead:
            $SFX/HurtSFX.stream = dead
            $SFX/HurtSFX.pitch_scale = 1
            $SFX/HurtSFX.play()
    is_dying = true


func _on_area_2d_body_entered(body):
    if body.is_in_group("enemies"):
        take_damage(1)


func animate():
    if is_dead:
        $AnimatedSpriteTop.pause()
    elif is_dying:
        $AnimatedSpriteTop.play("die")
        $AnimatedSpriteBottom.visible = false
    elif is_hurt:
        $AnimatedSpriteTop.play("hurt")
    elif is_shooting:
        $AnimatedSpriteTop.play("shoot")
    elif is_moving:
        $AnimatedSpriteTop.play("walk")
    else:
        $AnimatedSpriteTop.play("idle")
    if is_moving:
        $AnimatedSpriteBottom.look_at(position + input_vector)
        $AnimatedSpriteBottom.play("walk")
    else:
        $AnimatedSpriteBottom.look_at(get_global_mouse_position())
        $AnimatedSpriteBottom.stop()


func _on_animation_finished():
    match $AnimatedSpriteTop.animation:
        "shoot":
            is_shooting = false
        "hurt":
            is_hurt = false
        "die":
            is_dying = false
            is_dead = true
