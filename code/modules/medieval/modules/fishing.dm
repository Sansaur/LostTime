/****

* La idea es hacer que las cañas tengan "Pescados que pueden pescar", al atacar un agua, se mirará en que zona
está el agua (Si es en el castillo, no se pesca nada), si el agua esta en un lugar correcto, se vuelve a una
funcion de la caña en la que la caña elige un pescado de los disponibles.

*

*

****/
var/list/Generic_Fish = list(
						/obj/item/weapon/reagent_containers/food/snacks/fish/salmon,
						/obj/item/weapon/reagent_containers/food/snacks/fish/goldfish
						)



/obj/item/weapon/fishing_rod
	name = "fishing rod"
	desc = "A rod to fish"
	icon = 'icons/medieval/fishing.dmi'
	icon_state = "wood_rod"
	force = 9
	w_class = 4
	throwforce = 8
	throw_range = 4
	var/list/obj/item/weapon/reagent_containers/food/snacks/fish/ALLOWED_FISH = list()

/obj/item/weapon/fishing_rod/New()
	..()
	ALLOWED_FISH += Generic_Fish

/obj/item/weapon/fishing_rod/proc/attempt_fish(mob/user as mob, var/turf/SUELO)
	//This is the method that attempts to fish
	if(!user)
		return
	if(!user.loc)
		return
	if(istype(user.loc, /turf/simulated/floor/beach/water))
		to_chat(user, "You cannot fish while swimming")
		return

	visible_message("[user] begins fishing...")
	if(do_after(user, 40, target=SUELO))
		if(prob(50))
			visible_message("The fish escaped!")
			return
		else
			var/FISH = pick(ALLOWED_FISH)
			new FISH(user.loc)
			visible_message("[user] managed to catch a [FISH]!")
			return


// A PARTIR DE AQUI VAN LOS PECES

/obj/item/weapon/reagent_containers/food/snacks/fish
	name = "a fish!"
	desc = "YOU SHOULDN'T BE SEEING THIS FISH, TELL A CODER, QUICK!!!"
	icon = 'icons/medieval/fishing.dmi'
	icon_state = "fish_base"
	filling_color = "#FFDEFE"
	bitesize = 6
	list_reagents = list("protein" = 3, "nutriment" = 3)

/obj/item/weapon/reagent_containers/food/snacks/fish/salmon
	name = "salmon"
	desc = "It's red and pink"
	icon_state = "salmon"
	w_class = 4

/obj/item/weapon/reagent_containers/food/snacks/fish/goldfish
	name = "goldfish"
	desc = "It's so tiny"
	icon_state = "goldfish"
	w_class = 1