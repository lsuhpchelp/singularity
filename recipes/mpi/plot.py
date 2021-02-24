import matplotlib.pyplot as plt
import numpy as np

ndata = np.genfromtxt("pingpong-native.txt")
idata = np.genfromtxt("pingpong-image.txt")

plt.semilogy(ndata[:,0], ndata[:,1], '-o', label='native')
plt.semilogy(idata[:,0], idata[:,1], '-o', label='image')
plt.legend()
plt.show()
