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
== Basic Parallel/Distributed MST Algorithm (Boruvka's algorithm)

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

#lemma[
  For an Minimum spanning tree fragment F, The Minimum Weight Outgoing Edge ${ u, v }$ must be an edge of the Minimum Spanning tree.
]

To prove the above lemma, Take a fragment $F$. For the edge $u$ of the fragment, lets say it has an edge $e$ with a node $v$ outside of the fragment. Let us take that this edge $e = {u, v}$ is our minimum weight outgoing edge.

Now, for contradiction, let us assume the edge $e$ is not in the minimum spanning tree. There must now be a path $P$ existing that connects $u$ and $v$ in the MST. So there has to be some other edge $f$ through which the path $P$ will enter the fragment $F$.

Now if we replace $f$ by $e$, we will get a new spanning tree of smaller weight since we assumed $e$ is our *minimum weight outgoing edge*. Therefore, this will always be our minimum spanning tree.

== Boruvka's Algorithm


#show: style-algorithm

#algorithm-figure(
  "Boruvka's Algorithm",
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
) <Boruvka>

#lemma[
  Boruvka's Algorithm computes the Minimum Spanning Tree from $n$ number of nodes in $O(log n)$ phases.
]

*Proof:*
We know that the algorithm does compute the MST by the end. 

The number of fragments is always divided by atleast 2 in each phase. This way we end up having $log n$ number of phases.

== Distributed Implementation of Boruvka's Algorithm


To implement a distributed version of boruvka's Algorithm, We have to
- *For each fragment* 
  - Keep a rooted spanning tree
  - Each fragment should have a unique identifier
  - Each node in the fragment should know the unique identifier

#lemma[
  One Phase of Boruvka's algorithm for $n$ number of nodes can be implemented in $O(n)$ rounds
]

*Proof*:

Firstly, we claim that each fragment can find it's minimum weight outgoing edge in $O(n)$ rounds. This is because the diameter of each fragment is at most $n-1$ since we only have $n$ nodes. 

Secondly, The root of each fragment is changed. The new root is the node which has the minimum weight outgoing edge. This also takes $O(n)$. 

Thirdly, In each new fragment formed, exactly one edge $E {u, v}$ exists such that $E{u, v}$ is the minimum weight outgoing edge of the fragment which contains $u$ and the fragment which contains $v$. Now, we must pick either u or v as the new root of the merged new fragment, which will take $O(1)$ time since it is just local computation.

Finally, we inform all the nodes in the newly merged fragment about the new fragment ID/Root. This will also take $O(n)$ time at most.

#theorem[
  The Boruvka algorithm can be implemented on $n$ number of nodes in $O(n dot log n)$ rounds in the CONGEST model
]

From the above two lemmas, we know that it takes $O(log n)$ phases to compute the MST and $O(n)$ rounds per phase. Therefore the overall bound is $O(n dot log n)$ rounds.


#import "kevin.typ"