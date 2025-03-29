#use "topfind";;
#require "graphics";;
open Graphics;;

open_graph "";;
resize_window 1366 768;;
set_window_title "rasterizer";;

(* two dimensional point *)
type point_2 =
  {
    x : int;
    y : int
  }

let plotc x' y' color =
  let x,y =  x' + (size_x ()) / 2, y' + (size_y ()) / 2 in 
  set_color color;
  plot x y
