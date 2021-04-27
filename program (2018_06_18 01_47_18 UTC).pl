:- dynamic i_am_at/1, at/2, holding/1, atStatic/2, bill/1, billstatus/1, path/3, pit/1, water/1, good/1.
/*I did the below line to ignore warnings*/
:- discontiguous describe/1, atStatic/2, take/1, at/2, use/2.



/*











If you are reading this and haven't played the game from scratch yet, PLEASE GO BACK AND PLAY THE GAME FIRST!



There are spoilers just by looking at the code, so try the game out first and only look if you are stuck or 
if you've finished the game!











*/


i_am_at(main).

path(main, n, center).
path(center, s, main).
path(center, e, kitchen).
path(center, w, room).
path(room, e, center).
path(room, s, carving).
path(carving, n, room).
path(kitchen, w, center).
path(kitchen, s, store).
path(store, n, kitchen).
path(store, e, mine).
path(mine, w, store).

at(bill, main).
water(nothing).
billstatus(start).

/* These rules describe how to pick up an object. */

duck(bill).
take(X) :-
	i_am_at(Place),
        at(X, Place),
	duck(X),
	write('*Peck* "Ow!" Bill doesn''t want to be picked up.'),
	nl.

pit(pit).
take(X) :-
	i_am_at(Place),
        at(X, Place),	
	pit(X),
	write('Are you stupid? How exactly do you expect to pick up a fire pit?'),
	nl.

knife(knife).
take(X) :-
	i_am_at(Place),
        at(X, Place),	
	knife(X),
	retract(at(X, Place)),
        assert(holding(X)),
	write('"This is just for self defense." You tell yourself, trying to stop your hand from shaking. You feel the hard grip of the knife in your hands. Dark thoughts swirl in your mind.'), nl,
	(at(bill, Place) -> write('Bill looks scared.'), nl; true),
	nl.

take(X) :-
        holding(X),
        write('You''re already holding it!'),
        nl.

take(X) :-
        i_am_at(Place),
        at(X, Place),
	retract(at(X, Place)),
        assert(holding(X)),
        write('OK.'),
        nl.

take(_) :-
        write('I don''t see it here.'),
        nl.


/* These rules describe how to put down an object. */

drop(X) :-
        holding(X),
        i_am_at(Place),
        retract(holding(X)),
        assert(at(X, Place)),
        write('OK.'),
        nl.

drop(_) :-
        write('You aren''t holding it!'),
        nl.


/* These rules describe how to examine. */

/*Bill*/
examine(bill) :-
	i_am_at(Place),
	at(bill, Place),
	write('Bill seems happy following you along.'), nl,
	nl.

/*Bucket*/
examine(object) :-
	i_am_at(Place),
	atStatic(object, Place),
	write('Walking closer to the metallic object, you see that it is a [bucket].'), nl,
	assert(at(bucket, Place)),
	retract(atStatic(object, Place)),
	notice_objects_at(Place),
	nl.

/*Fountain*/
examine(fountain) :-
	i_am_at(Place),
	atStatic(fountain, Place),
	write('You walk up to the fountain. It is about three times your height with tiers of stone bowls decorating the center. Unfortunately, it looks like it''s all dried up. You feel thirsty. Desperate, you climb up the stone bowls to see if there is water in the bowls above you. You don''t find a single drop of water, but you do see a box of [matches] in the topmost bowl.'), nl,
	assert(at(matches, Place)),
	retract(atStatic(fountain, Place)),
	(at(bill, Place) ->
		assert(at(bill, kitchen)),
		retract(at(bill, Place)),
		write('\nWhile you were investigating the fountain, Bill seems to have run off to the east to explore. At least someone has an adventurous spirit.'), nl, nl; nl),
	notice_objects_at(Place),
	nl.

