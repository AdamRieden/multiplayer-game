This is a multiplayer rouge-like game I adapted from my single player game. 
I am re-using all the code and assets, but also refactoring the code to be more streamlined and make more sense, 
especially now that I have to deal with the multiplayer aspects.

So far, I have successfully synced up the players(movement, position, animation), a spawning system for the first enemy, 
synced healthbars for both player and enemies, synced exp bars across players. Everything works between host and client.

I am trying to now implement the level up system, that is linked across to all players. So, whenever the last exp is obtained by any player,
every player levels up and the game pauses with the level up screen and what spell they can choose. So far I have up to when the players select their spells,
as the players clicks and selections aren't being sent to the host server properly so their choices are either never recognized or not synced properly. 

7/14/2025
I have now implemented the level up system, where the player can choose a spell and have it after every other player has choosen their own spell. 
The spells level up as well, where their stats are increased each time a spell already learned is selected. I think I made everything scalable for 
the addition of up to 6 more spells for the player to choose from, but I guess I'll see if any logic breaks when adding more.

I am now trying to implement all other spells, which there are 6, and adding their resources and other necessary components for that to work. 

7/29/2025
A little bit of a hiatus from adding new features, but I have edited how the leveling system will work. Instead of set amount of levels a spell can level up to,
all spells scale infinitely each time they are choosen. This leveling system is not shared between players, ie if a player has one spell to level 6, and another
player learns that same spell, they will start at level 1 and work their way up. Now the spell system is almost finished.

Now I actually have to implement the rest of the 6 spells then the spell system will be complete.
