/**
*
* Mana is a variable included in the living_defines.dm file. Every living mob has mana
* It has a handler defined for regular carbon mobs, needs to be defined for other mobs
* Added functionality on datumvars.dm, it gets referenced the same way as the damage types.
* As of now only humans can see or use mana.
* To actually update the mana icon you have to add something on the human/species/species.dm icon file, it'll probably be the same for every type of mob
* Living mobs have a variable which controls if they use mana or not.
* mana_usage is now a variable spells have, it'll spend mana from the mob when the spell is cast, the default value is 0

IDEAS:

* Mana is regenared based on the nutrition.

* TO DO:
* Actual things to do with mana
* Mana needs to update when adjusted
* Mana in the Set Variables Menu

**/

/obj/screen/manas
	name = "mana"
	icon_state = "mana0"
	screen_loc = ui_manas

/mob/living/proc/adjustMana(var/amount)
	src.mana += amount

/mob/living/proc/getMana()
	return mana


// ATTEMPT TO DO SOMETHING BASIC