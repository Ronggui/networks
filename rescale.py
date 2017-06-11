import matplotlib.pylab as plt
import math


def _rescale_logy(x, y0, y1, plot=False):
    """
    usage: _rescale_logy(range(1, 5000), 1, 10, True)
    :param x: number list
    :param y0: min
    :param y1: max
    :param plot: True or False
    :return: transformed version of x
    """
    x1 = max(x)
    x0 = min(x)
    beta1 = (math.log(y1) - math.log(y0)) / (x1 - x0)
    beta0 = math.log(y1) - x1 * beta1
    lnx = [beta0 + beta1 * el for el in x]
    xtransforme = [math.exp(el) for el in lnx]
    if plot:
        plt.plot(x, xtransforme)
    return xtransforme


def _rescale_log10y(x, y0, y1, plot=False):
    """
    usage: _rescale_log10y(range(1, 5000), 1, 10, True)
    """
    x1 = max(x)
    x0 = min(x)
    beta1 = (math.log10(y1) - math.log10(y0)) / (x1 - x0)
    beta0 = math.log10(y1) - x1 * beta1
    lnx = [beta0 + beta1 * el for el in x]
    xtransforme = [10**el for el in lnx]
    if plot:
        plt.plot(x, xtransforme)
    return xtransforme


def _rescale_log2y(x, y0, y1):
    """
    usage: _rescale_log10y(range(1, 5000), 1, 10, True)
    """
    x1 = max(x)
    x0 = min(x)
    x1 = max(x)
    x0 = min(x)
    beta1 = (math.log2(y1) - math.log2(y0)) / (x1 - x0)
    beta0 = math.log2(y1) - x1 * beta1
    lnx = [beta0 + beta1 * el for el in x]
    xtransforme = [2**el for el in lnx]
    if plot:
        plt.plot(x, xtransforme)
    return xtransforme


def _rescale_logx(x, y0, y1, plot=False):
    """
    usage: _rescale_logx(range(1, 5000), 1, 10, True)
    :param x:
    :param y0:
    :param y1:
    :return:
    """
    x1 = max(x)
    x0 = min(x)
    beta1 = (math.exp(y1) - math.exp(y0)) / (x1 - x0)
    beta0 = math.exp(y1) - x1 * beta1
    lnx = [beta0 + beta1 * el for el in x]
    xtransforme = [math.log(el) for el in lnx]
    if plot:
        plt.plot(x, xtransforme)
    return xtransforme


def _rescale_log10x(x, y0, y1, plot=False):
    """
    usage: _rescale_log10x(range(1, 5000), 1, 10, True)
    :param x:
    :param y0:
    :param y1:
    :param plot:
    :return:
    """
    x1 = max(x)
    x0 = min(x)
    beta1 = (10**y1 - 10**y0) / (x1 - x0)
    beta0 = 10**y1 - x1 * beta1
    lnx = [beta0 + beta1 * el for el in x]
    xtransforme = [math.log10(el) for el in lnx]
    if plot:
        plt.plot(x, xtransforme)
    return xtransforme


def _rescale_log2x(x, y0, y1, plot=False):
    """
    usage: _rescale_log2x(range(1, 5000), 1, 10, True)
    """
    x1 = max(x)
    x0 = min(x)
    beta1 = (2**y1 - 2**y0) / (x1 - x0)
    beta0 = 2**y1 - x1 * beta1
    lnx = [beta0 + beta1 * el for el in x]
    xtransforme = [math.log2(el) for el in lnx]
    if plot:
        plt.plot(x, xtransforme)
    return xtransforme


def _rescale_linear(x, y0, y1, plot=False):
    x1 = max(x)
    x0 = min(x)
    beta1 = (y1 - y0) / (x1 - x0)
    beta0 = y1 - x1 * beta1
    xtransforme = [beta0 + beta1 * el for el in x]
    if plot:
        plt.plot(x, xtransforme)
    return xtransforme


def rescale(x, y0, y1, method="log2x", plot=False):
    if method == "logx":
        return _rescale_logx(x, y0, y1, plot)
    elif method == "log10x":
        return _rescale_log10x(x, y0, y1, plot)
    elif method == "logy":
        return _rescale_logy(x, y0, y1, plot)
    elif method == "log2y":
        return _rescale_log2y(x, y0, y1, plot)
    elif method == "log10y":
        return _rescale_log10y(x, y0, y1, plot)
    elif method == "log2x":
        return _rescale_log2x(x, y0, y1, plot)
    else:
        return _rescale_linear(x, y0, y1, plot)
