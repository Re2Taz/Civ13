/obj/item/clothing/shoes/magboots
	desc = "Magnetic boots, often used during extravehicular activity to ensure the user remains safely attached to the vehicle. They're large enough to be worn over other footwear."
	name = "magboots"
	icon_state = "magboots0"
	species_restricted = null
	force = 3
	overshoes = TRUE
	var/magpulse = FALSE
	var/icon_base = "magboots"
	action_button_name = "Toggle Magboots"
	var/obj/item/clothing/shoes/shoes = null	//Undershoes
	var/mob/living/human/wearer = null	//For shoe procs

/obj/item/clothing/shoes/magboots/proc/set_slowdown()
	slowdown = shoes? max(SHOES_SLOWDOWN, shoes.slowdown): SHOES_SLOWDOWN	//So you can't put on magboots to make you walk faster.
	if (magpulse)
		slowdown += 3

/obj/item/clothing/shoes/magboots/attack_self(mob/user)
	if (magpulse)
		item_flags &= ~NOSLIP
		magpulse = FALSE
		set_slowdown()
		force = WEAPON_FORCE_WEAK
		if (icon_base) icon_state = "[icon_base]0"
		user << "You disable the mag-pulse traction system."
	else
		item_flags |= NOSLIP
		magpulse = TRUE
		set_slowdown()
		force = WEAPON_FORCE_PAINFUL
		if (icon_base) icon_state = "[icon_base]1"
		user << "You enable the mag-pulse traction system."
	user.update_inv_shoes()	//so our mob-overlays update
	user.update_action_buttons()

/obj/item/clothing/shoes/magboots/mob_can_equip(mob/user)
	var/mob/living/human/H = user

	if (H.shoes)
		shoes = H.shoes
		if (shoes.overshoes)
			user << "You are unable to wear \the [src] as \the [H.shoes] are in the way."
			shoes = null
			return FALSE
		H.drop_from_inventory(shoes)	//Remove the old shoes so you can put on the magboots.
		shoes.forceMove(src)

	if (!..())
		if (shoes) 	//Put the old shoes back on if the check fails.
			if (H.equip_to_slot_if_possible(shoes, slot_shoes))
				shoes = null
		return FALSE

	if (shoes)
		user << "You slip \the [src] on over \the [shoes]."
	set_slowdown()
	wearer = H
	return TRUE

/obj/item/clothing/shoes/magboots/dropped()
	..()
	var/mob/living/human/H = wearer
	if (shoes)
		if (!H.equip_to_slot_if_possible(shoes, slot_shoes))
			shoes.forceMove(get_turf(src))
		shoes = null
	wearer = null

/obj/item/clothing/shoes/magboots/examine(mob/user)
	..(user)
	var/state = "disabled"
	if (item_flags & NOSLIP)
		state = "enabled"
	user << "Its mag-pulse traction system appears to be [state]."