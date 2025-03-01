#use "vbrt.ml";;

let main () =
    let o = {x = 0.;y = 0.;z = 0.} in (* the origin O*)
    let s1 = 
    {
        c = {x = 0.;y= - 1.; z = 3.};
        r = 1.;
        color = (255, 0, 0);
        s = 500;
        rfl = 0.2
    } in 
    let s2 =
    {
        c = {x = -2.; y = 1.; z = 3.};
        r = 1.;
        color = (0, 0, 255);
        s = 500;
        rfl = 0.3
    } in 
    let s3 =
    {
        c = {x =  2. ; y = 1. ; z = 3.};
        r = 1.;
        color = (0, 255, 0);
        s = 50;
        rfl = 0.4
    } in
    let s4 =
    {
        c = {x = 0.; y = - 5001.; z = 0.};
        r = 5000.;
        color = (255, 255, 0);
        s = 1000;
        rfl = 0.5
    } in
    (* list of sphere *)
    let ls = [s1;s2;s3;s4] in 
    let l1 =
    {
        k = 'a';
        i = 0.2;
        v = None
    } in
    let l2 =
    {
        k= 'p';
        i = 0.6;
        v = Some {x =2.;y= 1.;z= 0.}
    } in 
    let l3 =
    {
        k = 'd';
        i = 0.2;
        v = Some {x=1.;y= 4.;z= 4.}
    } in 
    let ll = [l1;l2;l3] in 
    let gw, gh = size_x (), size_y () in (*max width and height of graphics window *)
    for x = -gw/2 to gw/2 do 
        for y = -gh/2 to gh/2 do 
            let v = g_to_viewport x y in
            let d = sub3 v o in
            let color = rtx o d 1. infinity ls ll in 
            plotc x y color
        done;
    done

let () = main ()