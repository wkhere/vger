from typing import TypeVar, Tuple, Sequence
from memo import memoize

mvcost_base = {
    'space':    11,
    'nebula':   16,
    'viral':    18,
    'energy':   20,
    'asteroid': 25,
    'exotic':   36,
    }
speed_base = {
    'nuclear':  1,
    'fusion':   2,
    'efusion':  2,
    'ion':      3,
    'am':       4,
    'eam':      4,
    'hyper':    5,
    'ip':       6,
    'eip':      6,
    }

def mvcost(env, drive):
    return mvcost_base[env]-speed(drive)

def speed(drive):
    return drive if isinstance(drive,int) else speed_base[drive]


enioar = 'enioar'
block = 'block'
space = 'space'
nebula = 'nebula'
energy = 'energy'
asteroid = 'asteroid'

envdata = {}

def env(s,x,y,v):
    global envdata
    if x=='bbox':
        x,y=y,v
        envdata[(s,'bbox')] = (x,y)
    elif isinstance(x,int) and isinstance(y,int):
        if v=='block' or mvcost_base.get(v):
            envdata[(s,x,y)] = v
    elif isinstance(x,int) and isinstance(y,tuple):
        y1,y2 = y
        for yi in range(y1,y2+1):
            env(s,x,yi,v)
    elif isinstance(x,tuple):
        x1,x2 = x
        for xi in range(x1,x2+1):
            env(s,xi,y,v)

# magically converted from prolog by removing dots and then
#   r=re.compile(r'^env\(.+(\d\d?)-(\d\d?)(?=,)')
#   for l in open(..): r.sub(r'(\1,\2)', l) ...
env(enioar, 'bbox', 20, 12)
env(enioar,  (7,9),   (0,1),   energy)
#env(enioar,  8,     0,     'wormhole(unused)')
env(enioar,  8,     2,     energy)
#env(enioar,  8,     2,     'choke(to((7,9),0-1))')
env(enioar,  1,     (1,5),   energy)
env(enioar,  (1,3),   1,     energy)
env(enioar,  (16,17), (1,2),   energy)
env(enioar,  (0,1),   (2,3),   energy)
env(enioar,  2,     (2,4),   energy)
env(enioar,  (3,4),   2,     energy)
env(enioar,  (14,17), 2,     energy)
env(enioar,  3,     (3,5),   space)
env(enioar,  (2,3),   (3,4),   space)
env(enioar,  (4,14),  3,     energy)
env(enioar,  (15,16), 3,     space)
env(enioar,  (17,18), (3,4),   energy)
env(enioar,  (2,15),  4,     space)
env(enioar,  (7,15),  (4,6),   space)
env(enioar,  10,    (4,10),  space)
env(enioar,  (10,15), (4,7),   space)
env(enioar,  16,    (4,6),   energy)
env(enioar,  (16,18), 4,     energy)
env(enioar,  (1,2),   5,     energy)
env(enioar,  (4,6),   (5,7),   nebula)
env(enioar,  (2,3),   6,     energy)
env(enioar,  3,     (6,8),   energy)
env(enioar,  7,     (7,8),   energy)
env(enioar,  (7,9),   7,     energy)
env(enioar,  9,     (7,11),  energy)
env(enioar,  (16,17), 6,     energy)
env(enioar,  (14,15), (7,8),   nebula)
env(enioar,  16,    (7,8),   space)
env(enioar,  17,    (6,9),   energy)
env(enioar,  (17,20), 7,     energy)
#env(enioar,  18,    7,     'choke(to((19,20),6-8))')
env(enioar,  (19,20), (6,8),   energy)
#env(enioar,  20,    7,     'wormhole(to(pf09, 0,7))')
env(enioar,  2,     (8,12),  energy)
env(enioar,  (2,3),   8,     energy)
env(enioar,  5,     (8,9),   space)
env(enioar,  (4,5),   8,     space)
env(enioar,  6,     (8,10),  energy)
env(enioar,  (6,7),   8,     energy)
env(enioar,  (11,13), 8,     energy)
env(enioar,  (1,2),   (9,10),  energy)
env(enioar,  (3,4),   (9,10),  asteroid)
env(enioar,  3,     (9,11),  asteroid)
env(enioar,  4,     11,    space)
env(enioar,  5,     (10,12), energy)
env(enioar,  11,    (8,10),  energy)
env(enioar,  (11,13), 8,     energy)
env(enioar,  (2,5),   12,    energy)
env(enioar,  (9,10),  11,    energy)
env(enioar,  (13,17), 9,     energy)
env(enioar,  (11,14), 10,    energy)
env(enioar,  (13,14), (9,11),  energy)
env(enioar,  13,    (8,12),  energy)
env(enioar,  (11,12), 11,    space)
env(enioar,  (10,13), 12,    energy)
#env(enioar,  12,    12,    'wormhole(to(liaface, 9,0))')
env(enioar,  (0,6),   0,     block)
env(enioar,  0,     1,     block)
env(enioar,  (4,6),   (0,1),   block)
env(enioar,  (5,6),   (0,2),   block)
env(enioar,  (5,7),   2,     block)
env(enioar,  9,     2,     block)
env(enioar,  (10,13), (0,2),   block)
env(enioar,  (10,15), (0,1),   block)
env(enioar,  (10,20), 0,     block)
env(enioar,  (18,20), (0,2),   block)
env(enioar,  0,     (4,12),  block)
env(enioar,  (0,1),   (6,8),   block)
env(enioar,  2,     7,     block)
env(enioar,  (0,1),   (11,12), block)
env(enioar,  8,     8,     block)
env(enioar,  (7,8),   (9,12),  block)
env(enioar,  6,     11,    block)
env(enioar,  (6,9),   12,    block)
env(enioar,  12,    9,     block)
env(enioar,  (19,20), (3,5),   block)
env(enioar,  (17,20), 5,     block)
env(enioar,  18,    6,     block)
env(enioar,  18,    8,     block)
env(enioar,  (18,20), (9,12),  block)
env(enioar,  (15,20), (10,12), block)
env(enioar,  14,    12,    block)
# enioar done.

