#use "topfind";;
#require "graphics";;
open Graphics;;

open_graph "";;
resize_window 1366 768;;
set_window_title "";;
set_color (rgb 128 192 215);;

type edge = 
{
  ymin : float;
  ymax : float;
  mutable x: float;
  mi   : float;
  mutable a : bool
}

(* let arr = [|(5.,6.);(1.,2.);(3.,4.)|];; *)
let arr = [|(426., 600.); (134., 76.); (720., 76.)|];;

let cmp a b = 
  if snd a > snd b then 1
  else if snd a < snd b then -1
  else 0;;

let slope_inv a b =
  (fst a -. fst b) /. (snd a -. snd b);;

let gen_edge small big = 
  {ymin = snd small; ymax = snd big; x = fst small; mi = slope_inv small big; a = false};;
let edge_arr arr =
  Array.sort cmp arr;
  let edges = ref [] in 
  if snd arr.(1) -. snd arr.(2) <> 0. then
    edges :=  (gen_edge arr.(1) arr.(2)) :: !edges;
  if snd arr.(0) -. snd arr.(2) <> 0. then
    edges :=  (gen_edge arr.(0) arr.(2)) :: !edges;
  if snd arr.(0) -. snd arr.(1) <> 0. then
    edges :=  (gen_edge arr.(0) arr.(1)) :: !edges;
  Array.of_list !edges;;

let activate_edges l current_scanline =
  for i = 0 to Array.length l -1 do 
    if l.(i).ymin = current_scanline then 
      l.(i).a <- true
  done;;

let deactivate_edges l current_scanline =
  for i = 0 to Array.length l -1 do 
    if l.(i).ymax = current_scanline then 
      l.(i).a <- false
  done;;

let horizontal_line x1 x2 y =
  for x = truncate (min x1 x2) to truncate (max x1 x2) do 
    plot x (truncate y)
  done;;

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
    end;;

let l = edge_arr arr;;
activate_edges l 2.;;
l;;

let fill arr =
  let edges = edge_arr arr in 
  for scanline = 0 to 768 do 
    activate_edges edges (float scanline);
    deactivate_edges edges (float scanline);
    process_active edges (float scanline);
  done;;

fill arr;;