/*Straw (and Hiding Bill)*/
examine(straw) :-
	i_am_at(Place),
	(atStatic(hidingBill, Place) ->
		write('Bill comes out from hiding in the straw. You apologize and after a few minutes, he warms up to you again. You apologize again just in case.'), nl, nl,
		retract(atStatic(hidingBill, Place)),
		assert(at(bill, Place)); true),
	atStatic(straw, Place),
	write('While looking through the straw, you notice a small, shiny object. You clear away the straw. You find a [key].'), nl, nl,
	assert(holding(key)),
	retract(atStatic(straw, Place)),
	notice_objects_at(Place),
	nl.

/*Hook*/
examine(up) :-
	i_am_at(Place),
	atStatic(hook, Place),
	write('Looking up and squinting your eyes against the sunlight from above, you notice a shiny object reflecting more light at you. You climb a few feet up and get a metal grappling [hook]. What''s this doing here?'), nl, nl,
	assert(holding(hook)),
	retract(atStatic(hook, Place)),
	notice_objects_at(Place),
	nl.

/*Hole*/
examine(hole) :-
	i_am_at(Place),
	atStatic(hole, Place),
	(holding(ore) ->
		write('You hear a voice through the hole. "You know the deal, give me the ore and I''ll give you spices." Not seeing any use for the ore, you give it to him and get [spices].'), assert(holding(spices)), retract(holding(ore)),
		(holding(vegetables) -> 
			write('\nTogether with the vegetables that you got earlier, they become [ingredients].'), retract(holding(spices)), retract(holding(vegetables)), assert(holding(ingredients)); true);
		write('As you walk closer to the hole, a voice comes through from the other side. "Give me ore." You are unsure who was on the other side, but you might as well start looking for some ore.')),
	nl.

/*Seat*/
examine(seat) :-
	i_am_at(Place),
	atStatic(seat, Place),
	write('You sit down to take a break. A few minutes later you stand up again. Back to figuring out what''s going on here!'),
	nl.

examine(_) :-
	write('That''s not here.'),
	nl.


/* These rules define how to use objects on things */

use(bucket, water) :-
	i_am_at(Place),
	atStatic(water, Place),
	holding(bucket),
	write('You follow your ears to find where the water is dripping from. You find it and put the bucket underneath. After a little while of waiting, the bucket fills up with water. You collect the [waterbucket]'), nl,
	assert(holding(waterbucket)),
	retract(holding(bucket)),
	notice_objects_at(Place),
	nl.
use(bucket, corner) :-
	i_am_at(Place),
	atStatic(water, Place),
	holding(bucket),
	write('You follow your ears to find where the water is dripping from. You find it and put the bucket underneath. After a little while of waiting, the bucket fills up with water. You collect the [waterbucket]'), nl,
	assert(holding(waterbucket)),
	retract(holding(bucket)),
	notice_objects_at(Place),
	nl.

/*Carrots on Bill*/
use(carrots, bill) :-
	holding(carrots),
	i_am_at(Place),
	at(bill, Place),
	write('You give the carrots to Bill. He quickly eats it all up, not even leaving a crumb. He looks fat and happy now.'), nl,
	retract(holding(carrots)),
	assert(bill(fat)),
	nl.

/*Grappling Hook*/
use(rope, hook) :-
	holding(hook),
	holding(rope),
	write('You tie the rope on the hook and make a [grapplinghook].'), nl,
	retract(holding(hook)),
	retract(holding(rope)),
	assert(holding(grapplinghook)),
	nl.

use(hook, rope) :-
	holding(hook),
	holding(rope),
	write('You tie the rope on the hook and make a [grapplinghook].'), nl,
	retract(holding(hook)),
	retract(holding(rope)),
	assert(holding(grapplinghook)),
	nl.

/*Grappling Hook to climb*/
use(grapplinghook, up) :-
	holding(grapplinghook),
	i_am_at(main),
	write('You swing the grappling hook up, but you can''t throw it high enough.'), nl,
	nl.

/*Grappling Hook on Bill*/
use(grapplinghook, bill) :-
	holding(grapplinghook),
	i_am_at(Place),
	at(bill, Place),
	(bill(fat) -> 
		write('You swing the grappling hook and let it loose on Bill. Bill is too slow and his wing gets hooked, rendering him immobile.'), assert(bill(immobile)), retract(bill(fat));
		write('You swing the grappling hook and let it loose on Bill. Bill deftly dodges out of the way, pecks you, and runs away.'), assert(atStatic(hidingBill, room)), retract(at(bill, Place))),
	nl.

