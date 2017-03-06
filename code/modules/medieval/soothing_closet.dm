
/******
	Soothing Closet = Item to leave the game
	Lost and Found chest = Item where the person who leaves the game item's go
******/

/obj/structure/soothing_closet
	name = "soothing closet"
	desc = "This is a soothing closet, a device built by a wizard long ago to help those who had problems achieving long term sleep, it shall only be used to achieve a status of true rest."
	icon = 'icons/obj/medieval/village.dmi'
	icon_state = "soothing_closet"
	anchored = 1
	density = 0
	opacity = 0
	var/mob/living/carbon/human/holding_human
	var/obj/structure/lost_and_found_chest/LAF //There is only ONE LOST AND FOUND CHEST

/obj/structure/soothing_closet/New()
	..()
	LAF = locate()

/obj/structure/soothing_closet/attack_hand(mob/user as mob)
	if(holding_human)
		Release_Human()
		return
	else
		to_chat(user, "You start getting inside the [src]")
		if(do_after(user, 40, target = src))
			Insert_Human(user)

/obj/structure/soothing_closet/attackby(obj/item/W, mob/user as mob)
	if(istype(W, /obj/item/weapon/grab))
		var/obj/item/weapon/grab/agarre = W
		if(do_after(user, 40, target = src))
			var/mob/living/carbon/human/TOINSERT = agarre.affecting
			Insert_Human(TOINSERT)
			Confirm_Logout(TOINSERT)
			user.drop_item()
	if(holding_human)
		to_chat(user, "The [src] already has a human inside of it!")
		return


/obj/structure/soothing_closet/proc/Release_Human()
	var/dest = locate(src.x, src.y + 1, src.z)
	holding_human.loc = dest
	holding_human.Stun(2)
	holding_human.Weaken(2)
	visible_message("[holding_human] drops out of the [src]")
	holding_human = null
	icon_state = "soothing_closet"
	update_icon()

/obj/structure/soothing_closet/proc/Insert_Human(mob/toinsert as mob)
	toinsert.loc = src
	holding_human = toinsert
	icon_state = "soothing_closet_closed"
	update_icon()
	Confirm_Logout(toinsert)

/obj/structure/soothing_closet/proc/Confirm_Logout(mob/user as mob)
	var/alertmsg = "Are you sure you want to ghost? All your items will be sent to the lost and found chest"
	var/response = alert(user, alertmsg,"Ghost?","Yes","No")
	if(response == "No")
		Release_Human()
		return

	if(!LAF)
		LAF = locate()

	job_master.FreeRole(user.mind.assigned_role)
	//user.resting = 1

	flick("soothing_closet_working", src)

	var/obj/item/ITEMS

	for(ITEMS in user.contents)
		if(ITEMS.type in subtypesof(/obj/item/organ)) //If the item is an organ it does not go to the lost and found
			continue
		else
			user.unEquip(ITEMS)
			ITEMS.loc = src
			ITEMS.loc = LAF

	user.ghostize(0)
	log_admin("[key_name(user)] used the [src] and is now a ghost")
	message_admins("[key_name(user)] used the [src] and is now a ghost")
	qdel(user)

	holding_human = null
	icon_state = "soothing_closet"
	update_icon()



/obj/structure/soothing_closet/New()
	..()

/obj/structure/lost_and_found_chest
	name = "lost and found chest"
	desc = "A chest with some lost and found items."
	icon = 'icons/obj/medieval/village.dmi'
	icon_state = "lost_and_found1"
	var/locked = 1
	//var/list/items = list()

/obj/structure/lost_and_found_chest/Destroy()
	return

/obj/structure/lost_and_found_chest/attack_hand(mob/user as mob)
	if(locked)
		to_chat(user, "The [src] is locked")
		return

	var/obj/item/inputting = input("Choose an item to take out", null) in src.contents
	if(inputting)
		inputting.loc = user.loc
		user.put_in_hands(inputting)
		return

/obj/structure/lost_and_found_chest/proc/Switch_State()
	locked = !locked
	icon_state = "lost_and_found[locked]"
	update_icon()