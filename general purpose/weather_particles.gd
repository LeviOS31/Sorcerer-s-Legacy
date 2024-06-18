extends Node2D


export (String, "snow", "rain", "clear") var weather
export (int) var width
export (int) var amount
export (float) var time

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node(weather).visible = true
	get_node(weather).lifetime = time
	get_node(weather).amount = amount
	var particlematerial = get_node(weather).process_material
	get_node(weather).process_material = ParticlesMaterial.new()
	get_node(weather).process_material.emission_shape = particlematerial.emission_shape 
	get_node(weather).process_material.gravity =  particlematerial.gravity
	get_node(weather).process_material.emission_box_extents.x = width
	get_node(weather).process_material.scale = particlematerial.scale
	get_node(weather).process_material.gravity = particlematerial.gravity
	get_node(weather).process_material.color = particlematerial.color


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
