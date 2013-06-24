-module(map).
-compile(export_all).
-define(ENV_ETS, pardus_vger_env).

whcost() -> 20.

mvcost(space)    -> 11;
mvcost(nebula)   -> 16;
mvcost(viral)    -> 18;
mvcost(energy)   -> 20;
mvcost(asteroid) -> 25;
mvcost(exotic)   -> 36.

%%env_base(Env) :- mvcost(Env,_).

mvcost(Env, Drive) -> mvcost(Env) - speed(Drive).

speed(nuclear) -> 1;
speed(fusion)  -> 2;
speed(efusion) -> 2;
speed(ion)     -> 3;
speed(am)      -> 4;
speed(eam)     -> 4;
speed(hyper)   -> 5;
speed(ip)      -> 6;
speed(eip)     -> 6;
speed(X) when is_integer(X) -> X.


env_init() ->
    ets:new(?ENV_ETS, [named_table]).

env_set(Key, Val) ->
    %% think if vals should be writable only once
    true = ets:insert(?ENV_ETS, {Key, Val}),
    ok.
env_get1(Key) ->
    case ets:lookup(?ENV_ETS, Key) of
        [{Key,Val}] -> Val;
        [] -> none
    end.

%% todo: store wormholes
env(Sector, bbox, X, Y) ->
    env_set({Sector, bbox}, {X,Y});
env(Sector, X, Y, block) when is_integer(X), is_integer(Y) ->
    env_set({Sector, X, Y}, block);
env(Sector, X, Y, E) when is_integer(X), is_integer(Y) ->
    mvcost(E),
    env_set({Sector, X, Y}, E);    
env(Sector, X, {Y1,Y2}, E) when is_integer(X) ->
    lists:foreach(fun(Y)-> env(Sector, X, Y, E) end, lists:seq(Y1,Y2));
env(Sector, {X1,X2}, Y_or_Ys, E) ->
    lists:foreach(fun(X)-> env(Sector, X, Y_or_Ys, E) end, lists:seq(X1,X2)).

%% todo: get wormholes
env(Sector, bbox) ->
    env_get1({Sector, bbox}).
env(Sector, X, Y) ->
    env_get1({Sector, X, Y}).
env(Key) ->
    env_get1(Key).

