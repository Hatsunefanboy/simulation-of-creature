extends Node2D

var vitesse = 100
var faim_max = 50
var faim = 0

@onready var cam = $Camera2D
@onready var texte = $Label

var creature
var inplace_food = []


var muscle_timer = 0.0
var rotule_timer = 0.0
var transfer_timer =0.0

var calmuscle = 2.0
var calrotule=1.0
func r():
	pass
var poop = Food.new('poop' , 1.0,Flavorvect.new(0.0,1.0,10.0,0.0,0.0), 10.0,Vector2(10,10) ,r)
var nourriture_selected = [true, Food.new("poire",40.0,Flavorvect.new(5.0,20.0,5.0,5.0,5.0),1.0,Vector2(30,30),r)]
func get_all_organs(node):
	var result = []
	for child in node.get_children():
		
		if child is Area2D :
			
			result.append(child)
		result += get_all_organs(child)
	return result

func get_neighbor_organs(organ):
	var neighbors = []
	var parent = organ.get_parent()
	if parent is Area2D:
		neighbors.append(parent)
	for child in organ.get_children():
		if child is Area2D:
			neighbors.append(child)
	return neighbors
	


func random_transfer_from(a):
	var neighbor = get_neighbor_organs(a).pick_random()
	var food = []
	if a.get_meta("fluid").food != []:
		food = [a.get_meta("fluid").food.pick_random()]
	var calorie = a.get_meta("fluid").calorie
	var poopa = a.get_meta("fluid").poop
	var fluid = Fluid.new()
	
	fluid.food=food
	fluid.calorie = randf_range(0.0,calorie)
	fluid.poop = poopa
	a.get_meta("fluid").transfer(neighbor.get_meta("fluid"),fluid)


func constant_transfer():
	transfer_timer -= get_process_delta_time()
	if transfer_timer>0:
		return
	for i in get_all_organs(creature):

		if i.has_meta("stomach"):
			for j in i.get_meta("fluid").food:
				i.get_meta("fluid").calorie += j.calorie
				i.get_meta("fluid").poop += int(j.calorie/20.0)
			i.get_meta("fluid").food = []
			random_transfer_from(i)
		elif i.has_meta("ass"):
			var w=0
			for j in range(i.get_meta("fluid").poop):
				if i.get_meta("fluid").calorie > 2.0:
					i.get_meta("fluid").calorie -= 2.0
					w+=1
					var pos = get_sprite(i).global_position
					var c =Food_generator.new().generate(poop,pos)
					
					add_child(c)
					print("caca")
			i.get_meta("fluid").poop -= w
			print(i.get_meta("fluid").poop)
			random_transfer_from(i)
			
					
					
			
			
			
		elif i.has_meta("fluid"):
			if i.get_meta("fluid").food !=[]:
				random_transfer_from(i)
	transfer_timer =1.0

func activatefluid():
	for i in get_all_organs(creature):
		if i.has_meta("fluid"):
			
			if i.get_meta("fluid").poop !=0:
				var sprite =get_sprite(i)
				sprite.modulate= Color(0,0,0.3)
			
			elif i.get_meta("fluid").food != []:
				var sprite= get_sprite(i)
				sprite.modulate =Color(0,3,0)
			elif i.get_meta("fluid").calorie !=0.0:
				var sprite = get_sprite(i)
				sprite.modulate=Color(3,0,0)
			else:
				var sprite = get_sprite(i)
				sprite.modulate=i.get_meta("color")
			
			
				

func get_sprite(node):
	for child in node.get_children():
		if child is Sprite2D:
			return child
	return null


func get_sprite_rect(sprite: Sprite2D) -> Rect2:
	return Rect2(
		sprite.global_position - sprite.texture.get_size() * sprite.global_scale / 2,
		sprite.texture.get_size() * sprite.global_scale
	)


func check_food_eaten():
	for organ in get_all_organs(creature):
		if not organ.has_meta("mouth"):
			continue

		var mouth_sprite = get_sprite(organ)
		if mouth_sprite == null:
			continue

		var mouth_rect = get_sprite_rect(mouth_sprite)

		for food_node in inplace_food:
			var food_sprite = get_sprite(food_node)
			if food_sprite == null:
				continue

			var food_rect = get_sprite_rect(food_sprite)

			if mouth_rect.intersects(food_rect):
				var food_data: Food = food_node.get_meta("food_data")

				faim = max(0, faim - food_data.calorie)
				organ.get_meta("fluid").food.append(food_data)

				inplace_food.erase(food_node)
				food_node.queue_free()

				print("MIAM")
				return

