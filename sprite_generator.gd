class_name Creature_generator
var body_texture = preload("res://ressource/body.png")
var eye_texture = preload("res://ressource/eye.png")
var mouth_texture= preload("res://ressource/mouth.png")
var noze_texture = preload("res://ressource/nose.png")
var muscle_texture = preload("res://ressource/muscle.png")
var ass_texture = preload("res://ressource/ass.png")
var brain_texture=preload("res://ressource/brain.png")
var stomach_texture =preload("res://ressource/stomach.png")
var rotule_texture = preload("res://ressource/rotule.png")
var stick_texture = preload("res://ressource/stickingpart.png")


func generate(gene: Apparence_gene) -> CharacterBody2D:
	var creature = CharacterBody2D.new()
	var organs = []
	var collisions = []

	# 1) Créer tous les organes
	for i in range(gene.organ_count):
		var organ = Area2D.new()
		var sprite = Sprite2D.new()
		var collision = CollisionShape2D.new()
		var shape = RectangleShape2D.new()

		organ.name = "Organ_" + str(i)
		organ.add_child(sprite)

		sprite.position = Vector2.ZERO
		sprite.scale = gene.organ_shape[i] / 60
		sprite.modulate = gene.organ_color[i]

		if gene.organ_functionality[i] == 0:
			sprite.texture = body_texture
		elif gene.organ_functionality[i] == 1:
			sprite.texture = eye_texture
		elif gene.organ_functionality[i] == 2:
			sprite.texture = mouth_texture
			organ.set_meta("mouth", true)
		elif gene.organ_functionality[i] == 3:
			sprite.texture = noze_texture
			organ.set_meta("nose", true)
		elif gene.organ_functionality[i] == 4:
			sprite.texture = muscle_texture
			organ.set_meta("muscle", true)
		elif gene.organ_functionality[i] == 5:
			sprite.texture = brain_texture
			organ.set_meta("brain", true)
		elif gene.organ_functionality[i] == 6:
			sprite.texture = ass_texture
			organ.set_meta("ass", true)
		elif gene.organ_functionality[i] == 7:
			sprite.texture = stomach_texture
			organ.set_meta("stomach", true)
		elif gene.organ_functionality[i] == 8:
			sprite.texture = rotule_texture
			organ.set_meta("rotule", true)
		elif gene.organ_functionality[i]==9:
			sprite.texture = stick_texture
			organ.set_meta("stick",true)
		organ.set_meta("fluid",Fluid.new(100.0,10,6))
		organ.set_meta("color",gene.organ_color[i])
		shape.size = sprite.texture.get_size() * sprite.scale
		collision.shape = shape
		collision.position = gene.organ_position[i]
		collision.debug_color = Color.GREEN_YELLOW

		organs.append(organ)
		collisions.append(collision)

	# 2) Attacher les organes en squelette
	for i in range(gene.organ_count):
		var parent = gene.organ_parent[i]

		if parent == -1:
			creature.add_child(organs[i])
			organs[i].position = gene.organ_position[i]
		else:
			organs[parent].add_child(organs[i])
			organs[i].position = gene.organ_position[i] - gene.organ_position[parent]

	# 3) Garder les collisions sur la créature
	for collision in collisions:
		creature.add_child(collision)

	return creature
