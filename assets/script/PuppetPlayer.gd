extends KinematicBody

remote func sendPos(pos):
    global_transform = pos

remote func setAnimation(anim):
	$Model/AnimationPlayer.play(anim)