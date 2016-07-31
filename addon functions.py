# -*- coding: utf-8 -*-
"""
Created on Sun Jul 31 21:56:56 2016

@author: rghuang
"""

def mixing_matrix(graph, membership, weights=None):
    import numpy as np
    k = len(np.unique(graph.vs[membership]))
    result = np.matrix([[0]* k for _ in range(k)])
    member = graph.vs[membership]
    mapping = dict(zip(np.unique(member), range(len(np.unique(member)))))
    print("Mapping rule: ", mapping)
    member = np.vectorize(mapping.get)(member)
    graph = graph.copy()
    graph.vs[membership] = member
    for edge in graph.es:
        ms, mt = graph.vs[edge.source][membership], graph.vs[edge.target][membership]
        if weights is None:
            result[ms, mt] += 1
        else:
            result[ms, mt] += edge[weights]
    return result

def linmap(x, max_value, min_value):
    """
    Linear mapping of x into [min_value, max_value]
    """
    a = min(x)
    b = max(x)
    ans = [(max_value - min_value) * (el - a) / (b - a) + min_value for el in x]
    return ans

def changeAlpha(color, alpha=0.5):
    """
    @color: rgb color
    """
    return color[:3] + (alpha,) 

def get_coords(g0, g1):
    """
    Keep the coordinates of graph g0 after certain nodes are deleted.
    G0: original graph
    G1: derived graph from G0 after certain nodes are deleted.
    """
    import igraph
    coords0 = g0['layout'].coords
    coords0 = dict([el for el in zip(g0.vs['name'], coords0)])
    coords1 = [coords0.get(v) for v in g1.vs['name']]
    return igraph.Layout(coords1)

