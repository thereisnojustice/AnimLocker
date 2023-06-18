# AnimLocker
Animation Locker for Godot 4.

## What's the AnimLocker for?

Say you have a game with a zombie character. The zombie needs to grab onto the player character. The player animation and zombie animation need to snap into position and be locked together for the duration of the grab so that the animations are synced up.

AnimLocker is a demo project on how to solve this problem. (At least, *one way* to solve this problem.)

This method of doing things does ***not*** move the nodes in the scene tree. The 'grabbed' node simply changes its global_transform to match the global_transform of its 'grabber'. Since moving the nodes around the tree is potentially more likely to create bugs in multiplayer, this *should* make it a safe way to lock animations even in networked games.

A better demo project will be created later.

## The cubes demo

In the cubes scene, you can press E to play an animation. The gray cube starts a locked animation with the blue cube. Once the blue cube's animation is complete, it unlocks from the gray cube.

You can also press R to rotate the gray cube, which makes the animation locking more obvious.

## How it works

The workflow used:
* The 'grabber' and the 'grabbed' models are animated in Blender together.
  * To stick with the example of a zombie and player model, this is what I would do in Blender:
    * Open the zombie blend file.
    * Append the player blend file (temporarily).
    * Animate them together.
    * Append the action of the player model back into the player blend file.
    * Go to the action editor/NLA editor, select, push down and save the action just appended.
    * Create an empty at the origin point of the player model at the final frame. This is where the player model will need to move in Godot when it 'unlocks' from the zombie.
    * Rename the empty to: "Empty_{PlayerAnimationName}" (something like "Empty_BitByZombieFront" etc.)
      * The AnimLocker script is written to look for this empty to move the player model into position once the animation is completed.
    * Delete the player model from the zombie blend.

After importing your blend files to Godot, there are additional steps to get things working.
  * Add the AnimLocker scene to your nodes that will either grab or be grabbed, IE both the zombie and player need AnimLockers.
  * Use the advanced import, select each animation that needs to be 'grabbed', and specify a file to save the custom tracks.
  * Set up a method call track on the 'grabbed' animation. Tie it to the animation player and set it up to play the next animation with a function call on the last frame.
  * Set up a method call track on the animation that follows the 'grabbed' animation. On the first frame, call the AnimLocker's release_lock_with_parent_node function.
