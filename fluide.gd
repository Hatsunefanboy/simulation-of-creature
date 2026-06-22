class_name Fluid

var calorie : float 
var food : Array
var max_cal : float
var max_food : int
var poop : int 
var max_poop: int



func _init(mc=0.0,mf=0,mp=0):
	calorie = 0.0
	max_cal=mc
	food= [] 
	max_food = mf
	max_poop= mp
	poop =0
	

func minus(other):
	calorie -= other.calorie
	for i in other.food:
		food.erase(i)
	poop -= other.poop
		
func add(other):
	calorie += other.calorie
	for i in other.food:
		food.append(i)
	poop += other.poop
func transfer(b,fluid):
	fluid.poop = min(fluid.poop,b.max_poop)
	fluid.food = fluid.food.slice(0,b.max_food)
	fluid.calorie = min(fluid.calorie,b.max_cal)
	self.minus(fluid)
	b.add(fluid)
