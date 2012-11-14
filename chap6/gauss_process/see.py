from mpl_toolkits.mplot3d import Axes3D
import matplotlib.pyplot as plt
import numpy as np
import math
import sys

if len(sys.argv) < 2:
    print "usage: python %s <datafile>" % sys.argv[0]
    sys.exit()

datafile = sys.argv[1]

xa = []
ya = []
za = []
with open(datafile, 'r') as fp:
    for line in fp:
        tmp = line.rstrip().split('\t')
        x,y,z = map(float, tmp)
        xa.append(x)
        ya.append(y)
        za.append(z)

w = int(math.sqrt(len(xa)))

X = np.array(xa).reshape((w,w))
Y = np.array(ya).reshape((w,w))
Z = np.array(za).reshape((w,w))

fig = plt.figure()
ax = Axes3D(fig)
ax.plot_wireframe(X, Y, Z)
plt.show()

