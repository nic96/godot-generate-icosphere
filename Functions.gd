var elev_data = []

static func calc_surface_normal(vert1, vert2, vert3): # calculate a normal using 3 vertices
	var U = (vert2 - vert1)
	var V = (vert3 - vert1)

	var x = (U.y * V.z) - (U.z * V.y)
	var y = (U.z * V.x) - (U.x * V.z)
	var z = (U.x * V.y) - (U.y * V.x)

	return Vector3(x, y, z).normalized()



static func calc_surface_normal_newell_method(vert_arr): # Newell's Method of calculating normals
	var normal = Vector3(0, 0, 0)

	var curr_vert = Vector3()
	var next_vert = Vector3()
	for i in range(0, vert_arr.size()):
		curr_vert = vert_arr[i]
		next_vert = vert_arr[(i + 1) % vert_arr.size()]

		normal.x = normal.x + ((curr_vert.y - next_vert.y) * (curr_vert.z + next_vert.z))
		normal.y = normal.y + ((curr_vert.z - next_vert.z) * (curr_vert.x + next_vert.x))
		normal.z = normal.z + ((curr_vert.x - next_vert.x) * (curr_vert.y + next_vert.y))

	return normal.normalized()


static func lla_to_xyz(lla): # Lon Lat Alt to x y z converter.
	var lon = lla.x
	var lat = lla.y
	var alt = lla.z
	var cosLat = cos(deg2rad(lat))
	var sinLat = sin(deg2rad(lat))
	var cosLon = cos(deg2rad(lon))
	var sinLon = sin(deg2rad(lon))
	var rad = 50.0 + alt
	var x = rad * cosLat * cosLon
	var y = rad * sinLat
	var z = rad * cosLat * sinLon
	return Vector3(x, y, z)

static func mid_point(lla1, lla2):
	var lon1 = lla1.x
	var lat1 = lla1.y
	var lon2 = lla2.x
	var lat2 = lla2.y

	var dLon = deg2rad(lon2 - lon1)

	# convert to radians
	lat1 = deg2rad(lat1)
	lat2 = deg2rad(lat2)
	lon1 = deg2rad(lon1)

	var Bx = cos(lat2) * cos(dLon)
	var By = cos(lat2) * sin(dLon)
	var lat3 = atan2(sin(lat1) + sin(lat2), sqrt((cos(lat1) + Bx) * (cos(lat1) + Bx) + By * By))
	var lon3 = lon1 + atan2(By, cos(lat1) + Bx)

	# return lla vector
	return Vector3(rad2deg(lon3), rad2deg(lat3), (lla1.z + lla2.z) / 2)
