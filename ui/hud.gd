extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
    $HealthIndicator.play("3hp")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass


func _on_health_indicator_animation_finished():
    if $HealthIndicator.animation == "0hp":
        $HealthIndicator.visible = false
