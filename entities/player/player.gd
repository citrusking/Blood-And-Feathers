extends CharacterBody2D

signal game_over
@export var bullet_scene : PackedScene
@export var speed : int
var hp : int = 1

var input_vector : Vector2

var is_moving : bool = false
var is_shooting : bool = false
var is_hurt : bool = false
var is_dying : bool = false
var is_dead: bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
    pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
    if !is_dying and !is_dead:
        look_at(get_global_mouse_position())
        if (Input.is_action_just_pressed("shoot")):
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
    var bullet_spawn = bullet_scene.instantiate()
    bullet_spawn.position = $BulletOrigin.global_position
    bullet_spawn.rotation = $BulletOrigin.global_rotation
    bullet_spawn.direction = (get_global_mouse_position() - global_position).normalized()
    get_tree().current_scene.add_child(bullet_spawn)
    
    
func take_damage(damage : int):
    hp = hp - damage
    if (hp <= 0):
        die()
    else:
        is_hurt = true
        

func die():
    is_dying = true
    game_over.emit()


func _on_area_2d_body_entered(body):
    if body.is_in_group("enemies"):
        take_damage(1)
        

func animate():
    if is_dead:
        $AnimatedSpriteTop.pause
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
