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
    true = ets:insert(?ENV_ETS, {Key, Val}),
    ok.
env_get1(Key) ->
    case ets:lookup(?ENV_ETS, Key) of
        [{Key,Val}] -> Val;
        [] -> none
    end.

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
    %% enioar done.
    ok.

check_env_is_complete(Sector) ->
    {MX, MY} = env(Sector, bbox),
    [ begin E=env(Sector,X,Y), 
            E=:=block orelse mvcost(E) 
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
