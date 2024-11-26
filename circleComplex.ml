#use "complex.ml";;
#use "topfind";;
#require "graphics";;
open Graphics;;
open_graph "";;
resize_window 1366 768;;
set_color red;;
set_window_title "Circle using Complex numbers";;
(* dimx dimy can be used to set center of the circle. eg dimx = -20. dimy = -30. to set center to be (19,29) *)
let dimx = -701.
let dimy = -331.
let delta = 1.;; 
let x = ref {re = dimx; im = dimy};;
let xre = ref (dimx);; 
let xim = ref (dimy);;
let circle r = 
  for i = 0 to size_x () -1 do
    xre := !xre +. delta;
    xim := dimy;
    for j = 0 to size_y () -1 do
      xim := !xim +. delta;
      x := {re = !xre; im = !xim};
      if truncate (norm !x) < r then plot i j
    done;
  done;;

circle 300;;