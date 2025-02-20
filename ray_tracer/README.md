# Very Basic Ray tracer (in progress)

## coordinate system

In OCaml standard graphics library, origin of drawing window is situated at bottom left corner of it. For convenience we want it in middle of the window. So we need wrapper function 

```Ocaml
let plotc x' y' color =
    let x,y = x + size_x() / 2, y + size_y / 2 in 
    set_color (rgb color);
    plot x y;;
```
It translates origin to middle of the graphics window.

## colors

We use additive color model (RGB model), obviously.
With each color channel represented by 8 bit positive integer. So, range is [0,255]. We can treat triplet of RGB values as a vector. Then, adding two colors together we get new color. And mutiplying a color by scalar just increases brightness , i.e.

$$k (r, g, b) = (kr, kg, kb) $$

There is a chance that any of channel value goes out of range [0,255], while manipulating colors. We can handle this as follows:

Suppose there is channel value $x$
- If $x > 255 $,
 then we set $x = 255$
- If $x <0$ then we set $x = 0$ 

This is called **clamping**.

## scene

The scene is simply set of objects that we want render on the screen.

For representing objects in a scene, we need use 3D coordinate system which uses real numbers to represent  continous values, then map that to discrete 2D grahics window while drawing.

![3D cordinate](./figs/3Dcoodinate.png)

Its clear from figure which axes point in which direction.

Viewing position from where we look at the scene is called **camera position**. We assume that camera is fixed and occupies single point in space which often will be origin $O(0,0,0)$. 

**Camera orientation** is the direction in which camera points, or from where rays enter the camera. We will assume camera orientation to be $Z_+$, positive z axis. 

Frame, which is actualy graphics window where 3D scene get mapped to 2D, has dimension $V_w$ and $V_h$ and is frontal to camera (perpendicular to camera orientation irrespective of camera position, in our case perpendicular to $Z_+$ ) and $d$ distance away from camera.