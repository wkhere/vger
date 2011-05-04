%%-*-prolog-*-

cache(P) :- asserta((P :- !)).
cache_once(P) :- (P -> true; cache(P)).

mvcost(space,    C) :- C=11.
mvcost(nebula,   C) :- C=16.
mvcost(viral,    C) :- C=18.
mvcost(energy,   C) :- C=20.
mvcost(asteroid, C) :- C=25.
mvcost(exotic,   C) :- C=36.

env_base(Env) :- mvcost(Env,_).

mvcost(Env, Drive, X) :- mvcost(Env,C), speed(Drive,Speed), X is C-Speed.

speed(DriveSpeed, S) :- integer(DriveSpeed), !, S=DriveSpeed.
speed(nuclear, S) :- S=1.
speed(fusion,  S) :- S=2.
speed(efusion, S)   :- S=2.
speed(ion, S) :- S=3.
speed(am, S)  :- S=4.
speed(eam, S) :- S=4.
speed(hyper, S) :- S=5.
speed(ip, S)  :- S=6.
speed(eip, S) :- S=6.


:- dynamic env_/4.
env(S, X, Y, V) :- env_(S, X, Y, V).

env(enioar, bbox, 20, 12) :- !.
env(enioar,  8,     0,     wormhole(unused)).
env(enioar,  7-9,   0-1,   energy).
env(enioar,  8,     2,     energy).
env(enioar,  8,     2,     choke(to(7-9,0-1))).
env(enioar,  1,     1-5,   energy).
env(enioar,  1-3,   1,     energy).
env(enioar,  16-17, 1-2,   energy).
env(enioar,  0-1,   2-3,   energy).
env(enioar,  2,     2-4,   energy).
env(enioar,  3-4,   2,     energy).
env(enioar,  14-17, 2,     energy).
env(enioar,  3,     3-5,   space).
env(enioar,  2-3,   3-4,   space).
env(enioar,  4-14,  3,     energy).
env(enioar,  15-16, 3,     space).
env(enioar,  17-18, 3-4,   energy).
env(enioar,  2-15,  4,     space).
env(enioar,  7-15,  4-6,   space).
env(enioar,  10,    4-10,  space).
env(enioar,  10-15, 4-7,   space).
env(enioar,  16,    4-6,   energy).
env(enioar,  16-18, 4,     energy).
env(enioar,  1-2,   5,     energy).
env(enioar,  4-6,   5-7,   nebula).
env(enioar,  2-3,   6,     energy).
env(enioar,  3,     6-8,   energy).
env(enioar,  7,     7-8,   energy).
env(enioar,  7-9,   7,     energy).
env(enioar,  9,     7-11,  energy).
env(enioar,  16-17, 6,     energy).
env(enioar,  14-15, 7-8,   nebula).
env(enioar,  16,    7-8,   space).
env(enioar,  17,    6-9,   energy).
env(enioar,  17-20, 7,     energy).
env(enioar,  18,    7,     choke(to(19-20,6-8))).
env(enioar,  19-20, 6-8,   energy).
env(enioar,  20,    7,     wormhole(to('Pass Fed-09',0,7))).
env(enioar,  2,     8-12,  energy).
env(enioar,  2-3,   8,     energy).
env(enioar,  5,     8-9,   space).
env(enioar,  4-5,   8,     space).
env(enioar,  6,     8-10,  energy).
env(enioar,  6-7,   8,     energy).
env(enioar,  11-13, 8,     energy).
env(enioar,  1-2,   9-10,  energy).
env(enioar,  3-4,   9-10,  asteroid).
env(enioar,  3,     9-11,  asteroid).
env(enioar,  4,     11,    space).
env(enioar,  5,     10-12, energy).
env(enioar,  11,    8-10,  energy).
env(enioar,  11-13, 8,     energy).
env(enioar,  2-5,   12,    energy).
env(enioar,  9-10,  11,    energy).
env(enioar,  13-17, 9,     energy).
env(enioar,  11-14, 10,    energy).
env(enioar,  13-14, 9-11,  energy).
env(enioar,  13,    8-12,  energy).
env(enioar,  11-12, 11,    space).
env(enioar,  10-13, 12,    energy).
env(enioar,  12,    12,    wormhole(to('Liaface',9,0))).
env(enioar,  0-6,   0,     block).
env(enioar,  0,     1,     block).
env(enioar,  4-6,   0-1,   block).
env(enioar,  5-6,   0-2,   block).
env(enioar,  5-7,   2,     block).
env(enioar,  9,     2,     block).
env(enioar,  10-13, 0-2,   block).
env(enioar,  10-15, 0-1,   block).
env(enioar,  10-20, 0,     block).
env(enioar,  18-20, 0-2,   block).
env(enioar,  0,     4-12,  block).
env(enioar,  0-1,   6-8,   block).
env(enioar,  2,     7,     block).
env(enioar,  0-1,   11-12, block).
env(enioar,  8,     8,     block).
env(enioar,  7-8,   9-12,  block).
env(enioar,  6,     11,    block).
env(enioar,  6-9,   12,    block).
env(enioar,  12,    9,     block).
env(enioar,  19-20, 3-5,   block).
env(enioar,  17-20, 5,     block).
env(enioar,  18,    6,     block).
env(enioar,  18,    8,     block).
env(enioar,  18-20, 9-12,  block).
env(enioar,  15-20, 10-12, block).
env(enioar,  14,    12,    block).
%% enioar done.


