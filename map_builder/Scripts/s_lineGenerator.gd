extends Node3D
#find all blocks level by level

#use a path 3D and a CSGpolygon3D to create the outline
#the path 3D will place its points where the verticies are


func blocksByLevel():
	get_parent().matrix

