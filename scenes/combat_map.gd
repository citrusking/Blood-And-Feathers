extends Node2D

@export var budgie : PackedScene
@export var chicken : PackedScene
@export var pelican : PackedScene
@export var egg : PackedScene
var enemyArray
var eggnum : int = 2
var win = false

# Called when the node enters the scene tree for the first time.
func _ready():
    # Enemies for level
    if GameState.night == 1:
        enemyArray = [budgie, budgie, budgie, chicken, pelican]
    
    # Eggs for level
    var eggspawns = $EggMarkers.get_children()
    for i in eggnum:
        var eggspawnPositionMarker = eggspawns.pop_at(randi() % eggspawns.size())
        var current_eggspawn = egg.instantiate()
        current_eggspawn.position = eggspawnPositionMarker.position
        current_eggspawn.connect("deadEgg", updateNestCounter)
        $EggTasks.add_child(current_eggspawn)
    $HUD/GoalCounters.text = "NIGHT " + str(GameState.night) + "\nNESTS " + str(eggnum)
    pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    if ($LevelTimer.time_left >= 120):
        $HUD/ClockTimer/ClockFace.play("default")
        $HUD/ClockTimer/ClockFace.frame = 0
    
    if !win:
        win = true
        for i in $EggTasks.get_children():
            if !i.dead:
                win = false
        if win:
            print("win")
        pass

func _on_enemy_spawn_timer_timeout():
    # find safe distance to spawn enemies (just offscreen)
    var viewport_rect = get_viewport_rect()
    var viewport_radius = sqrt(pow(viewport_rect.size.x, 2) + pow(viewport_rect.size.y, 2)) / 2
    var spawn_radius = viewport_radius + 25 # extra added so enemy sprite edges can't be seen
    
    var spawn_vector = Vector2(spawn_radius, 0).rotated(randf_range(0, 2 * PI))
    
    #"""
    var nextEnemy = enemyArray[(randi() % enemyArray.size())]
    
    var current_mob_spawn = nextEnemy.instantiate()
    current_mob_spawn.position = $Player.position + spawn_vector
    current_mob_spawn.velocity = $Player.position - current_mob_spawn.position
    current_mob_spawn.player_node = $Player
    add_child(current_mob_spawn)
    #"""

func _on_player_health_changed():
    if GameState.player_hp == 3:
        $HUD/HealthIndicator.play("3hp")
    elif GameState.player_hp == 2:
        $HUD/HealthIndicator.play("3to2")
    elif GameState.player_hp == 1:
        $HUD/HealthIndicator.play("2to1")
    elif GameState.player_hp <= 0:
        $HUD/HealthIndicator.play("0hp")
        $HUD.gameOver()
        print("GAME OVER")

func _on_level_timer_timeout():
    print("TIMED OUT")
    $Player.take_damage(3)
    _on_player_health_changed()
    pass # Replace with function body.

func updateNestCounter():
    eggnum -= 1
    $HUD/GoalCounters.text = "NIGHT " + str(GameState.night) + "\nNESTS " + str(eggnum)
