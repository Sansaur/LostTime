/*

*	Magical status effects

*/

/datum/status_effect
	var/cooldown_time = 100
	var/cooldown = 0
	var/obj/effect/status_effect/effect_to_play

/datum/status_effect/proc/applyEffect(var/mob/living/AFFECTING)
	return
/datum/status_effect/proc/CheckCooldown()
	if(cooldown < world.time - cooldown_time)
		cooldown = world.time
		return 1
/*

*	TEST

*/

/datum/status_effect/random_slowdown
	effect_to_play = new /obj/effect/status_effect/generic_effect

/datum/status_effect/random_slowdown/applyEffect(var/mob/living/AFFECTING)
	if(!CheckCooldown())
		return

	if(effect_to_play)
		effect_to_play.Play(AFFECTING)

	if(istype(AFFECTING, /mob/living/carbon/human))
		var/mob/living/carbon/human/HUMAN = AFFECTING
		to_chat(HUMAN, "OMGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG!!!!!")
		if(HUMAN)
			HUMAN.Weaken(2)

/obj/effect/status_effect/generic_effect
	name = "Accelerated Particles"
	desc = "Small things moving very fast."
	icon = 'icons/obj/machines/particle_accelerator.dmi'
	icon_state = "particle"//Need a new icon for this
	anchored = 1
	density = 1

/obj/effect/status_effect/proc/Play(var/mob/living/AFFECTING)
	//THIS IS DANGEROUS, USING SLEEP IN THE SAME PROC AS LIFE, REMEMBER THIS FOR THE FUTURE - SANSAUR

	AFFECTING.underlays.Add(src)
	sleep(10)
	AFFECTING.underlays.Remove(src)