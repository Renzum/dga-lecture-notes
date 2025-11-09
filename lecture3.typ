#import "@preview/thmbox:0.3.0": *

#show: thmbox-init()

#import "@preview/algorithmic:1.0.6"
#import algorithmic: algorithm-figure, style-algorithm

#block(fill: none, stroke: color.black, inset: 0.5em)[
  *Class 3 Lecture Notes* #h(1fr) Written by: _Karen Arzumanyan_ & _Kevin Jonathan Rogers_

  #align(center)[
    #text(size: 1.5em, weight: "bold")[Distributed Graph Algorithms]
    #v(10pt, weak: true)
    #text(
      size: 1.2em,
      weight: "bold",
    )[Global Problems: Computing Spanning Trees]]

  Lecturer: _Fabian Kuhn_ #h(1fr) 2025-11-03
]

#counter(heading).update(2)
#counter("thmbox").update(3)

#set heading(numbering: "1.")
= Global Problems: Computing Spanning Trees
== Broadcast and Flooding
Suppose we have some graph $G = (V, E)$ and a source node $s in V$ and $s$ has a message $M$ that it wants to deliver to all of the nodes $v in V$.

The simplest way to accomplish this would be with a naive algorithm which floods the entire graph with messages.


#show: style-algorithm

#algorithm-figure(
  "Flooding",
  {
    import algorithmic: *
    Comment[Run on $s$]
  },
  {
    $s "sends message" M "to all neighbors"$
  },
  {
    import algorithmic: *
    LineBreak
    Comment[Run on all nodes $v in V "such that" v != s$]
  },
  {
    import algorithmic: *
    If(
      [$v$ receives message $M$ for the first time from neighbor $u$],
      {
        [Send $M$ to all neighbors $w in N(v)$ such that $w != u$]
      },
      {
        Comment[If $v$ received $M$ from multiple neighbors, then $u$ is picked arbitrarily from the neighbors from which $M$ was received.]
      },
    )
  },
) <flooding>

Trivially, we can see that eventually the entire graph will know the message $M$ and the algorithm terminates since all nodes send the message out only once.

#lemma[Lemma][][All nodes $v in V$ know the message $M$ after at most $bold(D)$ rounds where $bold(D)$ is the diameter of $G$.]<messages-in-d>

#proof[@messages-in-d][
  We perform an induction on $r$.
  During round 1, nodes at distance 1 from $s$ know the message. During round 2, nodes at distance 2 know the message since the nodes at distance 1 forwarded them.

  On the round $r-1$, nodes with a distance of $r-1$ from $s$ know the message and will forward the message to their neighbors some of which will be at distance $r$ from $s$.
]

#pagebreak()

== Rooted Spanning Trees and BFS
A spanning tree can be defined as a connected graph without any cycles. Interestingly, we can modify @flooding and have it compute a rooted spanning tree $T$ on a graph $G$ where the root is our source node $s$. The way to achieve it is to have each node $v in V$ that isn't $s$ pick the neighbor from which it received $M$ first as its parent.

#algorithm-figure(
  "Tree from Flooding",
  {
    import algorithmic: *
    Comment[Run on $s$]
  },
  {
    $s "sends message" M "to all neighbors"$
  },
  {
    import algorithmic: *
    LineBreak
    Comment[Run on all nodes $v in V "such that" v != s$]
  },
  {
    import algorithmic: *
    If(
      [$v$ receives message $M$ for the first time from neighbor $u$],
      {
        [Pick $u$ as parent]
      },
      {
        [Send $M$ to all neighbors $w in N(v)$ such that $w != u$]
      },
      {
        Comment[If $v$ received $M$ from multiple neighbors, then $u$ is picked arbitrarily from the neighbors from which $M$ was received. For simplicity it can pick the neighbor with the smallest ID]
      },
    )
  },
) <flooding-tree>


#definition[Breadth-First-Search (BFS) Tree on Graph G][
  A BFS Tree $T$ on graph $G$ with source node $s$ means that any node $v in V$ with distance $r$ from $s$ on the graph $G$ will also have the same distance from $s$ on BFS Tree $T$.
]

The reason why distances to the source remain the same is simply due to the fact that if a node $v$ received the message for the first time on round $r$, it means that it was $r$ nodes away from the source on the original graph $G$.

#lemma[Lemma][The computed tree $T$ is a Breadth-First-Search (BFS) tree of $G$ and thus the height of the BFS $T$ is at most the diameter of $G$.]

The reason why the diameter is at most $G$ is trivial. If there is a node $v in V$ whose distance to the source $s$ is the longest path on the graph, then on the BFS Tree, the distance of $v$ to the root $s$ will remain the same by definition. Thus the longest branch of the tree (aka the height) will be as long as the longest path on $G$ which is the diameter of $G$.
#remark[Using a rooted tree of some height $h$, we can compute simple functions such as sum, min, max in $h$ rounds by assigning a value to each node in the tree and computing bottom-up starting from the leaves.]

#pagebreak()

== Congest Model

If you recall from the first lecture, there exist two models: *LOCAL* and *CONGEST*.

