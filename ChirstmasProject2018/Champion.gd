extends StaticBody

var path_queue 
var number = 1

var movement_speed = 0.02

func _ready():
	
	set_physics_process(true)
	
	pass

func _physics_process(delta):

	#TODO create a 'moving state'
	
	if(path_queue):
		
		var ms = movement_speed # This is a copy of movement speed that can actually change.
		var T = true
		while(T):
			
			if( number < (path_queue.size() )):
			
				var e = ( self.to_global(path_queue[number]) - self.to_global(self.translation) )
				
				var b = 0
				b += abs(e.x) + abs(e.y) + abs(e.z)
			
				if (ms > b):
					self.global_translate(e)
					ms -= abs(b)
					number += 1
			
				else:
					self.global_translate( e.normalized() * ms )
					T = false
				
			else:
				self.translation = ( path_queue[ path_queue.size() - 1 ])

				path_queue = false
				T = false
	
	pass
