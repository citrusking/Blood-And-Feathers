extends Area2D

@export var bullet_speed : int
@export var bullet_damage : int
var direction : Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
    pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    position += direction * bullet_speed * delta

func _on_despawn_timer_timeout():
    queue_free()

func _on_body_entered(body):
    if (body.is_in_group("enemies")):
        if (body.hp > 0):
            body.get_node_or_null("AnimationPlayer").play("white_flash")
        body.hp = body.hp - bullet_damage
        if (body.hp >= 0):
            body.hurtAudio()
        if (body.hp <= 0):
            body.call_deferred("die", true)
    if (body.is_in_group("egg")):
        if (body.hp > 0):
            body.get_node_or_null("AnimationPlayer").play("white_flash")
        body.hp -= bullet_damage
        if (body.hp >= 0):
            body.hurtAudio()
        if (body.hp <= 0):
            body.call_deferred("die", true)
    queue_free()