/*Knife on Bill*/
use(knife, bill) :-
	holding(knife),
	i_am_at(Place),
	at(bill, Place),
	(billstatus(end), bill(immobile) ->
		write('You stab the immobile Bill. You feel bad, but you are also hungry. You get [duck]. While you carve the duck, you find a pair of [glasses] inside. How strange! You clean them off and put them on. You don''t have a mirror, but you''re pretty sure you look awesome.'), 
		retract(at(bill, Place)), assert(holding(duck)), assert(holding(glasses));
		true),
	(billstatus(start), bill(immobile) ->
		write('Bill is cowering in fear. You hesitate for a moment. Do you really want to do this?'), nl, nl,
		retract(billstatus(start)), assert(billstatus(end));
		write('The second you pull out the knife, Bill runs away.'), assert(atStatic(hidingBill, room)), retract(at(bill, Place))),
	nl.

/*Pickaxe on Ore Vein*/
use(pickaxe, vein) :-
	holding(pickaxe),
	i_am_at(Place),
	atStatic(vein, Place),
	write('You spend some time mining the ore vein and get some [ore].'),
	assert(holding(ore)),
	nl.
use(pickaxe, ore) :-
	holding(pickaxe),
	i_am_at(Place),
	atStatic(vein, Place),
	write('You spend some time mining the ore vein and get some [ore].'),
	assert(holding(ore)),
	nl.

/*Straw on fire pit*/
use(straw, pit) :-
	holding(straw),
	i_am_at(Place),
	at(pit, Place),
	write('You lay straw on the unlit fire pit.'),
	retract(holding(straw)),
	assert(pit(straw)),
	nl.

/*Matches on fire pit*/
use(matches, pit) :-	
	holding(matches),
	i_am_at(Place),
	at(pit, Place),
	(pit(straw) ->
		write('The fire pit lights up. Now you have a working fire pit started. At least it''s warmer now.'),
		assert(pit(fire)), retract(holding(matches)), retract(pit(straw));
		write('There''s nothing to light on fire except the ground.')),
	nl.

/*Water Bucket on fire pit*/
use(waterbucket, pit) :-
	holding(waterbucket),
	i_am_at(Place),
	at(pit, Place),
	(pit(fire) ->
		write('You put the water bucket on the fire. It starts boiling. It is now [boilingwater]'), assert(water(boiling)), retract(holding(waterbucket)), retract(pit(fire));
		write('You put the water bucket on the fire pit. There is no fire, so the water is still cold.')),
	nl.

/*Ingredients on boiling water*/
use(ingredients, boilingwater) :-
	holding(ingredients),
	water(boiling),
	i_am_at(Place),
	at(pit, Place),
	write('You put the ingredients in the boiling water. A few moments later, a pleasant aroma fills the room. It reminds you that you are hungry. It is now [seasonedwater].'),
	assert(water(seasoned)),
	retract(water(boiling)),
	retract(holding(ingredients)),
	nl.
	
/*Duck on seasoned water*/
use(duck, seasonedwater) :-
	holding(duck),
	water(seasoned),
	i_am_at(Place),
	at(pit, Place),
	write('You put the duck into the seasoned water. The [soup] looks delicious. You are ravenous now.'), nl,
	assert(water(soup)),
	retract(holding(duck)),
	retract(water(seasoned)),
	nl.

use(_,_) :-
	write('That doesn''t make sense, try something else.'),
	nl.

/* These rules define the direction letters as calls to go/1. */

n :- go(n).

s :- go(s).

e :- go(e).

w :- go(w).


/* This rule tells how to move in a given direction. */

go(Direction) :-
        i_am_at(Here),
        path(Here, Direction, There),
        retract(i_am_at(Here)),
        assert(i_am_at(There)),
	(at(bill, Here) ->
	retract(at(bill, Here)),
	assert(at(bill, There)); true),
        look.