%% final env catchers

env(Sector,  X, Y, block) :-
    integer(X), integer(Y),
    ( X < 0; Y < 0;
      (env(Sector, bbox, MX, MY), (X > MX; Y > MY)) ), !.

env(Sector, X, Y, Obj) :-
    integer(X), env(Sector, X1-X2, Y, Obj), between(X1,X2, X), !.
env(Sector, X, Y, Obj) :-
    integer(Y), env(Sector, X, Y1-Y2, Obj), between(Y1,Y2, Y).


check_env_is_complete(Sector) :-
    env(Sector, bbox, MX, MY),
    forall((between(0,MX, X), between(0,MY, Y)),  env(Sector, X, Y, _)).
    
check_missing_in_env(Sector, X, Y) :-
    env(Sector, bbox, MX, MY),
    between(0,MX, X), between(0,MY, Y),
    \+ env(Sector, X, Y, _).

gen_env(Sector, X, Y, E) :-
    env(Sector, bbox, MX, MY),
    between(0,MX, X), between(0,MY, Y),  env(Sector, X, Y, E),
    cache_once(env_(Sector, X, Y, E)).


nb(Sector, X, Y, _) :-
    env(Sector, X, Y, block), !, fail.
nb(Sector, X, Y, Nb) :-
    X1 is X-1, Y1 is Y-1, env(Sector,X1,Y1,E), E\=block, Nb=nb(nw,X1,Y1,E).
%% ^^ or should i check env_base(E), here and below
nb(Sector, X, Y, Nb) :-
    Y1 is Y-1, env(Sector,X,Y1,E), E\=block, Nb=nb(n,X,Y1,E).
nb(Sector, X, Y, Nb) :-
    X1 is X+1, Y1 is Y-1, env(Sector,X1,Y1,E), E\=block, Nb=nb(ne,X1,Y1,E).
nb(Sector, X, Y, Nb) :-
    X1 is X+1, env(Sector,X1,Y,E), E\=block, Nb=nb(e,X1,Y,E).
nb(Sector, X, Y, Nb) :-
    X1 is X+1, Y1 is Y+1, env(Sector,X1,Y1,E), E\=block, Nb=nb(se,X1,Y1,E).
nb(Sector, X, Y, Nb) :-
    Y1 is Y+1, env(Sector,X,Y1,E), E\=block, Nb=nb(s,X,Y1,E).
nb(Sector, X, Y, Nb) :-
    X1 is X-1, Y1 is Y+1, env(Sector,X1,Y1,E), E\=block, Nb=nb(sw,X1,Y1,E).
nb(Sector, X, Y, Nb) :-
    X1 is X-1, env(Sector,X1,Y,E), E\=block, Nb=nb(w,X1,Y,E).

check_nb_not_reflexive(Sector, bad(X,Y,X1,Y1)) :-
    env(Sector, bbox, MX, MY),
    between(0,MX, X), between(0,MY, Y),
    \+ (nb(S,X,Y,nb(_,X1,Y1,_)) -> nb(S,X1,Y1,nb(_,X,Y,_)); true).

