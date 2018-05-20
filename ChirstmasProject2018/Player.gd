extends Spatial

var ray
var ray_length = 250

var space
var result

var Animated_Cursor

var selected_champions 

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	
	ray = get_node("RayCast")
	ray.add_exception(self)
	ray.add_exception(get_node("RayCast"))
	
	Animated_Cursor = load("res://Cursor.tscn").instance()
	
	selected_champions = get_tree().get_root().get_node("Node/Champion")
	
	set_process_input(true)
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _input(event):
	
	if event is InputEventMouseButton:
		if(event.get_button_index() == BUTTON_LEFT && event.is_pressed()):
		
			# 'from' will become the ray's origion
			var from = get_node("Camera").project_ray_origin(get_viewport().get_mouse_position())
			# to' is the position where the ray will end up
			var to = (from + get_node("Camera").project_ray_normal(get_viewport().get_mouse_position()) * ray_length)
			
			ray.cast_to = to
			
			# I really have a hard time understanding this so check the docs for info.
			space = get_world().get_direct_space_state()
			
			result = space.intersect_ray(from, to)
		
			if(!result.empty()):
				
				var draw_Line = get_tree().get_root().get_node("Node/Draw_Line")
				draw_Line.clear()
				draw_Line.begin(Mesh.PRIMITIVE_LINE_STRIP)
				draw_Line.add_vertex(from)
				draw_Line.add_vertex(to)
				draw_Line.end()
				#I'll need this later
				
				#if(result.collider.is_in_group("Grid")):
				#Create 3D Arrow at click
				Animated_Cursor.translation = result.position
				get_tree().get_root().add_child(Animated_Cursor)
				var paths = get_tree().get_root().get_node("Node/Navigation").get_simple_path(get_tree().get_root().get_node("Node/Champion").translation, result.position)
				#print(paths)
				
				var geo = get_tree().get_root().get_node("Node/ImmediateGeometry")
				geo.clear()
				geo.begin(Mesh.PRIMITIVE_LINE_STRIP)
				
				
				selected_champions.number = 1
				selected_champions.path_queue = paths
				
				for i in paths:
					geo.add_vertex(Vector3(i.x ,(i.y + 0.1), i.z))
					#get_node("Camera").translation = (i)
					#get_tree().get_root().add_child(Animated_Cursor)
				geo.end()
			else:
				
				Animated_Cursor.translation = (from + get_node("Camera").project_ray_normal(get_viewport().get_mouse_position()) * 10)
				get_tree().get_root().add_child(Animated_Cursor)
	
	if event is InputEventKey:
		#event.set_action("")
		if(event.get_scancode() == KEY_A && event.is_pressed()):
			self.translate(Vector3(-0.1,0,0))
	
		if(event.get_scancode() == KEY_D && event.is_pressed()):
			self.translate(Vector3(0.1,0,0))
			
		if(event.get_scancode() == KEY_W && event.is_pressed()):
			self.rotate_y(0.1)
			
		if(event.get_scancode() == KEY_S && event.is_pressed()):
			self.rotate_y(-0.1)
	pass
