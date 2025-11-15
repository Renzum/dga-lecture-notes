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

#include "karen.typ" // Include Karen's Part which is the first half of the lecture (until Borůvka's algorithm)
#include "kevin.typ" // Include Kevin's Part which is the second half of the lecture notes (from Boruvka's Algorithm)
