This is a multiplayer rouge-like game I adapted from my single player game. 
I am re-using all the code and assets, but also refactoring the code to be more streamlined and make more sense, 
especially now that I have to deal with the multiplayer aspects.

So far, I have successfully synced up the players(movement, position, animation), a spawning system for the first enemy, 
synced healthbars for both player and enemies, synced exp bars across players. Everything works between host and client.

I am trying to now implement the level up system, that is linked across to all players. So, whenever the last exp is obtained by any player,
every player levels up and the game pauses with the level up screen and what spell they can choose. So far I have up to when the players select their spells,
as the players clicks and selections aren't being sent to the host server properly so their choices are either never recognized or not synced properly. 


