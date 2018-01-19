# -*- coding: utf-8 -*-
"""
@author:
Huang Ronggui
Department of Sociology
Fudan  University
ronggui.huang@gmail.com

Pycairo is needed for visualization

For Windows users:
    python-igraph binary can be downloaded from https://www.lfd.uci.edu/%7Egohlke/pythonlibs/#pycairo
    pycairo binary can be downloaded from https://www.lfd.uci.edu/%7Egohlke/pythonlibs/#python-igraph

For Windows users using Anaconda, can install using:
    conda install -c vtraag python-igraph
    conda install pycairo
"""


import os
import re
import collections
import igraph
import csv
import pandas as pd


os.chdir('南大寒假课程/实例')


def extract_uids(doc):
    return re.findall("@([_0-9A-Za-z\u4e00-\u9fa5]{2,30})\s+",  doc)


file_path = "南大课程2018.csv"
file = open(file_path, errors="replace", encoding="utf8")
reader = csv.reader(file)

weight = collections.Counter()

for line in reader:
    text = line[0]
    uids = [extract_uids(post) for post in text.split(r"\\") if post.startswith("@")]
    for uid in uids:
        if len(uid) > 1:
            edges = [(uid[0], at) for at in uid[1:] if at != uid[0]] ## directed network
            for e in edges:
                weight[e] += 1


# create a graph and add nodes
vs = set()
for k in weight:
    for uid in k:
        vs.add(uid)

vs = list(vs)
atnet = igraph.Graph(directed=True)
atnet.add_vertices(vs)
edges = [e for e in weight]
edges_weights = [weight[e] for e in weight]
atnet.add_edges(edges)
atnet.es['weight'] = edges_weights


atnet2 = atnet.copy()
atnet2.is_simple()
# if is simple, no need to simplify
atnet2.es.select(weight_lt=7).delete()


# descriptive analysis
atnet2.density()
atnet2.vcount()
atnet2.betweenness()

# component and communities
comp = atnet2.components('WEAK')  # weak components for directed network
pd.value_counts(comp.sizes())  # sizes of components
atnet2 = comp.giant()  # keep the giant component only
print(atnet2.vcount(), "nodes in the giant component.")

communities = atnet2.community_spinglass(weights='weight')
print(len(communities.sizes()), "communities", "with sizes:", sorted(communities.sizes()))
atnet2.vs["membership"] = communities.membership


palette = igraph.ClusterColoringPalette(len(communities.membership))
atnet2.vs['color'] = [palette.get(el) for el in atnet2.vs['membership']]
igraph.plot(atnet2, "network communities.png")


for e in atnet2.es:
    e['color'] = atnet2.vs[e.target]['color']

igraph.plot(atnet2, "network communities.png")
