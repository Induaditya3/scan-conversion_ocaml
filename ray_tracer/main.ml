#use "vbrt.ml";;

let main () =
    let o = {x =0.;y =0.;z =0.} in (* the origin O*)
    let s1 = 
    {
        c = {x = 0.;y= - 1.; z = 3.};
        r = 1.;
        color = (255, 0, 0)
    } in 
    let s2 =
    {
        c = {x = 2.; y = 0.; z = 4.};
        r = 1.;
        color = (0, 0, 255);
    } in 
    let s3 =
    {
        c = {x = - 2. ; y = 0. ; z = 4.};
        r = 1.;
        color = (0, 255, 0)
    } in
    (* list of sphere *)
    let ls = [s1;s2;s3] in 
    let gw, gh = size_x (), size_y () in (*max width and height of graphics window *)
    for x = -gw/2 to gw/2 do 
        for y = -gh/2 to gh/2 do 
            let v = g_to_viewport x y in
            let color = rtx o v 1. infinity ls (ref None)  (ref (Some infinity)) in 
            plotc x y color
        done;
    done

let () = main ()