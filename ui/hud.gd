extends CanvasLayer

var pauseButtonToggle = true
var fullscreen : bool

# Called when the node enters the scene tree for the first time.
func _ready():
    if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
        fullscreen = true
    else:
        fullscreen = false
    $PauseScreen.visible = false
    
    Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
    $HealthIndicator.play("3hp")
    $ClockTimer.play("default")
    $ClockTimer/ClockFace.play("default")
    $Feathers.play("default")
    $CursorTracker/Cursor.play("default")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    var mouse_pos = get_viewport().get_mouse_position()
    if !get_tree().paused:
        $CursorTracker.position = mouse_pos
    if mouse_pos.x >= 0 and mouse_pos.y >= 0:
        Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
    else:
        Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
    
    $Feathers/FeatherCounter.text = str(GameState.feathers)
    
    if Input.is_action_just_pressed("fullscreen"):
        if fullscreen:
            DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
            fullscreen = false
        else:
            DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
            fullscreen = true
    
    if Input.is_action_just_pressed("escape") && !get_tree().paused:
        get_tree().paused = true
        $PauseScreen.visible = true
    elif Input.is_action_just_pressed("escape") && get_tree().paused:
        get_tree().paused = false
        $PauseScreen.visible = false
    pass
        
func _on_health_indicator_animation_finished():
    if $HealthIndicator.animation == "0hp":
        $HealthIndicator.visible = false
