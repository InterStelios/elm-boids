module Boid.Utils exposing (direction, wrapBoidPosition)

import Boid.Model exposing (Boid)
import Math.Vector2 as V2
import Utils


direction : Int -> Int -> (Float -> Float) -> Float
direction angle step trigonometricFn =
    (toFloat step)
        * (angle
            |> toFloat
            |> degrees
            |> trigonometricFn
          )


wrapBoidPosition : ( Int, Int ) -> Boid -> Boid
wrapBoidPosition ( width, height ) boid =
    { boid
        | position =
            Utils.wrapPosition
                boid.position
                (V2.vec2 (toFloat width) (toFloat height))
    }
