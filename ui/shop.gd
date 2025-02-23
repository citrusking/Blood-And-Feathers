extends Node2D

@export var mag1 : Texture2D
@export var bullet1 : Texture2D
@export var lens1 : Texture2D
@export var mag2 : Texture2D
@export var bullet2 : Texture2D
@export var lens2 : Texture2D
@export var medkit : Texture2D
@export var out : Texture2D

var mag_msg : String
var bul_msg : String
var len_msg : String
var med_msg : String

var mag_cost : int
var bul_cost : int
var len_cost : int
var med_cost : int

# Called when the node enters the scene tree for the first time.
func _ready():
    populate()
    $AnimationPlayer.play("background_slide")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass


func populate():
    %FeatherLabel.text = str(GameState.feathers)
    
    match GameState.bullet_damage:
        1:
            %Bullet.texture_normal = bullet1
            %Bullet.position = %Bullet1Pos.position
            bul_cost = 10
            #bul_msg = "$" + str(bul_cost) + ": damage up"
            bul_msg = "damage up"
        2:
            %Bullet.texture_normal = bullet2
            %Bullet.position = %Bullet2Pos.position
            bul_cost = 20
            #bul_msg = "$" + str(bul_cost) + ": damage up"
            bul_msg = "damage up"
        3:
            %Bullet.texture_normal = out
            %Bullet.position = %BulletOutPos.position
            bul_cost = 0
            bul_msg = "out of stock"
    match GameState.fire_rate:
        1:
            %Mag.texture_normal = mag1
            %Mag.position = %Mag1Pos.position
            mag_cost = 10
            #mag_msg = "$" + str(mag_cost) + ": fire rate up"
            mag_msg = "fire rate up"
        2:
            %Mag.texture_normal = mag2
            %Mag.position = %Mag2Pos.position
            mag_cost = 20
            #mag_msg = "$" + str(mag_cost) + ": fire rate up"
            mag_msg = "fire rate up"
        3:
            %Mag.texture_normal = out
            %Mag.position = %MagOutPos.position
            mag_cost = 0
            mag_msg = "out of stock"
    match GameState.flashlight:
        1:
            %Lens.texture_normal = lens1
            %Lens.position = %Lens1Pos.position
            len_cost = 10
            #len_msg = "$" + str(len_cost) + ": flash up"
            len_msg = "flash up"
        2:
            %Lens.texture_normal = lens2
            %Lens.position = %Lens2Pos.position
            len_cost = 20
            #len_msg = "$" + str(len_cost) + ": flash up"
            len_msg = "flash up"
        3:
            %Lens.texture_normal = out
            %Lens.position = %LensOutPos.position
            len_cost = 0
            len_msg = "out of stock"
    match GameState.player_hp:
        1:
            %Medkit.texture_normal = medkit
            %Medkit.position = %MedPos.position
            med_cost = 10
            #med_msg = "$" + str(med_cost) + ": recover health"
            med_msg = "gain 2 health"
        2:
            %Medkit.texture_normal = medkit
            %Medkit.position = %MedPos.position
            med_cost = 5
            #med_msg = "$" + str(med_cost) + ": recover health"
            med_msg = "gain 1 health"
        3:
            %Medkit.texture_normal = out
            %Medkit.position = %MedOutPos.position
            med_cost = 0
            med_msg = "out of stock"


func _on_animation_player_animation_finished(anim_name):
    if anim_name == "background_slide":
        $AnimationPlayer.play("shop_slide")


func _on_mag_mouse_entered():
    %Description.text = mag_msg


func _on_mag_mouse_exited():
    %Description.text = ""


func _on_bullet_mouse_entered():
    %Description.text = bul_msg


func _on_bullet_mouse_exited():
    %Description.text = ""


func _on_lens_mouse_entered():
    %Description.text = len_msg


func _on_lens_mouse_exited():
    %Description.text = ""


func _on_medkit_mouse_entered():
    %Description.text = med_msg


func _on_medkit_mouse_exited():
    %Description.text = ""


func _on_mag_pressed():
    if GameState.feathers >= mag_cost:
        GameState.feathers = GameState.feathers - mag_cost
        GameState.upgrade("fire_rate")
        populate()
        %Description.text = mag_msg
    else:
        %Description.text = "low feathers!"
    print(GameState.fire_rate)


func _on_bullet_pressed():
    if GameState.feathers >= bul_cost:
        GameState.feathers = GameState.feathers - bul_cost
        GameState.upgrade("bullet_damage")
        populate()
        %Description.text = bul_msg
    else:
        %Description.text = "low feathers!"
    print(GameState.bullet_damage)


func _on_lens_pressed():
    if GameState.feathers >= len_cost:
        GameState.feathers = GameState.feathers - len_cost
        GameState.upgrade("flashlight")
        populate()
        %Description.text = len_msg
    else:
        %Description.text = "low feathers!"
    print(GameState.flashlight)


func _on_medkit_pressed():
    if GameState.feathers >= med_cost:
        GameState.feathers = GameState.feathers - med_cost
        GameState.player_hp = 3
        populate()
        %Description.text = med_msg
    else:
        %Description.text = "low feathers!"
    print(GameState.player_hp)