go(_) :-
        write('You can''t go that way.').


/* This rule tells how to look about you. */

look :-
        i_am_at(Place),
        describe(Place),
        nl,
        notice_objects_at(Place),
        nl.


/* These rules set up a loop to mention all the objects
   in your vicinity. */

notice_objects_at(Place) :-
        at(X, Place),
        write('There is '), write(X), write(' here.'), nl,
        fail.

notice_objects_at(_).

inventory :-
	write('Inventory: '), nl,
	holding(X),
        write(X), nl,
	fail.


/* This rule tells how to die. */

die :-
        finish.


/* Under UNIX, the "halt." command quits Prolog but does not
   remove the output window. On a PC, however, the window
   disappears before the final output can be seen. Hence this
   routine requests the user to perform the final "halt." */

finish :-
        nl,
        write('The game is over. Please enter the "halt." command.'),
        nl.


/* This rule just writes out game instructions. */

instructions :-
        nl,
        write('Enter commands using standard Prolog syntax.'), nl,
        write('Available commands are:'), nl,
        write('start.           	-- to start the game.'), nl,
        write('n.  s.  e.  w.    	-- to go in that direction.'), nl,
        write('take(Object).     	-- to pick up an object.'), nl,
        write('drop(Object).     	-- to put down an object.'), nl,
	write('examine(Object).	  	-- to examine an object.'), nl,
	write('use(Object, Person).	-- to give an object to a person.'), nl,
        write('look.           		-- to look around you again.'), nl,
	write('inventory.		-- to view what items you are holding. Ignore the fail message at the end.'), nl,
        write('instructions.    	-- to see this message again.'), nl,
        write('halt.            	-- to end the game and quit.'), nl, nl,
	write('There are also some secret commands. Find them to finish the story!'), nl,
	write('Note that there is a good end and a bad end!'), nl,
	write('Type hint. if you need a hint!'), nl,
        nl.

hint :-
	write('You are hungry, so you also should try to eat(things).'), nl.


/* This rule prints out instructions and tells where you are. */

start :-
        write('Anyone Home?'), nl,
	write('By Nicholas Chin'), nl,
	write('May not be suitable for children.'), nl,
	write('Inspired by Lost Pig'), nl,
	instructions,
        look.


/* These rules describe the various rooms.  Depending on
   circumstances, a room may have more than one description. */

/* MAIN ROOM */
atStatic(first, main).
atStatic(hook, main).
at(rope, main).
describe(main) :- 
	(atStatic(first, main) ->
		write('Your grumbling stomach wakes you up. You are lying down at the bottom of a well. How did you get here? You rub the back of your head and feel a small bump. You must have fallen down here, but you can''t really remember anything.\n\n"Quack!" You turn towards the noise and, squinting your eyes in the darkness, see a duck sitting on the ground next to you. It seems friendly. You name the duck Bill. It quacks in affirmation at your decision.');
		write('You are back at the initial room.')), nl, nl,
	(at(rope, main) ->
		write('Strewn all over the ground is a long twine [rope].'), nl, nl; true),
	(atStatic(hook, main) ->
		write('You look up. Hmm that''s interesting.'), nl, nl; true),
	write('Looking around the small alcove surrounding you, all you see is a winding path to the north. A faint purple light seems to be emanating from that direction.'), nl, 	
	(atStatic(first, main) ->
		write('You shiver in anticipation and wonder what awaits you there.'), nl,
		retract(atStatic(first, main)); true),
	nl.

