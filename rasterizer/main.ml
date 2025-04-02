#use "rasterizer.ml"

let main () =
  let o = 
    {
      x = 200.;
      y =  340.;
      h = 0.4
    } in 
  let p1 = 
    {
      x = -50.0;
      y = -200.;
      h = 0.
    } in 
  let p2 = 
    {
      x = -600.0;
      y = 240.0;
      h = 0.9
    } in 
 
    outline_triangle o p1 p2 red;
    shade_triangle o p1 p2 (245,0,0);
    (* ignore (read_line ());
    close_graph ();; *)

let _ = main ()