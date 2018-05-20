extends StaticBody

var path_queue 
var number = 0
#Don't look at this it's ugly and I'm still working on it
var e
var tom = -1

var movement_speed = 10
var count = movement_speed

func _ready():
	
	set_physics_process(true)
	
	pass

func _physics_process(delta):

	#TODO create a 'moving state'
	
	if(path_queue):
		
		if(number < path_queue.size()):
			
			if(number != tom):
				e = (get_tree().get_root().get_node("Node/Navigation").to_global(path_queue[number]) - self.to_global(self.translation))
				#movement_speed = (10 * (get_tree().get_root().get_node("Node/Navigation").to_global(path_queue[number]) / get_tree().get_root().get_node("Node/Navigation").to_global(path_queue[number + 1])))
				tom = number
			if(count > 0):
				self.global_translate(e / movement_speed)
				print(count)
				count -= 1
			else:
				
				number = (number + 1)
				count = movement_speed
			
	pass
