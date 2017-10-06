#!/usr/bin/env python2

from z3 import *

ran = [];

s = Solver()

pvar = None

for r in range(0,3):
    vname = "r" + str(r)
    pname = "s" + str(r)
    x = Int(vname)
    s.add(x < 100)
    y = Int(pname)
    s.add(y < 33)
    s.add(x + y == 100)


s.check()
m = s.model()

print m
