#use "topfind";;
#require "graphics";;
open Graphics;;
open_graph "";;
resize_window 1366 768;;
set_color cyan;;
set_window_title "Circle using polynomial";;


let plot_sym_points (x, y) dimx dimy =
  plot (dimx+x) (dimy+y);
  plot (dimx+y) (dimy+x);
  plot (dimx+y) (dimy-x);
  plot (dimx+x) (dimy-y);
  plot (dimx-x) (dimy-y);
  plot (dimx-y) (dimy-x);
  plot (dimx-y) (dimy+x);
  plot (dimx-x) (dimy+y);;

let circle r dimx dimy =
  let ordinate x = truncate ( (r *. r -. float (x * x))** 0.5) in 
  for i = 0 to truncate (r /. (2. ** 0.5)) do
    plot_sym_points (i, ordinate i) dimx dimy 
  done;;

circle 300. 700 330;;