The *LOCAL* model allows for arbitrarily large messages, but the *CONGEST* model puts a restriction on the message size. From now on, we specify the message size restriction as at most $log n$ bits or $O(log n)$ and from now on we will focus on the *CONGEST* model.

#remark[The algorithms discussed in the previous lectures still work in the *CONGEST* model.]

== Bottom-up Computation on BFS Trees

Let us define a high level task.

We have a graph $G$ such that each node $v$ in the graph has an input pair $(alpha_v, x_v)$ such that both $alpha_v$ and $x_v$ are $O(log n)$-bit integers. There is also a parameter $k$ which specifies the number of different $alpha_v$ values in the system which nodes can have.

#example[
  $k = 2$ means that there are only two values $alpha_1$ and $alpha_2$ and they are not equal. Any node $v$  in the graph $G$ can either have $alpha_1$ or $alpha_2$ in its pair.
]

The task requires us to output a list consisting of ${(alpha_1, x_1), (alpha_2, x_2) ... (alpha_k, x_k)}$ pairs such that $x$ of each pair is the lowest integer out of all the $(alpha, x)$ pairs that exist on the graph for that specific $alpha$ value.

#example[
  Let $k = 3$, this means that we have three partitions $alpha_1$, $alpha_2$ and $alpha_3$.

  Let's say $|V| = 6$ and the following pairs are assigned to the nodes in no particular order.
  $
    (alpha_1, 9), (alpha_1, 5), (alpha_1, 2), (alpha_2, 7), (alpha_3, 1), (alpha_3, 23)
  $

  And upon completing the task, the resulting list of pairs would be
  $
    (alpha_1, 2), (alpha_2, 7), (alpha_3, 1)
  $

  As those are the lowest $x$ values for each $alpha$ value.
]

With the task set up, the remaining question is: "How fast can we solve this?"


#lemma[
  Given a rooted BFS tree, the task can be solved in $O(bold(D) + k)$ rounds in the *CONGEST* model.
] <dk-complexity>

#pagebreak()

*Sketch of the proof for @dk-complexity:* We provide a rough sketch of the proof now. For the detailed proof see Exercise Sheet 3.

The process relies on calculating the minimum values of each $alpha$ partition in a bottom up manner. And if a node $v$ possesses multiple pairs, it must send the smaller $alpha$ value first.
This means that smaller $alpha$ values will block the higher ones. Assuming they're ordered such that $alpha_1 < alpha_2 < ... < alpha_k$ we have that:

#list(
  marker: "",
  [
    $(alpha_1, x_v)$ values are never blocked
  ],
  [
    $(alpha_2, x_v)$ values are blocked by $alpha_1$ values and always one round behind $alpha_1$ values.
  ],
  [
    #h(0.6cm)$fence.dotted$
  ],
  [

    $(alpha_k, x_v)$ values are at most one round behind $(alpha_(i-1), x_v)$ values
  ],
)

One can show that that the $alpha_i$, which is furthest away from the source $s$ and is yet to be resolved, is always one round behind the latest $alpha_(i-1)$. This can be shown through induction.

It is important to reiterate that certain details are being overlooked. For example, when does the node know that all of the values for a specific $alpha$ in its subtree have been received or whether there is a specific $alpha$ value in the subtree at all.

For example, leaves can only send their own value since they do not have any children nodes. And if a node does have children, it should wait until it has received values for a specific $alpha$ from all of its children or the children told it that they do not have any values for that specific alpha anymore.

#remark[
  In a *LOCAL* model, this computation (in fact, any computation on a graph) is solvable in $bold(D)$ (diameter of $G$) rounds since the messages can be arbitrarily large thus we can propagate as much information as we want in each communication round and in $bold(D)$ rounds all of the information about the system is known to all nodes.
]

== Minimum Spanning Tree
Let us begin by defining what a Minimum Spanning Tree is.

#remark[
  Multiple Spanning Trees can be constructed on a graph $G$.
]

#definition[Minimum Spanning Trees (MST)][
  Given a graph $G = (V,E)$ and edge weights $w(e)$ for each edge $e in E$.

  A Minimum Spanning Tree is a Spanning Tree $T = (V, E' subset E)$ on $G$ such that the sum of all edges of $T$ is the lowest out of all the spanning trees that can be built on $G$.
  $
    "Minimum Spanning Tree" = arg min_(forall T subset G) sum_(e in E') w(e)
  $
]

#pagebreak

To simplify what's to come, we make two important assumptions:
+ All edge weights are $O(log n)$-bit integers.
+ Edge weights are unique (for simplicity).
+ Edge weights are positive.

Both the second and third assumptions can be enforced artificially.
For instance, one can use unique IDs to order edges of the same weight. Unique edge weights also make the Minimum Spanning Tree unique (for more detail, see Exercise Sheet 3).
And for the third assumption one can simple add some constant $c$ to all of the edge weight values thus making them all positive without changing the difference between the values.

#remark[
  An MST can be computed by several greedy algorithms: Kruskal's Algorithm, Primm's Algorithm, etc.
]
