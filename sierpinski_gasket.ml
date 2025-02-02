#use "topfind";;
#require "graphics";;
(* #require "unix";; *)
open Graphics;;

open_graph "";;
resize_window 1366 768;;
set_window_title "Sierpinski gasket";;
set_color (rgb 128 192 25);;

let midptxy a b =
  (fst a +. fst b) /. 2., (snd a +. snd b) /. 2.;;

let rec sn arr n =
  if n = 0 then
    fill_poly (Array.map (fun (x,y) -> (truncate x, truncate y)) arr)
  else if n > 0 then
    begin
      let d = midptxy arr.(0) arr.(2) in
      let e = midptxy arr.(0) arr.(1) in 
      let f = midptxy arr.(2) arr.(1) in 
      sn [|arr.(0); d; e|] (n-1);
      sn [|arr.(1); f; e|] (n-1);
      sn [|arr.(2); d; f|] (n-1)
    end;;

(* sn [|(426., 600.); (134., 76.); (720., 76.)|] 8;; *)
for i = 0 to 8 do 
  sn [|(426., 600.); (134., 76.); (720., 76.)|] i;
  Unix.sleep 2;
  if i <> 8 then   clear_graph ();
  Printf.printf "\nDONE %i\n" i
done;;