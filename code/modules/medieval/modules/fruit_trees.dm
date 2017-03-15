/obj/structure/flora/tree/fruit_tree
	name = "tree"
	desc = "It's a tree"
	pixel_x = 0
	var/RESULT_FRUIT = /obj/item/weapon/reagent_containers/food/snacks/grown/lime
	var/growing = 0
	var/growth_rate = 100	//Higher is slower
	icon = 'icons/obj/flora/ausflora.dmi'
	icon_state = "pointybush_4"
	var/is_sapling = 1
/obj/structure/flora/tree/fruit_tree/New()
	..()
	sleep(20)
	Grow()

/obj/structure/flora/tree/fruit_tree/proc/Grow()
	sleep(growth_rate)
	growing++
	if(growing >= 100 && is_sapling)
		pixel_x = -16
		icon = 'icons/misc/beach2.dmi'
		icon_state = "palm2"
		is_sapling = 0


	if(growing >= 300)
		OldTree()
		return

	Grow()

/obj/structure/flora/tree/fruit_tree/attack_hand(mob/user as mob)
	if(growing >= 100)
		new RESULT_FRUIT (user.loc)


/obj/structure/flora/tree/fruit_tree/apple
	RESULT_FRUIT = /obj/item/weapon/reagent_containers/food/snacks/grown/apple
/obj/structure/flora/tree/fruit_tree/lime
	RESULT_FRUIT = /obj/item/weapon/reagent_containers/food/snacks/grown/lime
/obj/structure/flora/tree/fruit_tree/lemon
	RESULT_FRUIT = /obj/item/weapon/reagent_containers/food/snacks/grown/lemon
/obj/structure/flora/tree/fruit_tree/cherries
	RESULT_FRUIT = /obj/item/weapon/reagent_containers/food/snacks/grown/cherries
/obj/structure/flora/tree/fruit_tree/orange
	RESULT_FRUIT = /obj/item/weapon/reagent_containers/food/snacks/grown/orange
/obj/structure/flora/tree/fruit_tree/banana
	RESULT_FRUIT = /obj/item/weapon/reagent_containers/food/snacks/grown/banana