extends Node3D

@onready var anim_player = get_parent().get_node("AnimationPlayer")
@onready var parent_node = get_parent()
@onready var parent_parent_node = get_parent().get_parent()
var locked_child_node = null
var locked_parent_node = null
var locked_child_node_locker = null
var locked_parent_node_locker = null
var saved_anim_name = null
var anim_has_started = false


func _process(_delta):
	# if there is no parent node, return. If there is a parent node, copy its global_transform.
	if !locked_parent_node:
		return
	if !anim_has_started:
		return
	parent_node.global_transform = locked_parent_node.global_transform


##### Parent node funcs #####
func start_lock_with_child_node(_node, _parent_anim, _child_anim):
	if locked_child_node:
		return
	
	if anim_player:
		anim_player.play(_parent_anim)
		
	locked_child_node = _node
	locked_parent_node_locker = locked_child_node.get_node("AnimLocker")
	locked_parent_node_locker.start_lock_with_parent_node(parent_node, _child_anim)


func release_lock_with_child_node():
	locked_child_node = null


func get_end_pos(_anim_name):
	# Get the empty.global_transform for a specific animation
	# Name the empties in Blender based on the anim of the child node.
	var empty_with_anim_name_suffix = parent_node.get_node("Empty_{anim}".format({"anim": _anim_name}))
	return empty_with_anim_name_suffix.global_transform


##### Child node funcs #####
func start_lock_with_parent_node(_node, _child_anim):
	if locked_parent_node:
		return
	locked_parent_node = _node
	locked_parent_node_locker = locked_parent_node.get_node("AnimLocker")
	anim_has_started = false

	if anim_player:
		anim_player.play(_child_anim)
		anim_player.advance(0.001)
		parent_node.global_transform = locked_parent_node.global_transform
		saved_anim_name = _child_anim
		anim_has_started = true


func release_lock_with_parent_node():
	# call parent's get_end_pos("current_anim") to set global_transform as needed
	# this func should be called by the transition animation
	if !locked_parent_node:
		return

	parent_node.global_transform = locked_parent_node_locker.get_end_pos(saved_anim_name)
	locked_parent_node_locker.release_lock_with_child_node()
	locked_parent_node = null
