#use "topfind";;
#require "graphics";;
open Graphics;;
open_graph "";;
resize_window 1366 768;;
set_color red;;
set_window_title "Ellipse using trigonometry";;

let plot_sym_points x y dimx dimy =
  plot (dimx+x) (dimy+y);
  plot (dimx-x) (dimy+y);
  plot (dimx-x) (dimy-y);
  plot (dimx+x) (dimy-y);;

let ellipse a b dimx dimy n =
  for i = 0 to truncate (n *. atan 1.0 *. 2.) do 
    print_int i;print_newline ();
    plot_sym_points (truncate (a *. cos (float i /. n))) (truncate (b *. sin (float i /. n))) dimx dimy
  done;;
  
ellipse 370. 250. 500 300 200.;;

let ellipse_with_angle a b dimx dimy n theta =
  for i = 0 to truncate (n *. atan 1.0 *. 2.) do 
    let o = float i /. n in
    plot_sym_points (truncate (a *. cos o -. b *. sin (theta +. o))) (truncate (b *. sin o +. a *. cos (theta +. o))) dimx dimy
  done;;

ellipse_with_angle 37. 25. 500 300 200. 60.;;