/obj/structure/human_imprinter
	name = "Humanoid Holder"
	desc = "This holds humanoids for their upcoming characteristics printing."
	icon = 'icons/obj/omegacorp_objs.dmi'
	icon_state = "human_imprinter"
	anchored = 1
	density = 1
	opacity = 0
	var/mob/living/carbon/human/holding_human
	var/password
	var/lockdown

/obj/structure/human_imprinter/Destroy()
	Release_Human()
	..()

/obj/structure/human_imprinter/attack_hand(mob/user as mob)
	if(lockdown)
		return
	if(holding_human)
		if(password)
			if(!Enter_Password(user))
				to_chat(user, "The password was incorrect, sending the [src] into lockdown, swipe an ID to unlock it.")
				Lock_This()
				return
			else
				Release_Human()
				return
		else
			Release_Human()
			return
	else
		to_chat(user, "You start getting inside the [src]")
		if(do_after(user, 40, target = src))
			Insert_Human(user)
/obj/structure/human_imprinter/attackby(obj/item/W, mob/user as mob)
	if(lockdown)
		if(istype(W, /obj/item/weapon/card/id))
			visible_message("[user] unlocked the [src] using the [W]")
			Unlock_This()
			return
	if(!password)
		if(istype(W, /obj/item/weapon/card/id))
			Set_Password(user)
			return
	else
		if(istype(W, /obj/item/weapon/card/id))
			to_chat(user, "The password for this machine is: <B>[password]</B>")
			return

	if(istype(W, /obj/item/weapon/grab))
		var/obj/item/weapon/grab/agarre = W
		if(do_after(user, 40, target = src))
			var/mob/living/carbon/human/TOINSERT = agarre.affecting
			Insert_Human(TOINSERT)
			user.drop_item()

	if(holding_human)
		to_chat(user, "The [src] already has a human inside of it!")
		return
	else
		//Insert_Artifact(W, user)

/obj/structure/human_imprinter/proc/Enter_Password(mob/user as mob)
	var/entered_password
	entered_password = input(user, "Enter the password for this [src]", "Password Screen", 0) as num
	if(password == entered_password)
		return 1
	else
		return 0
/obj/structure/human_imprinter/proc/Set_Password(mob/user as mob)
	var/entered_password
	entered_password = input(user, "Enter new password for this machine", "Password Screen", 0) as num
	password = entered_password

obj/structure/human_imprinter/proc/Release_Human()
	var/dest = locate(src.x, src.y - 1, src.z)
	holding_human.loc = dest
	holding_human.Stun(2)
	holding_human.Weaken(2)
	visible_message("[holding_human] drops out of the [src]")
	holding_human = null
	icon_state = "human_imprinter"
	update_icon()

obj/structure/human_imprinter/proc/Insert_Human(mob/toinsert as mob)
	toinsert.loc = src
	holding_human = toinsert
	icon_state = "human_imprinter-holding"
	update_icon()

obj/structure/human_imprinter/proc/Lock_This()
	lockdown = 1
	flick("human_imprinter-locking",src)
	sleep(4)
	icon_state = "human_imprinter-lockdown"
	update_icon()

obj/structure/human_imprinter/proc/Unlock_This()
	lockdown = 0
	flick("human_imprinter-opening",src)
	sleep(4)
	if(holding_human)
		icon_state = "human_imprinter-holding"
	else
		icon_state = "human_imprinter"
	update_icon()



/**
******************************************
*********** HERE GOES THE COMPUTER *******
******************************************

This computer is used at round end to check for a job objective for Omegacorp.
If they had an objective to get someone imprinted, it works like this:

1) Put humanoid into human_imprinter
2) Use this computer and then it adds it to the computer database
3) At round end, it'll check all availible computers of this type and see if the human that was asked for is in any of those
4) ???
5) Profit

-Sansaur

**/

/obj/structure/human_imprinter_comp
	name = "Humanoid Imprinter Computer"
	desc = "Use this to send copies of a humanoid's characteristics to the company. \
			It is also used to store data for the quick species changer."
	icon = 'icons/obj/omegacorp_objs.dmi'
	icon_state = "human_imprinter_comp"
	anchored = 1
	density = 1
	opacity = 0
	var/list/mob/living/carbon/human/scanned_humans = list()

/obj/structure/human_imprinter_comp/attack_hand(mob/user as mob)
	var/obj/item/weapon/card/id/IDS
	if(!IDS in user.contents)
		to_chat(user, "<span class=warning> Access Denied </span>")
		return 0
	else
		to_chat(user, "<B>[src]</B> starts imprinting the humans...")
		sleep(20)
		var/obj/structure/human_imprinter/IMPRINTERS
		for(IMPRINTERS in world)
			var/mob/living/carbon/human/HUMAN = IMPRINTERS.holding_human
			if(HUMAN)
				if(!(HUMAN in scanned_humans))
					scanned_humans.Add(HUMAN)
		flick("human_imprinter_comp-writing",src)
		to_chat(user, "After a short while, they are stored in the database")
		icon_state="human_imprinter_comp-after"
		update_icon()

/obj/structure/human_imprinter_comp/attackby(obj/item/W, mob/user as mob)
	if(istype(W, /obj/item/weapon/card/id))
		Show_Database(user)
		return

/obj/structure/human_imprinter_comp/proc/Show_Database(mob/user as mob)
	var/paperinfo = "<B> Humanoids found on the database: </B> <br>"
	var/i = 1
	for(var/mob/living/carbon/human/human_to_show in scanned_humans) //NO ESTABA LA I INICIALIZADA, ME CAGUEN
		//var/mob/living/carbon/human/human_to_show = scanned_humans[i]
		/* --DEBUG---
		to_chat(user, "Humanoid nº[i]. <br>")
		to_chat(user, "Species: [human_to_show.species.name] <br>")
		to_chat(user, "Gender: [human_to_show.gender] <br>")
		to_chat(user, "Age: [human_to_show.age] <br>")
		to_chat(user, "DNA: [human_to_show.dna.unique_enzymes] <br>")
		to_chat(user, "<hr>")
		 --DEBUG--- */
		paperinfo += "Humanoid nº[i]. <br>"
		paperinfo += "Species: [human_to_show.species.name] <br>"
		paperinfo += "Gender: [human_to_show.gender] <br>"
		paperinfo += "Age: [human_to_show.age] <br>"
		paperinfo += "DNA: [human_to_show.dna.unique_enzymes] <br>"
		paperinfo += "<hr>"
		i++
	//to_chat(user, paperinfo) /* DEBUG */
	var/obj/item/weapon/paper/papelito = new(src.loc)
	papelito.info = paperinfo
	papelito.update_icon()
	user.put_in_hands(papelito)