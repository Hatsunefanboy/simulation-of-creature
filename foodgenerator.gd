class_name Food_generator

func generate(food_val: Food,pos : Vector2):
	var food =RigidBody2D.new()
	food.gravity_scale =0
	food.mass = 1
	food.freeze =false
	food.linear_damp =3
	food.contact_monitor = true
	var collision =CollisionShape2D.new()
	var shape = CircleShape2D.new()
	shape.radius = food_val.size.x
	collision.debug_color =Color.REBECCA_PURPLE
	collision.shape =shape
	collision.position =pos 
	food.add_child(collision)
	var sprite = Sprite2D.new()
	var texture_path = "ressource/fruit_placeholder.png"
	food.add_child(sprite)
	food.set_meta("food_data",food_val)
	sprite.position = pos
	if FileAccess.file_exists("ressource/food/%s.png" % food_val.name ):
		texture_path = "ressource/food/%s.png" % food_val.name
		
	sprite.texture = load(texture_path)
	
	
	return food
	
	
	