func activate_muscle(muscle):
	if muscle.get_meta("fluid").calorie>= calmuscle:
		muscle.get_meta("fluid").calorie -= calmuscle
			
		var sprite = get_sprite(muscle)
		if sprite == null:
			return

		var dir = (sprite.global_position - creature.global_position).normalized()

		if dir == Vector2.ZERO:
			dir = Vector2.RIGHT

		creature.velocity += dir * 20

		var old_scale = sprite.scale
		var tween = create_tween()
		tween.tween_property(sprite, "scale", old_scale * Vector2(1.4, 0.6), 0.08)
		tween.tween_property(sprite, "scale", old_scale, 0.12)
	else:
		return

func activate_rotule(rotule, theta):
	if rotule.get_meta("fluid").calorie >= calrotule:
		rotule.get_meta("fluid").calorie -= calrotule
		rotule.rotation += theta
	else:
		return


func activate_random_rotule():
	rotule_timer -= get_process_delta_time()
	if rotule_timer > 0:
		return

	var rotules = []

	for organ in get_all_organs(creature):
		if organ.has_meta("rotule"):
			rotules.append(organ)

	if rotules.size() == 0:
		return

	var rotule = rotules.pick_random()
	var theta = randf_range(-0.2, 0.2)

	activate_rotule(rotule, theta)

	

	rotule_timer = 0.1


func activate_random_muscle():
	muscle_timer -= get_process_delta_time()
	if muscle_timer > 0:
		return

	var muscles = []

	for organ in get_all_organs(creature):
		if organ.has_meta("muscle"):
			muscles.append(organ)

	if muscles.size() == 0:
		return

	var muscle = muscles.pick_random()
	activate_muscle(muscle)

	muscle_timer = 0.89


func _ready() -> void:
	texte.z_index = 100

	cam.position = Vector2(100, 100)
	cam.make_current()

	

	randomize()

	var gene = Apparence_gene.new(30)
	var generator = Creature_generator.new()

	creature = generator.generate(gene)
	add_child(creature)

	creature.position = Vector2(400, 300)


func _process(delta: float) -> void:
	#print(get_all_organs(creature))
	texte.position.x = cam.position.x - 500
	texte.position.y = cam.position.y - 300
	constant_transfer()
	
	activatefluid()


	check_food_eaten()

	faim += 0.01

	if faim > faim_max:
		faim = faim_max
		vitesse = 0
		

	creature.velocity *= 0.98

	activate_random_muscle()
	activate_random_rotule()

	creature.move_and_slide()

	for i in range(creature.get_slide_collision_count()):
		var collision = creature.get_slide_collision(i)
		var body = collision.get_collider()

		if body is RigidBody2D:
			body.apply_central_impulse(-collision.get_normal() * 80)

	if faim < 0:
		faim = 0

	texte.text = "faim:" + str(round(faim))


func check_mouth_click(click_pos):
	for organ in get_all_organs(creature):
		if organ.has_meta("mouth"):
			var sprite = get_sprite(organ)

			if sprite == null:
				continue

			var rect = Rect2(
				sprite.global_position - sprite.texture.get_size() * sprite.global_scale / 2,
				sprite.texture.get_size() * sprite.global_scale
			)

			if rect.has_point(click_pos):
				return true

	return false


func _input(event):
	if event is InputEventScreenTouch or event is InputEventMouseButton:
		if event.pressed:
			var click_pos = get_global_mouse_position()

			if check_mouth_click(click_pos):
				faim -= 5

			elif nourriture_selected[0]:
				var generator = Food_generator.new()
				var food = generator.generate(nourriture_selected[1], click_pos)

				inplace_food.append(food)
				add_child(food)

	elif event is InputEventKey:
		if event.pressed:
			if event.keycode == KEY_A:
				cam.zoom.x += 0.1
				cam.zoom.y += 0.1

			elif event.keycode == KEY_E:
				cam.zoom.x -= 0.1
				cam.zoom.y -= 0.1

			elif event.keycode == KEY_S:
				cam.position.y += 50

			elif event.keycode == KEY_Q:
				cam.position.x -= 50

			elif event.keycode == KEY_Z:
				cam.position.y -= 50

			elif event.keycode == KEY_D:
				cam.position.x += 50
