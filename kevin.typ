#import "@preview/thmbox:0.3.0": *

#show: thmbox-init()

#import "@preview/algorithmic:1.0.6"
#import algorithmic: *



#definition[Minimum Spanning Trees (MST)][
  Given a graph $G = (V,E)$ and edge weights $w(e)$ for each edge $e in E$.

  A Minimum Spanning Tree is a Spanning Tree $T = (V, E' subset E)$ on $G$ such that the sum of all edges of $T$ is the lowest out of all the spanning trees that can be built on $G$.
  $
    "Minimum Spanning Tree" = arg min_(forall T subset G) sum_(e in E') w(e)
  $
]
