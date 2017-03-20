/mob/living/simple_animal/silk_worm
	name = "\improper silk worm"
	desc = "grub."
	icon_state = "silkworm"
	icon_living = "silkworm"
	icon_dead = "silkworm_dead"
	icon_gib = "chick_gib"
	density = 0
	speak_chance = 0
	turns_per_move = 15
	//butcher_results = list(/obj/item/weapon/reagent_containers/food/snacks/meat = 1)
	response_help  = "pokes the"
	response_disarm = "kicks the"
	response_harm   = "kicks the"
	attacktext = "kicks"
	health = 5
	maxHealth = 5
	ventcrawler = 2
	pass_flags = PASSTABLE | PASSGRILLE | PASSMOB
	mob_size = MOB_SIZE_TINY
	can_hide = 1
	can_collar = 1
	gold_core_spawnable = CHEM_MOB_SPAWN_FRIENDLY

/mob/living/simple_animal/silk_worm/attack_hand(mob/user as mob)
	if(stat)
		to_chat(user, "You clean the remains of [src]")
		qdel(src)
	var/obj/item/silk_worm_dummy/N = new /obj/item/silk_worm_dummy (src.loc)
	N.attack_hand(user)
	qdel(src)


/obj/item/silk_worm_dummy
	name = "\improper silk worm"
	desc = "grub."
	icon = 'icons/mob/animal.dmi'
	icon_state = "silkworm"



/obj/item/silk_worm_dummy/dropped()		//THIS WILL GIVE BUGS
	var/mob/living/simple_animal/silk_worm/NN = new /mob/living/simple_animal/silk_worm (loc)
	qdel(src)
	return

/obj/item/silk_worm_cocoon
	name = "\improper silk worm cocoon"
	desc = "grub life in the making."
	icon = 'icons/mob/animal.dmi'
	icon_state = "silk_worm_cocoon"

/obj/item/cooked_silk_worm_cocoon
	name = "\improper cooked silk worm cocoon"
	desc = "YOU KILLED HIM."
	icon = 'icons/mob/animal.dmi'
	icon_state = "silk_worm_cocoon_c"