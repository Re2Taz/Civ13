/obj/structure/skeleton_activator
	name = "Activate Skeletons"
	desc = "Activate the skeletons."
	icon = 'icons/obj/decals.dmi'
	icon_state = "woodsign"
	anchored = TRUE
	density = TRUE

/obj/structure/skeleton_activator/attack_hand(mob/living/user)
	for (var/obj/effect/spawner/mobspawner/skeletons/SK)
		SK.activated = 1
	for (var/obj/effect/spawner/mobspawner/attacker/SKA)
		SKA.activated = 1
	return

/obj/structure/skeleton_deactivator
	name = "Deactivate Skeletons"
	desc = "Deactivate the skeletons."
	icon = 'icons/obj/decals.dmi'
	icon_state = "woodsign"
	anchored = TRUE
	density = TRUE

/obj/structure/skeleton_deactivator/attack_hand(mob/living/user)
	for (var/obj/effect/spawner/mobspawner/skeletons/SK)
		SK.activated = 0
		SK.spawnerproc()
	for (var/obj/effect/spawner/mobspawner/attacker/SKA)
		SKA.activated = 0
		SKA.spawnerproc()
	return