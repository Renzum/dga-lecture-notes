#import "@preview/diagraph:0.3.6": *

#align(center)[
  #figure(caption: [BFS Tree constructed using the modified Flooding Algorithm])[
    #raw-render(
      ```dot
      digraph {
        s -> v_2[color=green]
        s -> v_3[color=green]
        s -> v_6[color=green]
        v_2 -> v_3
        v_2 -> v_5
        v_2 -> v_4[color=green]
        v_3 -> v_5[color=green]
      }
      ```,
      edges: (
        "s": ("v_2": "M", "v_3": "M", "v_6": "M"),
        "v_2": ("v_3": "M", "v_4": "M", "v_5": "M"),
        "v_3": ("v_5": "M"),
      ),
    )

    #raw-render(
      ```dot
      digraph {
        rankdir=BT
        v_2 -> s
        v_3 -> s
        v_4 -> v_2
        v_5 -> v_3
        v_6 -> s
      }
      ```,
    )]
]
