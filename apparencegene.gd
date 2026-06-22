class_name Apparence_gene 

var organ_count : int 
var organ_shape : Array
var color_palette: Array
var organ_color_index : Array
var organ_color : Array
var organ_position : Array
var organ_functionality : Array 
var organ_parent : Array


const BASE_SIZE = 60
const MAX_ATTEMPTS = 200

func overlap(pos1, size1, pos2, size2):
	return abs(pos1.x - pos2.x) < (size1.x + size2.x) / 2 and abs(pos1.y - pos2.y) < (size1.y + size2.y) / 2

func is_valid_position(new_pos, new_size):
	for i in range(organ_position.size()):
		if overlap(new_pos, new_size, organ_position[i], organ_shape[i]):
			return false
	return true

func add_random_organ_position(size):
	if organ_position.size() == 0:
		organ_position.append(Vector2.ZERO)
		organ_parent.append(-1)

		var color_id = randi_range(0, color_palette.size() - 1)
		organ_color_index.append(color_id)
		organ_color.append(color_palette[color_id])

		return

	for attempt in range(MAX_ATTEMPTS):
		var parent_index = randi_range(0, organ_position.size() - 1)
		var parent_pos = organ_position[parent_index]
		var parent_size = organ_shape[parent_index]

		var direction = [Vector2.RIGHT, Vector2.LEFT, Vector2.UP, Vector2.DOWN].pick_random()

		var new_pos = parent_pos + Vector2(
			direction.x * (parent_size.x + size.x) / 2,
			direction.y * (parent_size.y + size.y) / 2
		)

		if is_valid_position(new_pos, size):
			organ_position.append(new_pos)
			organ_parent.append(parent_index)

			var color_id = organ_color_index[parent_index]

			# Si le parent est une rotule, on démarre un nouveau sous-corps
			if organ_functionality[parent_index] == 8:
				color_id = randi_range(0, color_palette.size() - 1)

			organ_color_index.append(color_id)
			organ_color.append(color_palette[color_id])

			return

	organ_position.append(Vector2.ZERO)
	organ_parent.append(0)

	var fallback_color = organ_color_index[0]
	organ_color_index.append(fallback_color)
	organ_color.append(color_palette[fallback_color])
	
	
func _init(count=10):
	organ_count = count
	organ_shape = []
	organ_color = []
	organ_position = []
	organ_functionality = []
	organ_parent = []
	organ_color_index = []
	color_palette = []

	var color_count = randi_range(1, 9)

	for i in range(color_count):
		color_palette.append(Color(randf(), randf(), randf()))

	for i in range(organ_count):
		var scale_size = Vector2(randf_range(0.5, 2.0), randf_range(0.5, 2.0))
		var real_size = scale_size * BASE_SIZE

		organ_shape.append(real_size)

		add_random_organ_position(real_size)

		organ_functionality.append(randi_range(0, 9))
