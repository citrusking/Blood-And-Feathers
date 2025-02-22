extends Node2D

@export var budgie : PackedScene
@export var chicken : PackedScene

var enemyArray

# Called when the node enters the scene tree for the first time.
func _ready():
	enemyArray = [budgie, budgie, budgie, chicken]
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

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
	add_child(current_mob_spawn)


func _on_player_health_changed():
    if GameState.player_hp == 3:
        $HUD/HealthIndicator.play("3hp")
    elif GameState.player_hp == 2:
        $HUD/HealthIndicator.play("2hp")
    elif GameState.player_hp == 1:
        $HUD/HealthIndicator.play("1hp")
    elif GameState.player_hp <= 0:
        $HUD/HealthIndicator.play("0hp")
        print("GAME OVER")