/* CENTER ROOM */
atStatic(object, center).
atStatic(fountain, center).
atStatic(water, center).
describe(center) :-
	(at(bill, center) ->
		write('You follow the path, Bill following along behind you, and eventually emerge into a wide, open room. The sound of silence is only interrupted by water dripping from the ceiling somewhere in a corner of the room and the footsteps of you and Bill.'), nl, nl; true),
	write('Crystals hang from the high ceilings, illuminating your environment. In the center is a large water fountain. You wonder why a water fountain would be here. The sound of water dripping is rhythmic and calms you.'), nl, nl,
	(atStatic(object, center) ->
		write('Some metallic looking object in the far corner of the room distracts you from the water fountain for a second before you continue looking around.'), nl, nl; true),
	(holding(glasses) ->
		write('Strangely enough, you see an opening to the north that you didn''t see before.'), 
		retract(holding(glasses)), assertz(path(center, n, secret)), assertz(path(secret, s, center)), nl, nl; true),
	(path(center, n, secret) ->
		write('There is a path north.'), nl, nl; true),
	write('There is a path leading to the east and to the west, as well as the path you just came from in the south. Your stomach again rumbles.'), nl.

/* KITCHEN */
at(carrots, kitchen).
at(pit, kitchen).
atStatic(seat, kitchen).
describe(kitchen) :-
	write('You arrive at a more decorated area. There is a circular, flat stone about the height of your waist that looks like a seat placed down. It sits next to a fire [pit] dug into the ground.'), nl, nl,
	(pit(straw) ->
		write('The pit is filled with some straw. Looks flammable.'), nl, nl;
		write('The embers are cooled, but they look fresh. Is someone down here with you? As if sharing your thoughts, Bill shivers in fear and rubs up against your leg for comfort.'), nl, nl),
	(pit(fire) ->
		write('There is now a fire in the fire pit. Things are just as they should be.'), nl, nl; true),
	(water(boiling) ->
		write('The water is boiling in the bucket. Time to add ingredients!'), nl, nl; true),
	(water(seasoned) ->
		write('The spices and vegetables smell delicious! If only it had some meat added to it as well; then it could truly be called soup.'), nl, nl; true),
	(water(soup) ->
		write('The soup smells delicious! You can''t wait to eat it!'), nl, nl; true),
	(at(carrots, kitchen) ->
		write('You look past the fire pit and see some [carrots] lying on a stone countertop. Bill looks up at it, clearly interested.'), nl, nl; true),
	(holding(key) ->
		write('Looking more carefully around the walls, you see a small key hole. You use the key and the wall parts to reveal a path to the north.'), nl, nl,
		assertz(path(kitchen, n, garden)), assertz(path(garden, s, kitchen)), retract(holding(key)); true),
	(path(kitchen, n, garden) ->
		write('There is a path north.'), nl, nl; true),
	write('There is another path to the south, you hear faint music coming from that direction. The only other path is back to the room in the west.'), nl.

/* ROOM */
at(straw, room).
at(knife, room).
atStatic(straw, room).
describe(room) :-
	write('Immediately, you see what you can only assume is a bedroom of sorts. A large pile of [straw] in the corner of the room is slightly flattened, indicating someone may have been sleeping there. But since when was it last used? Are you intruding in someone''s home?'), nl, nl,
	(at(knife, room) ->
		write('You then see something that sends chills down your spine. A small, sharp [knife] is lying on a stone table next to the pile of straw. It makes you feel uneasy.'), nl, nl; true),
	write('There is a path leading to the south. There is also the path to the east which will take you back to the room with the fountain.'), nl, nl,
	atStatic(hidingBill, room) ->
		write('You see rustling in the straw bed.'), nl; true, nl.

/* STORE */
atStatic(hole, store).
describe(store) :-
	write('You are taken to a small room. You hear the faint music from before coming from some small holes in the ceiling. The music calms you a bit'),
	(at(bill, store) ->
		write(' and to your side, you see Bill dancing, at least you think that''s what he''s doing.'); write('.')), nl, nl,
	write('You see a small hole on the side of the wall. You feel a cold breeze coming from a path to the east. There is also the path back north to the kitchen.'), nl.

/* MINE */
at(pickaxe, mine).
atStatic(vein, mine).
describe(mine) :-
	write('You enter a freezing cold room. It is slightly darker than the other rooms that you''ve been in.'), nl, nl,
	(at(pickaxe, mine) ->
		write('There is a [pickaxe] stuck in a rock nearby. The glint of some sort of green ore vein stretches along the wall nearby.'), nl, nl; true),
	write('There is only a path leading back to the west.'),
	nl.

