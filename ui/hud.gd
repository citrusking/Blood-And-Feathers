extends CanvasLayer

signal something_pressed
signal change_scene

var pauseButtonToggle : bool = false
var fullscreen : bool
var startTutorial : bool = true
var gameOverToggle : bool = false
var timeoutToggle : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
    $SceneTransition/ColorRect.color = 255
    $SceneTransition/AnimationPlayer.play_backwards("fade_to_black")
    if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
        fullscreen = true
    else:
        fullscreen = false
    $PauseScreen.visible = false
    $GameOverScreen/TimeoutSprite.visible = false
    
    Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
    $HealthIndicator.play("3hp")
    $ClockTimer.play("default")
    $Feathers.play("default")
    $CursorTracker/Cursor.play("default")
    $GameOverScreen.visible = false
    
    get_tree().paused = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    var mouse_pos = get_viewport().get_mouse_position()
    if !get_tree().paused:
        $CursorTracker.position = mouse_pos
        $CursorTracker2.visible = false
    else:
        $CursorTracker2.visible = true
        $CursorTracker2.position = mouse_pos
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
    
    if pauseButtonToggle:
        if Input.is_action_just_pressed("escape") && !get_tree().paused:
            get_tree().paused = true
            $PauseScreen.visible = true
        elif Input.is_action_just_pressed("escape") && get_tree().paused:
            get_tree().paused = false
            $PauseScreen.visible = false
    pass
    

func _input(event):
    if startTutorial && (event is InputEventKey || event is InputEventMouseButton):
        get_tree().paused = false
        $TutorialBG/AnimationPlayer.play("default")
        startTutorial = false
        pauseButtonToggle = true
    if get_tree().paused && event is InputEventMouseButton:
        $CursorTracker2/Sprite2D.region_rect.position = Vector2(32, 0)
    else:
        $CursorTracker2/Sprite2D.region_rect.position = Vector2(0, 0)
        
    if event is InputEventKey or event is InputEventMouseButton:
        something_pressed.emit()
    

func _on_health_indicator_animation_finished():
    if $HealthIndicator.animation == "3to2":
        $HealthIndicator.play("2hp")
    if $HealthIndicator.animation == "2to1":
        $HealthIndicator.play("1hp")
    if $HealthIndicator.animation == "0hp":
        $HealthIndicator.visible = false

func _on_button_button_down() -> void:
    get_tree().paused = false
    $PauseScreen.visible = false
    pass # Replace with function body.

func gameOver():
    if !gameOverToggle:
        $GameOverScreen.modulate = "ffffff00"
        $GameOverScreen.visible = true
        if timeoutToggle:
            $GameOverScreen/TimeoutSprite.visible = true
        $GameOverScreen/AnimationPlayer.play("GameOver")
        gameOverToggle = true

func win_combat():
    print("hi")
    get_tree().paused = true
    $AnimationPlayer.play("fade_sunrise")
    await $AnimationPlayer.animation_finished
    await something_pressed
    $SceneTransition/ColorRect.color.a = 0
    $SceneTransition/AnimationPlayer.play("fade_to_black")
    await $SceneTransition/AnimationPlayer.animation_finished
    change_scene.emit()
