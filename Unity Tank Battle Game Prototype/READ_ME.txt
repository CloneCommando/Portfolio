Created By: Thomas Colligan
Date: November 2010

Note: This is a Unity game prototype that I made for an individual project for one of my college classes. 
This game prototype was created over the course of 3 weeks as a full time student. 
The Windows Executable folder contains the exe file for the Unity game that can be run and played on a Windows Machine. 
The Unity Code folder contains the related code that runs the game.


Controls:

	General Movement: W,A,S,D

	Rotate Tank Turret: Arrow Keys

	Fire Tank Shell: Spacebar

	Change Camera: P


Advanced Steering Behaviors: Leader Following, Path Following


Your goal in this 3D world is to drive your tank around and destroy the
enemy tanks. You have one ally tank who follows you around the map using the
advanced steering behavior Leader Following. He will attempt to help you kill 
the enemy tanks.

The enemy tanks will do Path Following along a specific patrol route. If they
encounter the player or the player's ally, they will attempt to destroy you.
Once they get within a specific firing range they will no longer move as they
have reached an optimal firing distance. They will then change their alignment 
to lign up with their target. If their target moves too far out of range they will
go back to their patrol route. The ally tank uses the same AI to shoot at the enemy
tanks.

Enemy tanks can sustain 3 tank shell hits before exploding, while the player and his
ally can sustain 4 tank shell hits before exploding. Varying degrees of fire and smoke
will come out of the tanks depending on how damaged they are.

The player wins if he destroys all of the enemy tanks, and loses if he is reduced to 0 health.

You can press the 'p' key to change the camera to a birds eye view of the whole map. 
While in this view you cannot move your tank around of fire. You can press the 'p' key
again to switch back to the normal camera.

The GUI lets you know how much health you have left, how much health your ally has left,
and how many enemies are left on the map.

