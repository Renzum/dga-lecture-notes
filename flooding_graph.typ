#import "@preview/diagraph:0.3.6": *

#align(center)[
  #raw-render(
    ```dot
    digraph {
      s -> v_2
      v_2 -> v_3
      v_2 -> v_4
    }
    ```,
    edges: (
      "s": ("v_2": "M"),
      "v_2": ("v_3": "M", "v_4": "M"),
    ),
  )
]
