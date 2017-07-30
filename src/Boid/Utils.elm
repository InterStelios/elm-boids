module Boid.Utils exposing (xDirection, yDirection, wrapBoidPosition)

import Boid.Model exposing (Boid)
import Math.Vector2 as V2
import Utils


xDirection : Int -> Int -> Float
xDirection angle step =
    (toFloat step)
        * (angle
            |> toFloat
            |> degrees
            |> cos
          )


yDirection : Int -> Int -> Float
yDirection angle step =
    (toFloat step)
        * (angle
            |> toFloat
            |> degrees
            |> sin
          )


wrapBoidPosition : ( Int, Int ) -> Boid -> Boid
wrapBoidPosition ( width, height ) boid =
    { boid
        | position =
            Utils.wrapPosition
                boid.position
                (V2.vec2 (toFloat width) (toFloat height))
    }
