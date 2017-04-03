/obj/structure/foundations
	name = "foundations"
	desc = "Now you only have to put floor or bricks on top of this"
	icon = 'icons/obj/medieval/village.dmi'
	icon_state = "foundations0"
	opacity = 0
	density = 0
	anchored = 1

	var/needs_cement = 1
	var/current_cement = 0
	var/ready_to_wall = 0

	var/cement_needed = 20
	var/floor_materials = 1
	var/materials_needed = 10
	var/splatter_time = 30
	var/mineral_materials_needed = 20	//Gold walls and the such may cost differently

	var/working = 0

/obj/structure/foundations/attackby(obj/item/W, mob/user as mob)
	if(istype(W, /obj/item/weapon/cement_spade))
		var/obj/item/weapon/cement_spade/M = W
		if(working)
			return
		if(!needs_cement)
			to_chat(user, "<span class=warning> There's no need for more cement </span>")
			update_icon()
			return
		if(M.cement <= 0)
			return

		working = 1
		to_chat(user, "<span class=info> You begin flattening the cement over the [src] </span>")
		if(do_after(user, splatter_time, target=src))
			to_chat(user, "<span class=info> you splatter some cement all over the foundations </span>")
			src.current_cement += M.cement
			M.lose_cement()
			check_cement()
			working = 0
			update_icon()
			return
		else
			to_chat(user, "You stop working")
			working = 0
			update_icon()
			return



	// This may be fixed by adding a wall type to the sheet object, but oh well...
	// I am not a person right now. - Sansaur

	// WOOD WILL NEED IT'S OWN STUFF
	if(istype(W, /obj/item/weapon/wood_plank))
		if(!ready_to_wall)
			to_chat(user, "<div class=warning> [src] is not ready to get built on! </div>")
			return
		new /obj/structure/foundations/wood (src.loc)
		qdel(W)
		qdel(src)

	// WOOD WILL NEED IT'S OWN STUFF

	if(istype(W, /obj/item/stack/sheet/stone_bricks))
		if(!ready_to_wall)
			to_chat(user, "<div class=warning> [src] is not ready to get built on! </div>")
			return
		var/obj/item/stack/sheet/stone_bricks/MyStack = W
		// This will need more checks - Sansaur
		if(isturf(loc))
			if(MyStack.use(materials_needed))
				var/turf/Location = loc
				Location.ChangeTurf(/turf/simulated/wall/mineral/stone)
				qdel(src)
				return
			else
				to_chat(user, "There's not enough materials in the [MyStack]")
				update_icon()
				return

	if(istype(W, /obj/item/stack/sheet/metal))
		if(!ready_to_wall)
			to_chat(user, "<div class=warning> [src] is not ready to get built on! </div>")
			return
		var/obj/item/stack/sheet/metal/MyStack = W
		// This will need more checks - Sansaur
		if(isturf(loc))
			if(MyStack.use(materials_needed))
				var/turf/Location = loc
				Location.ChangeTurf(/turf/simulated/wall/mineral/iron)
				qdel(src)
				return
			else
				to_chat(user, "There's not enough materials in the [MyStack]")
				update_icon()
				return

	if(istype(W, /obj/item/stack/sheet/mineral/silver))
		if(!ready_to_wall)
			to_chat(user, "<div class=warning> [src] is not ready to get built on! </div>")
			return
		var/obj/item/stack/sheet/mineral/silver/MyStack = W
		// This will need more checks - Sansaur
		if(isturf(loc))
			if(MyStack.use(mineral_materials_needed))
				var/turf/Location = loc
				Location.ChangeTurf(/turf/simulated/wall/mineral/silver)
				qdel(src)
				update_icon()
				return
			else
				to_chat(user, "There's not enough materials in the [MyStack]")
				update_icon()
				return

	if(istype(W, /obj/item/stack/sheet/mineral/gold))
		if(!ready_to_wall)
			to_chat(user, "<div class=warning> [src] is not ready to get built on! </div>")
			return
		var/obj/item/stack/sheet/mineral/gold/MyStack = W
		// This will need more checks - Sansaur
		if(isturf(loc))
			if(MyStack.use(mineral_materials_needed))
				var/turf/Location = loc
				Location.ChangeTurf(/turf/simulated/wall/mineral/gold)
				qdel(src)
				update_icon()
				return
			else
				to_chat(user, "There's not enough materials in the [MyStack]")
				update_icon()
				return

	if(istype(W, /obj/item/stack/sheet/mineral/sandstone))
		if(!ready_to_wall)
			to_chat(user, "<div class=warning> [src] is not ready to get built on! </div>")
			return
		var/obj/item/stack/sheet/mineral/sandstone/MyStack = W
		// This will need more checks - Sansaur
		if(isturf(loc))
			if(MyStack.use(mineral_materials_needed))
				var/turf/Location = loc
				Location.ChangeTurf(/turf/simulated/wall/mineral/sandstone)
				qdel(src)
				update_icon()
				return
			else
				to_chat(user, "There's not enough materials in the [MyStack]")
				update_icon()
				return

	if(istype(W, /obj/item/stack/sheet/mineral/diamond))
		if(!ready_to_wall)
			to_chat(user, "<div class=warning> [src] is not ready to get built on! </div>")
			return
		var/obj/item/stack/sheet/mineral/diamond/MyStack = W
		// This will need more checks - Sansaur
		if(isturf(loc))
			if(MyStack.use(mineral_materials_needed))
				var/turf/Location = loc
				Location.ChangeTurf(/turf/simulated/wall/mineral/diamond)
				qdel(src)
				update_icon()
				return
			else
				to_chat(user, "There's not enough materials in the [MyStack]")
				update_icon()
				return

	else
		..()