mk_env() ->
    case ets:info(?ENV_ETS) of
        undefined -> env_init();
        _ -> ok
    end,
    env(enioar, bbox, 20, 12),
    env(enioar,  {7,9},   {0,1},   energy),
    %%env(enioar,  8,       0,       'wormhole(unused)'),
    env(enioar,  8,       2,       energy),
    %%env(enioar,  8,       2,       'choke(to({7,9},0-1))'),
    env(enioar,  1,       {1,5},   energy),
    env(enioar,  {1,3},   1,       energy),
    env(enioar,  {16,17}, {1,2},   energy),
    env(enioar,  {0,1},   {2,3},   energy),
    env(enioar,  2,       {2,4},   energy),
    env(enioar,  {3,4},   2,       energy),
    env(enioar,  {14,17}, 2,       energy),
    env(enioar,  3,       {3,5},   space),
    env(enioar,  {2,3},   {3,4},   space),
    env(enioar,  {4,14},  3,       energy),
    env(enioar,  {15,16}, 3,       space),
    env(enioar,  {17,18}, {3,4},   energy),
    env(enioar,  {2,15},  4,       space),
    env(enioar,  {7,15},  {4,6},   space),
    env(enioar,  10,      {4,10},  space),
    env(enioar,  {10,15}, {4,7},   space),
    env(enioar,  16,      {4,6},   energy),
    env(enioar,  {16,18}, 4,       energy),
    env(enioar,  {1,2},   5,       energy),
    env(enioar,  {4,6},   {5,7},   nebula),
    env(enioar,  {2,3},   6,       energy),
    env(enioar,  3,       {6,8},   energy),
    env(enioar,  7,       {7,8},   energy),
    env(enioar,  {7,9},   7,       energy),
    env(enioar,  9,       {7,11},  energy),
    env(enioar,  {16,17}, 6,       energy),
    env(enioar,  {14,15}, {7,8},   nebula),
    env(enioar,  16,      {7,8},   space),
    env(enioar,  17,      {6,9},   energy),
    env(enioar,  {17,20}, 7,       energy),
    %%env(enioar,  18,    7,         'choke(to({19,20},6-8))'),
    env(enioar,  {19,20}, {6,8},   energy),
    %%env(enioar,  20,      7,       'wormhole(to(pf09, 0,7))'),
    env(enioar,  2,       {8,12},  energy),
    env(enioar,  {2,3},   8,       energy),
    env(enioar,  5,       {8,9},   space),
    env(enioar,  {4,5},   8,       space),
    env(enioar,  6,       {8,10},  energy),
    env(enioar,  {6,7},   8,       energy),
    env(enioar,  {11,13}, 8,       energy),
    env(enioar,  {1,2},   {9,10},  energy),
    env(enioar,  {3,4},   {9,10},  asteroid),
    env(enioar,  3,       {9,11},  asteroid),
    env(enioar,  4,       11,      space),
    env(enioar,  5,       {10,12}, energy),
    env(enioar,  11,      {8,10},  energy),
    env(enioar,  {11,13}, 8,       energy),
    env(enioar,  {2,5},   12,      energy),
    env(enioar,  {9,10},  11,      energy),
    env(enioar,  {13,17}, 9,       energy),
    env(enioar,  {11,14}, 10,      energy),
    env(enioar,  {13,14}, {9,11},  energy),
    env(enioar,  13,      {8,12},  energy),
    env(enioar,  {11,12}, 11,      space),
    env(enioar,  {10,13}, 12,      energy),
    %%env(enioar,  12,      12,    'wormhole(to(liaface, 9,0))'),
    env(enioar,  {0,6},   0,       block),
    env(enioar,  0,       1,       block),
    env(enioar,  {4,6},   {0,1},   block),
    env(enioar,  {5,6},   {0,2},   block),
    env(enioar,  {5,7},   2,       block),
    env(enioar,  9,       2,       block),
    env(enioar,  {10,13}, {0,2},   block),
    env(enioar,  {10,15}, {0,1},   block),
    env(enioar,  {10,20}, 0,       block),
    env(enioar,  {18,20}, {0,2},   block),
    env(enioar,  0,       {4,12},  block),
    env(enioar,  {0,1},   {6,8},   block),
    env(enioar,  2,       7,       block),
    env(enioar,  {0,1},   {11,12}, block),
    env(enioar,  8,       8,       block),
    env(enioar,  {7,8},   {9,12},  block),
    env(enioar,  6,       11,      block),
    env(enioar,  {6,9},   12,      block),
    env(enioar,  12,      9,       block),
    env(enioar,  {19,20}, {3,5},   block),
    env(enioar,  {17,20}, 5,       block),
    env(enioar,  18,      6,       block),
    env(enioar,  18,      8,       block),
    env(enioar,  {18,20}, {9,12},  block),
    env(enioar,  {15,20}, {10,12}, block),
    env(enioar,  14,      12,      block),
    %% enioar done,
    env(lave, bbox, 22, 15),
    env(lave,  {0,1},   {5,7},   energy),
    env(lave,  {2,4},   6,       energy),
    env(lave,  5,       {5,8},   energy),
    env(lave,  6,       {4,5},   energy),
    env(lave,  7,       {3,4},   energy),
    env(lave,  {8,9},   3,       energy),
    env(lave,  {9,14},  2,       energy),
    env(lave,  {14,16}, 1,       energy),
    env(lave,  {16,17}, 2,       energy),
    env(lave,  {17,21}, 3,       energy),
    env(lave,  {19,21}, 0,       energy),
    env(lave,  {20,21}, 1,       energy),
    env(lave,  20,      2,       energy),
    env(lave,  {21,22}, 4,       energy),
    env(lave,  22,      {5,7},   energy),
    env(lave,  21,      7,       energy),
    env(lave,  {6,7},   8,       energy),
    env(lave,  {18,21}, 8,       energy),
    env(lave,  7,       {9,11},  energy),
    env(lave,  {7,8},   12,      energy),
    env(lave,  {8,10},  13,      energy),
    env(lave,  {9,11},  {14,15}, energy),
    env(lave,  {10,11}, 12,      energy),
    env(lave,  {11,13}, 11,      energy),
    env(lave,  13,      12,      energy),
    env(lave,  {13,14}, 13,      energy),
    env(lave,  {14,19}, 14,      energy),
    env(lave,  {19,20}, 13,      energy),
    env(lave,  20,      {10,12}, energy),
    env(lave,  {18,19}, 10,      energy),
    env(lave,  18,      9,       energy),
    env(lave,  {9,12},  {5,6},   nebula),
    env(lave,  13,      6,       nebula),
    env(lave,  9,       {7,8},   nebula),
    env(lave,  {10,15}, {7,9},   nebula),
    env(lave,  {11,13}, 10,      nebula),
    env(lave,  {6,8},   {6,7},   space),
    env(lave,  8,       8,       space),
    env(lave,  {8,9},   {9,11},  space),
    env(lave,  10,      {10,11}, space),
    env(lave,  9,       12,      space),
    env(lave,  {7,8},   5,       space),
    env(lave,  {8,9},   4,       space),
    env(lave,  {10,16}, {3,4},   space),
    env(lave,  15,      2,       space),
    env(lave,  {17,20}, 4,       space),
    env(lave,  13,      5,       space),
    env(lave,  {14,21}, {5,6},   space),
    env(lave,  {16,20}, 7,       space),
    env(lave,  {16,17}, {8,9},   space),
    env(lave,  {14,17}, 10,      space),
    env(lave,  {14,19}, {11,12}, space),
    env(lave,  {15,18}, 13,      space),
    env(lave,  {0,8},   {0,2},   block),
    env(lave,  {0,6},   3,       block),
    env(lave,  {0,5},   4,       block),
    env(lave,  {2,4},   5,       block),
    env(lave,  {2,4},   7,       block),
    env(lave,  {0,4},   8,       block),
    env(lave,  {0,6},   {9,15},  block),
    env(lave,  7,       13,      block),
    env(lave,  {7,8},   {14,15}, block),
    env(lave,  {9,13},  {0,1},   block),
    env(lave,  {14,18}, 0,       block),
    env(lave,  17,      1,       block),
    env(lave,  {18,19}, {1,2},   block),
    env(lave,  22,      {0,3},   block),
    env(lave,  21,      2,       block),
    env(lave,  22,      8,       block),
    env(lave,  {19,22}, 9,       block),
    env(lave,  {21,22}, {10,15}, block),
    env(lave,  20,      {14,15}, block),
    env(lave,  {14,19}, 15,      block),
    env(lave,  {12,13}, {14,15}, block),
    env(lave,  12,      12,      block),
    env(lave,  {11,12}, 13,      block),
    %% wh lave {0,6} to pass_fed_10 {18,6},
    %% wh lave {10,15} to miarin {2,0},
    %% wh lave {19,0} to xh3819 {5,11},
    %% lave done (without wormholes),
    env(ook, bbox, 14, 14),
    env(ook,  {3,5},   {6,8},   nebula),
    env(ook,  {5,6},   {4,5},   nebula),
    env(ook,  {7,8},   {6,9},   nebula),
    env(ook,  1,       {2,3},   space),
    env(ook,  {3,4},   5,       space),
    env(ook,  {7,9},   {4,5},   space),
    env(ook,  {8,10},  3,       space),
    env(ook,  {10,11}, 2,       space),
    env(ook,  6,       {6,9},   space),
    %% {6,7} is planet Ook,
    env(ook,  {4,5},   9,       space),
    env(ook,  {7,9},   10,      space),
    env(ook,  9,       {6,9},   space),
    env(ook,  0,       {0,4},   energy),
    env(ook,  1,       {0,1},   energy),
    env(ook,  1,       {4,5},   energy),
    env(ook,  2,       {1,10},  energy),
    env(ook,  {3,4},   4,       energy),
    env(ook,  {4,7},   3,       energy),
    env(ook,  {7,9},   2,       energy),
    env(ook,  9,       1,       energy),
    env(ook,  {10,11}, {0,1},   energy),
    env(ook,  12,      {1,3},   energy),
    env(ook,  {13,14}, {0,2},   energy),
    env(ook,  11,      {3,4},   energy),
    env(ook,  10,      {4,9},   energy),
    env(ook,  3,       {9,10},  energy),
    env(ook,  4,       {10,12}, energy),
    env(ook,  {3,5},   {13,14}, energy),
    env(ook,  {5,6},   10,      energy),
    env(ook,  {6,9},   11,      energy),
    env(ook,  {10,11}, {10,12}, energy),
    env(ook,  12,      {11,13}, energy),
    env(ook,  13,      {11,14}, energy),
    env(ook,  14,      {12,14}, energy),
    env(ook,  0,       5,       block),
    env(ook,  {0,1},   {6,14},  block),
    env(ook,  {2,3},   {11,12}, block),
    env(ook,  2,       {13,14}, block),
    env(ook,  {2,9},   0,       block),
    env(ook,  {3,8},   1,       block),
    env(ook,  {3,6},   2,       block),
    env(ook,  3,       3,       block),
    env(ook,  12,      0,       block),
    env(ook,  11,      {5,9},   block),
    env(ook,  12,      {4,10},  block),
    env(ook,  13,      {3,10},  block),
    env(ook,  14,      {3,11},  block),
    env(ook,  5,       {11,12}, block),
    env(ook,  {6,9},   {12,14}, block),
    env(ook,  {10,11}, {13,14}, block),
    env(ook,  12,      14,      block),
    %% wh ook {0,0} to miarin {5,19},
    %% wh ook {14,0} to andexa {0,13},
    %% wh ook {4,14} to pass_fed_08 {7,0},
    %% wh ook {14,13} to cesoho {1,0},
    %% ook done,
    ok.

