extends Control

func aquire_powerup(powerup):
	var texture = load("res://Assets/Power ups/"+ powerup + ".png")
	var powerupname = powerup.replace("_", " ")
	$item.texture = texture
	$banner/bannertext.bbcode_text = "[center]Aquired " + powerupname + "[/center]"
	$AnimationPlayer.play("show")
	
func aquire_Boss_Item(item):
	var texture = load("res://Assets/Boss_items/"+item+".png")
	var itemname = item.replace("_", " ")
	$item.texture = texture
	$banner/bannertext.bbcode_text = "[center]Aquired " + itemname + "[/center]"
	$AnimationPlayer.play("show")
