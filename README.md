# **Note - Not all scripts are shown in this reprository (for security reasons)**
# Luau-Showcase - Weapon system
This repository is a showcase of a weapon combat system programmed with Luau - by Rhyz152

# ***Info***
This combat system is inspired by the combat of Bleach Roblox game, **VV Ultimatum.**
Before reading this documentation, it is highly recommended to read the scripts as it is explained better if you have but you don't really need to understand it, since I explain it here.
If you're wondering what a 'Zanpakuto' is, its the word for weapon (basically) in Bleach (manga/anime).

# ***Combat System***
In this project, I use a **table of data (name, damage, animation id, etc)** to efficiently make it so that we don't have to manually change variables, and other things that may need changing, to just get the same keyword (like CombatData.Damage, makes sense if you read the scripts).
To make this system responsive to the user and satisfying as possible without going overboard, I made a **client-based combat system, server for validating everything.**

# ***Toggle System***
In this project, instead of using normal tools, I implemented a toggle system of **responsively cloning a pre-made model into the player's character (their right arm in this project) and used Cframe values to correctly set the Cframe of the new model.**
To begin, the client sends an input, via an Input detection utility that tracks input and returns callbacks (functions written inside of any script so in this example the client presses 'X' and it runs the function passed in (as an argument)).
The server gets some stored assets from ServerStorage.
The best and most efficient way of holstering weapons is using accessories, I can set them up for your game if needed.
To make sure that we can get a quick cleanup and store the player's equipped weapons and holsters, we use tables.
The function 'CreateWeapon(...)' gets the stored holsters in the table and destroys them (if they're an accessory).
Then, it clones the weapon asset and uses a stored Cframe value inside of the asset to set the Cframe of the new model (parented to the player's right arm).
By this, we are able to efficiently rotate and position the weapon where the blade is facing in front of the player and is at the angle it is.
Additionally, we play animations, sfx, and vfx on the client for a smooth responsive system, instead of heavily loading the server and waiting for responses.
The function 'DestroyWaepon(...)' does the opposite, gets the player's weapon and destroys it.
It then clones the accessory and uses the function 'AddAccessory(...)' found in the Humanoid class.

# ***Player State utility***
