#use "topfind";;
#require "graphics";;
open Graphics;;

open_graph "";;
resize_window 1366 768;;
set_window_title "Bresenham's Line algorithm";;

(* line joining (0,0) and (1366,768) *)
let x1 = 0;;
let x2 = 1366;;
let y1 = 0;;
let y2 = 768;;

set_color (rgb 155 155 155)

let d_next d_prev delta_x delta_y =
    if d_prev >= 0 then 
        d_prev + 2 * (delta_y - delta_x)
    else
        d_prev + 2 * delta_y

let rec liner d_prev x y x_final delta_x delta_y list =
    let d = d_next d_prev delta_x delta_y in 
    if x < x_final then
        begin
            if d >= 0 then 
                liner d (x+1) (y+1) x_final delta_x delta_y ((x+1,y+1)::list)
            else
                liner d (x+1) y x_final delta_x delta_y ((x+1,y)::list)
        end
    else list;;
            
let rec plotter (h::t) slope =
    try
        match h with
        (x, y) -> 
            if slope > 0. && slope < 1. then
                (plot (fst h) (snd h); plotter t slope)
            else if slope >= 1. && slope < max_float then
                (plot (snd h) (fst h); plotter t slope)
            else if slope > -1. && slope < 0. then
                (plot (fst h) (-(snd h)); plotter t slope)
    with _ -> () ;;

let line_plotter x1 x2 y1 y2 =
    let slope = (float y2 -. float y1) /. (float x2 -. float x1) in
    let dx = x2 - x1 in 
    let dy = y2 - y1 in
    let d1 = 2*dy - dx in
    if slope > 0. && slope < 1. then 
        let points = liner d1 x1 y1 x2 dx dy [] in 
        plotter points slope
    else if slope >= 1. && slope < max_float then
        let points = liner d1 y1 x1 y2 dy dx [] in 
        plotter points slope
    else if slope > -1. && slope < 0. then 
        let points = liner d1 x1 (-y1) x2 dx dy [] in 
        plotter points slope;;

line_plotter x1 x2 y1 y2;;
set_color (rgb 40 255 40);;
line_plotter 1300 1366 500 768;;
set_color (rgb 100 100 89);;
line_plotter 0 1366 700 500