check_env_is_complete(Sector) ->
    {MX, MY} = env(Sector, bbox),
    [ case env(Sector,X,Y) of
        none -> error({missing_env, Sector, {X,Y}});
        _ -> ok
      end || X <- lists:seq(0,MX), Y <- lists:seq(0,MY) ],
    ok.


nb(Place) -> 
    case env(Place) of
        block -> [];
        none -> [];
        _ -> nb_(Place)
    end.
             
nb_({Sector, X, Y}) -> 
    lists:foldl(
      fun({I,J}, Acc) ->
              NewPlace = {Sector, X+I, Y+J},
              case env(NewPlace) of
                  block -> Acc;
                  none -> Acc;
                  _ -> [NewPlace|Acc]
              end
      end,
      [],
      [{-1,0}, {-1, 1}, { 0, 1}, { 1, 1},
       { 1,0}, { 1,-1}, { 0,-1}, {-1,-1}]
     ).

nb_memo(Place) ->
    case get({memo, nb, Place}) of
        undefined ->
            Nbs = nb(Place),
            put({memo, nb, Place}, Nbs),
            Nbs;
        X -> X
    end.


floor(X) ->
    T = trunc(X),
    if X < T -> T-1;
       true -> T
    end.

pow2(X) -> X*X.
-compile({inline, [pow2/1]}).

