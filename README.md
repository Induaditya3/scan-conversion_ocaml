# scan-conversion_ocaml

some cg primitives implemented from ground up

## scan-line algorithm

This is a doc of my implementation of it in [OCaml](./fill_scan-line.ml). This is only capable of filling a triangle but can extended to polygon of arbitrary no. of sides provided edges (meaning which vertices are connected to which) .

Side parallel to $x$ - axis should be handled carefully because inverse of slope, $\frac{1}{m} = \frac{\Delta x}{\Delta y}$ will yield nan as $\Delta y =0 $. But they can drawn simply when scan-line is overlapping it.

Since difference between two consecutive scan-line 

$$\Delta y = y_{c} - y_{p} = 1 $$

Next point of intersection with scan-line with side of polygon can be found 

$$\Rightarrow x_c = x_p + (x_c - x_p) = x_p + \Delta x = x_p + \frac{1}{m} $$ 

where 

$$ y_c \rightarrow current \, scanline $$

$$ y_p \rightarrow previous \, scanline $$

$$ x_c \rightarrow current \, point \, of \, intersection  \, scanline \, with \, side $$

$$ x_p \rightarrow previous \, point \, of \, intersection  \, scanline \, with \, side $$


![Filled triangle](/figures/fill_fig.png)


### algorithm 

Given
- an array of vertices

`let arr = [|(426., 600.); (134., 76.); (720., 76.)|];;`

Records for bunching together all properties we care about in an edge. Here, ymin is smaller of ordinate defining an edge, ymax is bigger of ordinates defining the same edge, x is abcissa of point of intersection of scanline with the side (initially it is set abcissa corresponding to ordinate of ymin), mi is the reciprocal of slope of the edge, a is whether edge is active or not (meaning scanline is intersecting the edge).
```OCaml
type edge = 
{
  ymin : float;
  ymax : float;
  mutable x: float;
  mi   : float;
  mutable a : bool
}
```
Following is helper function which is given to `Array.sort` to sort vertices based on their ordinatate in increasing order.
```OCaml
let cmp a b = 
  if snd a > snd b then 1
  else if snd a < snd b then -1
  else 0
```
For finding reciprocal of slope .
```OCaml
let slope_inv a b =
  (fst a -. fst b) /. (snd a -. snd b)
```
For generating edge (record).
```OCaml
let gen_edge small big = 
  {ymin = snd small; ymax = snd big; x = fst small; mi = slope_inv small big; a = false}
```
For building array of edges given array of vertices.
```OCaml
let edge_arr arr =
  Array.sort cmp arr;
  let edges = ref [] in 
  if snd arr.(1) -. snd arr.(2) <> 0. then
    edges :=  (gen_edge arr.(1) arr.(2)) :: !edges;
  if snd arr.(0) -. snd arr.(2) <> 0. then
    edges :=  (gen_edge arr.(0) arr.(2)) :: !edges;
  if snd arr.(0) -. snd arr.(1) <> 0. then
    edges :=  (gen_edge arr.(0) arr.(1)) :: !edges;
  Array.of_list !edges
```
For activating edges if ymin is equal to scanline. That is when scanline intersects lower vertex of an edge.
```OCaml
let activate_edges l current_scanline =
  for i = 0 to Array.length l -1 do 
    if l.(i).ymin = current_scanline then 
      l.(i).a <- true
  done
```
For deactivating edges if scanline passes upper vertex of an edge.
```OCaml
let deactivate_edges l current_scanline =
  for i = 0 to Array.length l -1 do 
    if l.(i).ymax = current_scanline then 
      l.(i).a <- false
  done
```
For drawing horizontal lines when given abcissas of point of intersection with scanline.
```OCaml
let horizontal_line x1 x2 y =
  for x = truncate (min x1 x2) to truncate (max x1 x2) do 
    plot x (truncate y)
  done
```
For finding out which edges are active and storing their index and updating point of intersection with scanline and drawing horizontal line . We make sure no. of active edges are even because horizontal line can be drawn if two point of abcissas are given.
```OCaml
let process_active l current_scanline =
  let active_indices = ref [] in 
  for i = 0 to Array.length l - 1 do 
    if l.(i).a then
      begin
        active_indices := i :: !active_indices;
        l.(i).x <- l.(i).x +. l.(i).mi
      end
  done;
  let no_of_active = List.length !active_indices in 
  if no_of_active > 0 && no_of_active mod 2 = 0 then 
    begin
      for i = 0 to no_of_active / 2 - 1 do 
        horizontal_line l.(List.nth !active_indices i).x l.(List.nth !active_indices (i + 1)).x current_scanline
      done
    end
```
Finally filling the triangle by iterating through botttom of the screen to top of the screen.
```OCaml
let fill arr =
  let edges = edge_arr arr in 
  for scanline = 0 to size_y ()-1 do 
    activate_edges edges (float scanline);
    deactivate_edges edges (float scanline);
    process_active edges (float scanline);
  done
```