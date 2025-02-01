#use "topfind";;
#use "float.ml";;
#require "graphics";;
open Graphics;;

open_graph "";;
resize_window 1366 768;;
set_window_title "Koch curve";;

set_color (rgb 15 155 255);;

let transformxy x y len alpha =
  x +. len *. cos alpha, y +. len *. sin alpha;;

let rec koch x y len alpha n =
  if n = 0 then
    draw_poly_line [|(truncate x,truncate y); (truncate (fst (transformxy x y len alpha)), truncate (snd (transformxy x y len alpha))) |]
  else
    begin
      koch x y (len /. 3.) alpha (n-1);
      let x1, y1 = transformxy x y (len /. 3.) alpha in 
      koch x1 y1 (len /. 3.) (alpha -. pi /. 3.) (n-1);
      let x2, y2 = transformxy x1 y1 (len /. 3.) (alpha -. pi /. 3.) in 
      koch x2 y2 (len /. 3.) (pi /. 3. +. alpha) (n-1);
      let x3, y3 = transformxy x2 y2 (len /. 3.) (pi /. 3. +. alpha) in 
      koch x3 y3 (len /. 3.) alpha (n-1)
    end;;

(* koch 600. 10. 750. (pi /. 10.) 1;; *)

for i = 0 to 10 do 
  koch 0. 0. 1300. (atan (768. /. 1366.)) i;
  if i <> 10 then   clear_graph ();
  Printf.printf "\nDONE %i\n" i
done;;