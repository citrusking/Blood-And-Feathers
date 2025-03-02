extends Node

var player_hp : int = 3
var feathers : int = 0
var night : int = 1 # this is the level, or wave, or whatever
var bullet_damage : int = 1
var fire_rate : int = 1
var flashlight : int = 1

var reload_combat : bool = false
var reload_shop : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

    
func upgrade(upgrade_name : String):
    match upgrade_name:
        "flashlight":
            if flashlight < 3:
                flashlight = flashlight + 1
        "bullet_damage":
            if bullet_damage < 3:
                bullet_damage = bullet_damage + 1
        "fire_rate":
            if fire_rate < 3:
                fire_rate = fire_rate + 1
