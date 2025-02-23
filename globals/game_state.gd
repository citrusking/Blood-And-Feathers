extends Node

var player_hp : int = 3
var feathers : int
var night : int = 1 # this is the level, or wave, or whatever
var bullet_damage : int
var fire_rate : int = 1
var flashlight : int

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass
    
    
func upgrade(upgrade_name : String, upgrade_level : int):
    match upgrade_name:
        "flashlight":
            flashlight = upgrade_level
        "bullet_damage":
            bullet_damage = upgrade_level
        "fire_rate":
            fire_rate = upgrade_level
