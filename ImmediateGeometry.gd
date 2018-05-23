extends ImmediateGeometry


var subdivisions = 2
onready var functions = preload("res://Functions.gd").new()

func create_tri(corner1, corner2, corner3):
	var corners = [corner1, corner2, corner3]
	self.set_normal(-functions.calc_surface_normal_newell_method(corners))
	for corner in corners:
		self.add_vertex(corner)


func create_mesh(lla1, lla2, lla3, curr_division = subdivisions):
		if curr_division == 0:
			var corner1 = functions.lla_to_xyz(lla1)
			var corner2 = functions.lla_to_xyz(lla2)
			var corner3 = functions.lla_to_xyz(lla3)
			create_tri(corner1, corner2, corner3)
		else:
			var corner1 = lla1
			var corner2 = functions.mid_point(lla1, lla2)
			var corner3 = lla2
			var corner4 = functions.mid_point(lla2, lla3)
			var corner5 = lla3
			var corner6 = functions.mid_point(lla3, lla1)
			var corners = [corner1, corner2, corner3, corner4, corner5, corner6]
			var order = [[1, 2, 6], [2, 4, 6], [2, 3, 4], [4, 5, 6]]
			for i in order:
				var next_division = curr_division - 1
				create_mesh(corners[i[0] - 1], corners[i[1] - 1], corners[i[2] - 1], next_division)


func _ready():

	self.begin(Mesh.PRIMITIVE_TRIANGLES)

	var lla1 = Vector3(0, -58.5, 0)
	var lla2 = Vector3(0, 58.5, 0)
	var lla3 = Vector3(180, 58.5, 0)
	var lla4 = Vector3(180, -58.5, 0)
	var lla5 = Vector3(90, -31.5, 0)
	var lla6 = Vector3(90, 31.5, 0)
	var lla7 = Vector3(-90, 31.5, 0)
	var lla8 = Vector3(-90, -31.5, 0)
	var lla9 = Vector3(-31.5, 0, 0)
	var lla10 = Vector3(31.5, 0, 0)
	var lla11 = Vector3(148.5, 0, 0)
	var lla12 = Vector3(-148.5, 0, 0)

	create_mesh(lla2, lla3, lla7)
	create_mesh(lla2, lla6, lla3)
	create_mesh(lla6, lla11, lla3)
	create_mesh(lla3, lla11, lla12)
	create_mesh(lla3, lla12, lla7)
	create_mesh(lla8, lla7, lla12)
	create_mesh(lla9, lla7, lla8)
	create_mesh(lla9, lla2, lla7)
	create_mesh(lla10, lla2, lla9)
	create_mesh(lla10, lla6, lla2)
	create_mesh(lla10, lla5, lla6)
	create_mesh(lla5, lla11, lla6)
	create_mesh(lla11, lla5, lla4)
	create_mesh(lla11, lla4, lla12)
	create_mesh(lla12, lla4, lla8)
	create_mesh(lla1, lla9, lla8)
	create_mesh(lla1, lla10, lla9)
	create_mesh(lla5, lla10, lla1)
	create_mesh(lla5, lla1, lla4)
	create_mesh(lla4, lla1, lla8)

	self.end()
