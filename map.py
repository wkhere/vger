from typing import TypeVar, Union, Tuple, Sequence, List, Set, Callable
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
    global envdata
    mx,my = envdata[(sector,'bbox')]
    for x in range(mx+1):
        for y in range(my+1):
            envdata[(sector,x,y)]


Point = Tuple[str, int, int]
Distance = Union[int, float]

@memoize
def nb(s,x,y) -> List[Point]:
    global envdata
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

def h(point1: Point, point2: Point) -> Distance:
    s1,x1,y1 = point1
    s2,x2,y2 = point2
    from math import floor, sqrt
    assert s1==s2
    return sqrt((x2-x1)**2 + (y2-y1)**2)

def h_drived(drive, n1, n2):
    return mvcost('space',drive)*h(n1,n2)


from functools import partial

def astar_drived(drive, node0, goal):
    global envdata
    return astar((partial(h_drived, drive), lambda n: nb(*n),
                  lambda n1,_n2: mvcost(envdata[n1],drive)),
                 node0, goal)

def run():
    return astar_drived('ion', ('enioar',1,1), ('enioar',20,7))


from heapq import heappush, heappop

class PriQueue:
    def __init__(self, initial_vp: Tuple[Point, Distance]) -> None:
        self.s = set()  # type: Set[Point]
        self.q = []     # type: List[Tuple[Distance, Point]]
        self.add(*initial_vp)

    def add(self, v: Point, pri: Distance) -> None:
        self.s.add(v)
        heappush(self.q, (pri, v))

    def pop(self) -> Point:
        while True:
            v = heappop(self.q)[1]
            if v in self.s:
                self.s.discard(v)
                return v

    def __len__(self):
        return len(self.s)

    def __contains__(self, v):
        return v in self.s


def astar(env, node0: Point, goal: Point) -> List[Point]:
    h, nbs, dist = env
    closedset = set()   # type: Set[Point]
    parents = {}        # type: Dict[Point, Point]
    g = {node0: 0}
    f0 = h(node0, goal)
    openq = PriQueue((node0, f0))

    def cons_path(node):
        parent = parents.get(node)
        if parent:
            yield from cons_path(parent)
            yield node

    while openq:
        x = openq.pop()
        if x == goal:
            return list(cons_path(goal))

        closedset.add(x)
        for y in nbs(x):
            if y in closedset: continue

            estimate_g = g[x] + dist(x,y)

            if y in openq:
                if estimate_g >= g[y]:
                    continue

            parents[y] = x
            g[y] = estimate_g
            fy = h(y, goal) + estimate_g
            openq.add(y, fy)


def str_gostyle(items):
        return '[%s]' % ' '.join(
            ['{%s %d %d}' %(s,x,y) for s,x,y in items]
        )

if __name__ == '__main__': print(str_gostyle(run()))
