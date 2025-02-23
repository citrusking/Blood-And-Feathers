extends StaticBody2D

@onready var hit = preload("res://assets/sounds/gunhit.wav")
@onready var hitmark1 = preload("res://assets/sounds/eggcrack2.mp3")
@onready var hitmark2 = preload("res://assets/sounds/eggcrack1.mp3")
@onready var eggsplode = preload("res://assets/sounds/eggdead.mp3")


var player_node : CharacterBody2D
var hp : float = GameState.night * 10
var max_hp : float = hp
var brokenTriggers = [0,0,0]
var dead : bool = false

signal deadEgg

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    $AnimatedSprite2D.play("full")
    pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    if hp / max_hp <= 2.0/3.0 && brokenTriggers[0] == 0:
        $AnimatedSprite2D.play("break_full")
        brokenTriggers[0] = 1
        $SFX/EggSFX.stream = hitmark1
        $SFX/EggSFX.pitch_scale = randf_range(.85, 1.15)
        $SFX/EggSFX.play()
    if hp / max_hp <= 1.0/3.0 && brokenTriggers[1] == 0:
        $AnimatedSprite2D.play("break_half")
        brokenTriggers[1] = 1
        $SFX/EggSFX.stream = hitmark2
        $SFX/EggSFX.pitch_scale = randf_range(.85, 1.15)
        $SFX/EggSFX.play()
    if hp / max_hp <= 0 && brokenTriggers[2] == 0:
        $AnimatedSprite2D.play("kill")
        brokenTriggers[2] = 1
        $SFX/EggSFX.stream = eggsplode
        $SFX/EggSFX.pitch_scale = randf_range(.85, 1.15)
        $SFX/EggSFX.play()
        dead = true
        deadEgg.emit()
    pass

func _on_animated_sprite_2d_animation_finished():
    if $AnimatedSprite2D.animation == "break_full":
        $AnimatedSprite2D.play("half")
    if $AnimatedSprite2D.animation == "break_half":
        $AnimatedSprite2D.play("low")
    if $AnimatedSprite2D.animation == "kill":
        $AnimatedSprite2D.play("dead")

func hurtAudio():
    if hp > 0:
        $SFX/HurtSFX.stream = hit
        $SFX/HurtSFX.pitch_scale = randf_range(.85, 1.15)
        $SFX/HurtSFX.play()