def check_env_is_complete(sector):
    mx,my = envdata[(sector,'bbox')]
    for x in xrange(mx+1):
        for y in xrange(my+1):
            envdata[(sector,x,y)]


@memoize
def nb(s,x,y):
    if envdata[s,x,y] == 'block': return None
    ns = []
    def test(i,j):
        n = (s,x+i,y+j)
        try:
            if envdata[n] != 'block': ns.append(n)
        except KeyError: pass
    test(-1,-1)
    test( 0,-1)
    test(+1,-1)
    test(+1, 0)
    test(+1,+1)
    test( 0,+1)
    test(-1,+1)
    test(-1, 0)
    return ns


# A*

Point = Tuple[str, int, int]

def h(point1: Point, point2: Point) -> float:
    s1,x1,y1 = point1
    s2,x2,y2 = point2
    from math import floor, sqrt
    assert s1==s2
    return floor(sqrt((x2-x1)**2 + (y2-y1)**2))

def h_drived(drive, n1, n2):
    return mvcost('space',drive)*h(n1,n2)


from functools import partial

def astar_drived(drive, node0, goal):
    return astar((partial(h_drived, drive), lambda n: nb(*n),
                  lambda n1,_n2: mvcost(envdata[n1],drive)),
                 node0, goal)

def run():
    return astar_drived('ion', ('enioar',1,1), ('enioar',20,7))


from heapq import heappush, heappop, heapify

def heapdel(q, v, eqpred= lambda v,item: v==item[1]):
    found = False
    for i in range(len(q)):
        if eqpred(v,q[i]):
            found = True
            break
    if found:
        del q[i]
        heapify(q)


def astar(env, node0, goal):
    h, nbs, dist = env
    closedset = set()
    parents = {}
    g = {}
    g[node0] = 0
    f0 = h(node0, goal)
    openset = set([node0])
    openq = [(f0, node0)]

    def cons_path(node):
        parent = parents.get(node)
        if parent:
            return cons_path(parent) + [node]
        return []

    while openset:
        #print("* openq size=", len(openq))
        (_fx,x) = heappop(openq)
        openset.remove(x)
        if x == goal:
            return cons_path(goal)

        closedset.add(x)
        for y in nbs(x):
            if y in closedset: continue

            estimate_g = g[x] + dist(x,y)

            if y in openset:
                if estimate_g < g[y]:
                    heapdel(openq, y)
                else:
                    continue

            parents[y] = x
            g[y] = gy = estimate_g
            fy = h(y, goal) + gy
            heappush(openq, (fy,y))
            openset.add(y)


if __name__ == '__main__': print(run())