/* GARDEN */
at(vegetables, garden).
describe(garden) :-
	write('You enter a room with sunlight flowing in from far above. Here, there is also a large field of various [vegetables] being grown. Someone definitely lives here, but who? And when will they be back?'), nl, nl,
	(holding(spices) ->
		write('Together with the spices that you got before, you now have [ingredients].'), nl, nl,
		assert(holding(ingredients)), retract(holding(vegetables)), retract(holding(spices)); true).

/* CARVING */
describe(carving) :-
	write('You step into a room filled with carved statues. They actually look pretty impressive. Actually, they look a little familiar. You wonder who made them.'), nl, nl,
	write('There is nothing else here. The only path is back north.'), nl, nl.

/* SECRET */
describe(secret) :-
	write('You are bewildered by the sight before you. There are a bunch of ducks trapped in cages along with a bunch of duck eggs lying in baskets nearby. Someone must be raising them for food!'), nl, nl,
	assert(good(end)).

/* These are the unspecified eat commands. */
eat(carrots) :-
	holding(carrots),
	write('Ew, you can''t stand the thought of eating carrots.'), nl.

eat(bill) :-
	i_am_at(Place),
        at(bill, Place),
	write('You look hungrily at Bill. Noticing your scary demeanor, Bill runs away. I hope you''re happy, you monster.'), nl, nl,
	assert(atStatic(hidingBill, room)),
	retract(at(bill, Place)),
	notice_objects_at(Place), nl.

eat(vegetables) :-
	holding(vegetables),
	write('They would be flavorless if eaten alone!'), nl.

eat(seasonedwater) :-
	water(seasoned),
	i_am_at(Place),
	at(pit, Place),
	write('What are you, a vegetarian? Meat is essential to a good meal.'), nl.

eat(soup) :-
	water(soup),
	i_am_at(Place),
	at(pit, Place),
	write('Without waiting for the soup to cool, you devour the soup. You gulp down the liquid and soft vegetables. You then take a bite out of the fresh duck. The juices of the meat warm you. Soon enough, you''ve finished it all.'), nl, nl,
	retract(water(soup)), nl,
	afterword.

eat(_) :-
	write('You can''t just eat whatever you want...'), nl.

/* AFTERWORD */
afterword :-
	(good(end) ->
		write('After your delicious meal, you continue searching for an escape, but find nothing. In the meantime, since you haven''t seen anyone here yet, you decide to use the facilities for food and shelter. To keep you company during the lonely search, you let a new duck, which you fondly named Bill 2, follow you. A few weeks pass before you finally give up on finding an escape and resign yourself to living here forever with Bill 25. One year later, you dream about escaping to the world above. This gives you renewed energy to find an escape. You try using the grappling hook at the well entrance. Although you''ve failed at this before, you have to keep trying. Cheered on by Bill 365, you give it one good swing and it finally latches onto something! You start climbing up towards the light. Closer and closer you advance until ... the rope untangles from the hook. You plummet back down to the floor and hit it hard.'), nl, nl,
		write('Your grumbling stomach wakes you up. You are lying down at the bottom of a well. How did you get here? You rub the back of your head and feel a small bump. You must have fallen down here, but you can''t really remember anything.\n\n"Quack!" You turn towards the noise and, squinting your eyes in the darkness, see a duck sitting on the ground next to you. It seems friendly. You name the duck Bill. It quacks in affirmation at your decision.'), nl, nl, nl;
		write('After your delicious meal, you continue searching for an escape, but find nothing. In the meantime, since you haven''t seen anyone here yet, you decide to use the facilities for food and shelter. After a few weeks of failure, you start growing tired of drinking plain vegetable soup every day. "Life isn''t worth it without meat," you decide. You start to regret killing Bill so quickly and wish he were here again. One day, you look at the knife that you used to kill Bill. You made up your mind. The knife is the last thing that you see.'), nl, nl, nl),
	write('Thank you for playing my game!').
