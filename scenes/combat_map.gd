extends Node2D

@export var budgie : PackedScene
@export var chicken : PackedScene
@export var pelican : PackedScene
@export var egg : PackedScene
<<<<<<< Updated upstream


=======
@onready var battleTrack = preload("res://assets/sounds/Beasuce - Half Past Apocalypse.mp3")
>>>>>>> Stashed changes
var enemyArray
var eggnum : int
var win = false
var enemyHpMult : int

# Called when the node enters the scene tree for the first time.
func _ready():
<<<<<<< Updated upstream
    GameState.reload_shop = true
    
=======
    $Music.stream = battleTrack
    $Music.pitch_scale = 1
    $Music.play()
>>>>>>> Stashed changes
    # Enemies for level
    match GameState.night:
        1:
            enemyArray = [budgie]
            enemyHpMult = 1
            eggnum = 1
            $EnemySpawnTimer.wait_time = 10
        2:
            enemyArray = [budgie]
            enemyHpMult = 1
            eggnum = 3
            $EnemySpawnTimer.wait_time = 7.5
        3:
            enemyArray = [chicken]
            enemyHpMult = 1
            eggnum = 3
            $EnemySpawnTimer.wait_time = 10
        4:
            enemyArray = [budgie, budgie, chicken]
            enemyHpMult = 2
            eggnum = 3
            $EnemySpawnTimer.wait_time = 7.5
        5:
            enemyArray = [pelican]
            enemyHpMult = 1
            eggnum = 5
            $EnemySpawnTimer.wait_time = 5
        6:
            enemyArray = [budgie, budgie, pelican]
            enemyHpMult = 2
            eggnum = 5
            $EnemySpawnTimer.wait_time = 5
        7:
            enemyArray = [budgie, budgie, budgie, pelican, chicken]
            enemyHpMult = 1
            eggnum = 5
            $EnemySpawnTimer.wait_time = 2.5
        8:
            enemyArray = [budgie, budgie, budgie, pelican, chicken]
            enemyHpMult = 2
            eggnum = 5
            $EnemySpawnTimer.wait_time = 2.5
        9:
            enemyArray = [budgie, budgie, budgie, pelican, chicken]
            enemyHpMult = 2
            eggnum = 5
            $EnemySpawnTimer.wait_time = 1
        10:
            enemyArray = [budgie, budgie, budgie, pelican, chicken]
            enemyHpMult = 3
            eggnum = 5
            $EnemySpawnTimer.wait_time = 1
        _:
            enemyArray = [budgie, budgie, pelican, chicken]
            enemyHpMult = GameState.night / 3
            eggnum = 5
            $EnemySpawnTimer.wait_time = .5
    
    # Eggs for level
    var eggspawns = $EggMarkers.get_children()
    for i in eggnum:
        var eggspawnPositionMarker = eggspawns.pop_at(randi() % eggspawns.size())
        var current_eggspawn = egg.instantiate()
        current_eggspawn.position = eggspawnPositionMarker.position
        current_eggspawn.connect("deadEgg", updateNestCounter)
        $EggTasks.add_child(current_eggspawn)
    $HUD/GoalCounters.text = "NIGHT " + str(GameState.night) + "\nNESTS " + str(eggnum)
    
    var playerspawns = $PlayerMarkers.get_children()
    $Player.position = playerspawns[randi() % playerspawns.size()].position
    pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    if GameState.reload_combat:
        GameState.reload_combat = false
        get_tree().reload_current_scene()
    
    if ($LevelTimer.time_left >= 120):
        $HUD/ClockTimer/ClockFace.play("default")
        $HUD/ClockTimer/ClockFace.frame = 0
    if ($LevelTimer.time_left <= 15):
        $HUD/ClockTimer.modulate = "ff4040ff"
    
    if !win:
        win = true
        for i in $EggTasks.get_children():
            if !i.dead:
                win = false
        if win:
            $HUD.win_combat()
            

func _on_enemy_spawn_timer_timeout():
    # find safe distance to spawn enemies (just offscreen)
    var viewport_rect = get_viewport_rect()
    var viewport_radius = sqrt(pow(viewport_rect.size.x, 2) + pow(viewport_rect.size.y, 2)) / 2
    var spawn_radius = viewport_radius + 25 # extra added so enemy sprite edges can't be seen
    
    var spawn_vector = Vector2(spawn_radius, 0).rotated(randf_range(0, 2 * PI))
    
    var nextEnemy = enemyArray[(randi() % enemyArray.size())]
    
    var current_mob_spawn = nextEnemy.instantiate()
    current_mob_spawn.position = $Player.position + spawn_vector
    current_mob_spawn.velocity = $Player.position - current_mob_spawn.position
    current_mob_spawn.player_node = $Player
    current_mob_spawn.hp *= enemyHpMult
    add_child(current_mob_spawn)


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
<<<<<<< Updated upstream
=======
    $HUD.timeoutToggle = true
    print("TIMED OUT")
>>>>>>> Stashed changes
    $Player.take_damage(3)
    _on_player_health_changed()
    

func updateNestCounter():
    eggnum -= 1
    $HUD/GoalCounters.text = "NIGHT " + str(GameState.night) + "\nNESTS " + str(eggnum)


func _on_hud_change_scene():
    get_tree().paused = false
    get_tree().change_scene_to_file("res://ui/shop.tscn")