/obj/structure/foundations/proc/check_cement()
	if(current_cement >= cement_needed)
		needs_cement = 0
		ready_to_wall = 1
	else
		needs_cement = 1

/obj/structure/foundations/update_icon()
	if(ready_to_wall)
		icon_state = "foundations_ready"
		return
	else
		icon_state = "foundations[needs_cement]"
		return

/obj/item/foundations
	name = "foundations"
	desc = "It's time to get crafty!"
	icon = 'icons/obj/items.dmi'
	icon_state = "foundations"
	w_class = 5

/obj/item/foundations/attack_self(mob/user as mob)
	if(isturf(user.loc))	//Can only put construction on plain grass or cave floor, for now - Sansaur. Also, this could be a list.
		if(istype(user.loc, /turf/simulated/floor/grass) || istype(user.loc, /turf/simulated/floor/stone/mine))
			to_chat(user, "<div class=info> You plant the [src] on the ground </div>")
			new /obj/structure/foundations (loc.loc)
			user.drop_item()
			qdel(src)

	else
		to_chat(user, "<div class=warning> You cannot put these here </div>")

/obj/structure/foundations/wood
	name = "wood foundations"
	desc = "These are ready to become a wooden wall"
	icon = 'icons/obj/medieval/village.dmi'
	icon_state = "wood_foundations1"
	opacity = 0
	density = 0
	anchored = 1
	var/wood = 1

/obj/structure/foundations/wood/attackby(obj/item/W, mob/user as mob)
	if(istype(W, /obj/item/weapon/wood_plank))
		if(wood >= 5)
			user.drop_item()
			to_chat(user, "<div class=info> you add some wood to the [src]")
			wood++
			qdel(W)
			var/turf/Location = loc
			Location.ChangeTurf(/turf/simulated/wall/mineral/wood)
			update_icon()
			to_chat(user, "<div class=info> [src] is finally built! </div>")
			qdel(src)
			return
		else
			user.drop_item()
			to_chat(user, "<div class=info> you add some wood to the [src]")
			wood++
			update_icon()
			qdel(W)
			return
	else
		..()

/obj/structure/foundations/wood/update_icon()
	icon_state = "wood_foundations[wood]"