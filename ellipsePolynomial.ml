#use "topfind";;
#require "graphics";;
open Graphics;;
open_graph "";;
resize_window 1366 768;;
set_color black;;
set_window_title "Ellipse using polynomial";;

let plot_sym_points x y dimx dimy =
  plot (dimx+x) (dimy+y);
  plot (dimx-x) (dimy+y);
  plot (dimx-x) (dimy-y);
  plot (dimx+x) (dimy-y);;

let ordinate x a b =
  truncate (b *. (1. -. (float x /. a)**2.)**0.5);;

let ellipse a b dimx dimy =
  for x = 0 to truncate a do 
    plot_sym_points x (ordinate x a b) dimx dimy
  done;;

ellipse 370. 250. 500 300;;