h0({S, X1,Y1}, {S, X2,Y2}) ->
    floor(math:sqrt(pow2(X2-X1) + pow2(Y2-Y1))).

gen_h(Drive) ->
    Cost = mvcost(space, Drive),
    fun(P1, P2) -> Cost*h0(P1,P2) end.

gen_dist(Drive) ->
    fun(P1,_P2) -> mvcost(env(P1),Drive) end.


astar_drived(Drive, Node0, Goal) ->
    astar({fun nb_memo/1,
           gen_dist(Drive),
           gen_h(Drive)},
          Node0, Goal).

-define(empty_heap, {{0,nil}, _}).

-record(st, {open, closed, parents}).

astar(Conf={_Nbs, _Dist, H}, Node0, Goal) ->
    F0 = H(Node0, Goal),
    Open = heaps:add(F0, Node0, 0, heaps:new()),
    %% G & Open are unified - G is Open's aux
    astar_loop(Conf, Goal,
               #st{open=Open, closed=sets:new(), parents=dict:new()}).

astar_loop(_Conf, _Goal, #st{open=?empty_heap}) -> 
    not_found;

astar_loop(Conf={Nbs, _Dist, _H}, Goal, St) ->
    {_, X, Open1} = heaps:take_min(St#st.open),
    case X==Goal of
        true ->
            cons_path(Goal, St#st.parents);
        false ->
            Closed1 = sets:add_element(X, St#st.closed),
            astar_nbs(Conf, Goal, X, Nbs(X), St#st{open=Open1, closed=Closed1})
    end.

astar_nbs(Conf={_Nbs, Dist, _H}, Goal, X, [Y|Ys], St) ->
    case sets:is_element(Y, St#st.closed) of
        true ->
            astar_nbs(Conf, Goal, X, Ys, St);
        false ->
            Open = St#st.open,            
            {_,GX} = heaps:mapping(X, Open),
            Estimate_G = GX + Dist(X,Y),
            case heaps:contains_value(Y, Open) of
                true ->
                    {TreeKey_Y, GY} = heaps:mapping(Y, Open),
                    case Estimate_G < GY of
                        true ->
                            Open1 = heaps:delete(TreeKey_Y, Y, Open),
                            astar_upd(Conf, Goal, X, [Y|Ys], Estimate_G,
                                      St#st{open=Open1});
                        false ->
                            astar_nbs(Conf, Goal, X, Ys, St)
                    end;
                false ->
                    astar_upd(Conf, Goal, X, [Y|Ys], Estimate_G, St)
            end
    end;
astar_nbs(Conf, Goal, _X, [], St) ->
    astar_loop(Conf, Goal, St).


astar_upd(Conf={_,_,H}, Goal, X, [Y|Ys], New_GY, St) ->
    Parents1 = dict:store(Y, X, St#st.parents),
    FY = H(Y, Goal) + New_GY,
    Open1 = heaps:add(FY, Y, New_GY, St#st.open),
    astar_nbs(Conf, Goal, X, Ys, St#st{open=Open1, parents=Parents1}).

cons_path(Node, Parents) ->
    cons_path(Node, Parents, []).

cons_path(Node, Parents, Acc) ->
    case dict:find(Node, Parents) of
        {ok, Parent} ->
            cons_path(Parent, Parents, [Node|Acc]);
        error -> Acc
    end.

%% runner

setup() ->
    mk_env(),
    lists:foreach(fun check_env_is_complete/1, [enioar, lave, ook]).
run() ->
    setup(),
    run1().
run1() ->
    run1({1,1}, {20,7}).
run1(XY, XY2) ->
    run1(ion, enioar, XY, XY2).
run1(Drive, Sector, {X,Y}, {X2,Y2}) ->
    timer:tc(?MODULE, astar_drived, [ Drive, {Sector,X,Y}, {Sector,X2,Y2} ]).
