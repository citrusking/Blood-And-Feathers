extends Node2D

@export var pigeon_scene : PackedScene


# Called when the node enters the scene tree for the first time.
func _ready():
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
    
    var current_mob_spawn = pigeon_scene.instantiate()
    current_mob_spawn.position = $Player.position + spawn_vector
    current_mob_spawn.velocity = $Player.position - current_mob_spawn.position
    current_mob_spawn.player_node = $Player
    add_child(current_mob_spawn)


func _on_game_over():
    print("GAME OVER")
