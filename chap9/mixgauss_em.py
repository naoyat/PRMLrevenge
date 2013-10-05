import math
from pylab import *

EPSILON = 1.0e-6

def load(path):
    xs = []
    with open(path,'r') as file:
        for line in file:
            x, y = map(float,line.strip().split(' '))
            xs.append((x,y))
    return array(xs)


def autoaxis(xs):
    mins = xs.min(axis=0)
    maxs = xs.max(axis=0)
    margins = (maxs - mins) / 10 # margin
    mins -= margins
    maxs += margins
    axis(( float(mins[0]), float(maxs[0]), float(mins[1]), float(maxs[1]) ))


def draw_mvgauss_ellipse(mu, sigma):
    fig = gcf()

    eigvec, eigval, V = svd(sigma)

    s0 = math.sqrt(eigval[0])
    s1 = math.sqrt(eigval[1])

    e0 = eigvec[0] * s0
    e1 = eigvec[1] * s1

    plot([mu[0], mu[0]+e0[0]], [mu[1], mu[1]+e0[1]], color='g')
    plot([mu[0], mu[0]+e1[0]], [mu[1], mu[1]+e1[1]], color='b')

    ps = []
    M = 50
    for i in xrange(M):
        th = math.pi * 2 * i/M
        x = mu[0] + cos(th)*e0[0] + sin(th)*e1[0]
        y = mu[1] + cos(th)*e0[1] + sin(th)*e1[1]
        ps.append((x,y))

    pg = Polygon(ps, closed=True, fill=True, facecolor='0.8', edgecolor='w', alpha=0.5)
    fig.gca().add_patch(pg)


def mvgauss(x, mu, sigma):
    z = x - mu
    D = len(mu)

    ## solve(sigma, z) = dot(inv(sigma), z)
    return math.exp(dot(z.transpose(), solve(sigma, z)) * -0.5) / (math.pow(math.pi, D/2) * math.sqrt(det(sigma)))


def calculate_likelihood(xs, mu, sigma, pi):
    likelihood = 0
    for x in xs:
        sum = 0
        for m,s,p in zip(mu,sigma,pi):
            sum += p * mvgauss(x, m, s)
        likelihood += math.log(sum)
    return likelihood


def mixgauss_em(xs, K):
    N     = len(xs)

    xmean = average(xs, axis=0)
    xcov  = cov(xs[:,0], xs[:,1])

    # initial values of parameters
    mu    = multivariate_normal(xmean, xcov, K)
    sigma = [xcov/10] * K
    pi    = [0.5] * K

    autoaxis(xs)
    scatter(xs[:,0], xs[:,1], c='b', marker='x')
    for m, s in zip(mu, sigma):
        draw_mvgauss_ellipse(m, s)

    likelihood = calculate_likelihood(xs, mu, sigma, pi)
    print "0) likelihood =", likelihood
#    print "         mu =", mu[0], mu[1]
#    print "      sigma =", sigma[0], sigma[1]
#    print "        pi  =", pi[0], pi[1]

    for st in range(100):
        # E-step
        gamma_nk = []
        Nk = zeros(K)
        for n, xn in enumerate(xs):
            pks = [pi[k] * mvgauss(xn, mu[k], sigma[k]) for k in range(K)]
            pks /= sum(pks) # normalize
            Nk += pks
            gamma_nk.append(pks)

        # M-step
        for k in range(K):
            # Nk = sum([gamma_nk[n][k] for n in range(N)])
            mu_k_new = sum([gamma_nk[n][k] * xs[n] for n in range(N)], axis=0) / Nk[k]

            # sigma_k_new = [dot((xs[n] - mu_k_new).transpose(), xs[n] - mu_k_new) * gamma_nk[n][k] for n in range(N)]
            sigma_k_new = 0
            for n in range(N):
                zn = array([xs[n] - mu_k_new]).transpose()
                sigma_k_new += dot(zn, zn.transpose()) * gamma_nk[n][k]
            sigma_k_new /= Nk[k]
            pi_k_new = Nk[k] / N

            # update parameters
            mu[k]    = mu_k_new
            sigma[k] = sigma_k_new
            pi[k]    = pi_k_new

        # show
        clf()

        likelihood_new = calculate_likelihood(xs, mu, sigma, pi)
        print st+1, ") likelihood =", likelihood
#        print "         mu =", mu[0], mu[1]
#        print "      sigma =", sigma[0], sigma[1]
#        print "        pi  =", pi[0], pi[1]
        for n, xn in enumerate(xs):
            color = (gamma_nk[n][0], 0, gamma_nk[n][1])
            scatter([xn[0]], [xn[1]], c=color, marker='x')

        for m, s in zip(mu, sigma):
            draw_mvgauss_ellipse(m, s)

        show()

        if likelihood_new - likelihood < EPSILON: break
        likelihood = likelihood_new


if __name__ == '__main__':
    xs = load('faithful.txt')

    mixgauss_em(xs, 2)

