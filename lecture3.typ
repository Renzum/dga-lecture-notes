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

#counter(heading).update(2) // Set the heading counter to 2 so the heading numbers begins from 3
#counter("thmbox").update(3) // Set theorem counter to 3 so the theorem numbers begin from 3

#set heading(numbering: "1.")


------

#import "@preview/thmbox:0.3.0": *

#show: thmbox-init()

#import "@preview/algorithmic:1.0.6"
#import algorithmic: *



=
== Basic Parallel/Distributed MST Algorithm (Borůvka algorithm)

Before we get to the algorithm, let us define a few things first.


#definition[MST Fragment][
  Given a Minimum Spanning Tree, A Fragment is just a connected subgraph of the minimum spanning tree
]

#definition[Minimum Weight Outgoing Edge][
  For a fragment F of a given graph $G = (V, E)$, the Minimum Weight Outgoing Edge(MWOE) is the edge ${u, v} in E$ such that 
  - $u in F$, 
  - $v in.not F$ 
  - Among all edges satisfying the two conditions, $(u, v)$ has the minimum weight.
]

#figure(caption: "Fragment and MWOE example")[
  #image("kevin/fragment.svg")
]

#lemma[
  For an Minimum spanning tree fragment F, The Minimum Weight Outgoing Edge ${ u, v }$ must be an edge of the Minimum Spanning tree.
]

To prove the above lemma, Take a fragment $F$. For the edge $u$ of the fragment, lets say it has an edge $e$ with a node $v$ outside of the fragment. Let us take that this edge $e = {u, v}$ is our minimum weight outgoing edge.

#figure()[
  #image("kevin/Boruvka.svg")
]

Now, for contradiction, let us assume the edge $e$ is not in the minimum spanning tree. There must now be a path $P$ existing that connects $u$ and $v$ in the MST. So there has to be some other edge $f$ through which the path $P$ will enter the fragment $F$.

Now if we replace $f$ by $e$, we will get a new spanning tree of smaller weight since we assumed $e$ is our *minimum weight outgoing edge*. Therefore, this will always be our minimum spanning tree.

== Borůvka Algorithm


#show: style-algorithm

#algorithm-figure(
  "Borůvka Algorithm",
  {
    $"Start with each node as a fragment of size 1"$
  },
  {
    LineBreak
    Comment[
      Let us call the number of fragments we have at any time as Forest $F$
    ]
  },
  While($|F| eq.not 1$, {
    [
      - Each fragment from F finds it's minimum weight outgoing edge.
      - Add all of the edges to a minimum spanning tree
      - Compute the new fragments by connecting components of edges added so far 
    ]
  }) 
) <Borůvka>

#lemma[
  Borůvka Algorithm computes the Minimum Spanning Tree from $n$ number of nodes in $O(log n)$ phases.
]

*Proof:*
We know that the algorithm does compute the MST by the end. 

The number of fragments is always divided by atleast 2 in each phase. This way we end up having $log n$ number of phases.

== Distributed Implementation of Borůvka Algorithm


To implement a distributed version of Borůvka Algorithm, We have to
- *For each fragment* 
  - Keep a rooted spanning tree
  - Each fragment should have a unique identifier
  - Each node in the fragment should know the unique identifier

#lemma[
  One Phase of Borůvka algorithm for $n$ number of nodes can be implemented in $O(n)$ rounds
]

*Proof*:

Firstly, we claim that each fragment can find it's minimum weight outgoing edge in $O(n)$ rounds. This is because the diameter of each fragment is at most $n-1$ since we only have $n$ nodes. 

Secondly, The root of each fragment is changed. The new root is the node which has the minimum weight outgoing edge. This also takes $O(n)$.

#figure(caption: "this image gives a snapshot of the algorithm in progress. the red lines signify the minimum weight outgoing edges chosen by the node.The edges are directed away from their node to signify it is outgoing.The double headed arrows signify both nodes selecting the edge as MWOE. Step three resolves this.")[
  #image("kevin/distributed-boruvka.svg")
]


Thirdly, In each new fragment formed, exactly one edge $E {u, v}$ exists such that $E{u, v}$ is the minimum weight outgoing edge of the fragment which contains $u$ and the fragment which contains $v$. Now, we must pick either u or v as the new root of the merged new fragment, which will take $O(1)$ time since it is just local computation.

Finally, we inform all the nodes in the newly merged fragment about the new fragment ID/Root. This will also take $O(n)$ time at most.

#theorem[
  The Borůvka algorithm can be implemented on $n$ number of nodes in $O(n dot log n)$ rounds in the CONGEST model
]

From the above two lemmas, we know that it takes $O(log n)$ phases to compute the MST and $O(n)$ rounds per phase. Therefore the overall bound is $O(n dot log n)$ rounds.


== Faster algorithm:
When we look at the algorithm, we can make an observation. If the minimum spanning tree has a small diameter, the algorithm is quite fast since the O(n) is just because of the diameter. 

One way we could make this faster is by handling larger fragments and smaller fragments in different ways. Making more observations, 
  1. Smaller fragments will have smaller diameters because they have much lesser nodes
  2. There can only be a small number of large fragments, since large fragments will have a greater number of nodes.

If we have too many small fragments, we will end up chaining into one large fragment. We need to avoid that as well.

We now define a large fragment as a fragment that contains more than or equal to $sqrt(n)$. From this we can also infer there can be at most $sqrt(n)$ fragments. So now, we need to find the Minimum weight outgoing edge of all the large fragments. And this just becomes an aggregation problem with the inputs of $(alpha_v, X_v)$, where $alpha_v$ is the fragment ID of v and $X_v$ is the weight of minimum outgoing edge of V. The rest of this faster algorithm will be covered in the next session.


#import "kevin.typ"