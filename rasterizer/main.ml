#use "rasterizer.ml"

let main () =
  let o = 
    {
      x=0.;
      y=0.
    } in 
  let p1 = 
    {
      x = -50.0;
      y = -200.
    } in 
  let p2 = 
    {
      x = 600.0;
      y = 240.0
    } in 
  draw_line o p2 green ;
  draw_line o p1 blue ;;
  (* draw_line p2 p1 red ;; *)


let _ = main ()