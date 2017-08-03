module Boid.Model exposing (Boid, update)

import Color exposing (Color)
import Math.Vector2 as V2
import Utils


type alias Boid =
    { location : V2.Vec2
    , direction : Int
    , speed : Int
    , colour : Color
    }


update : ( Int, Int ) -> Boid -> Boid
update boundaries { location, direction, speed, colour } =
    let
        x =
            V2.getX location

        y =
            V2.getY location

        nextBoid =
            Boid
                (V2.vec2
                    (updateDirection direction speed cos + x)
                    (updateDirection direction speed sin + y)
                )
                direction
                speed
                colour
    in
        nextBoid
            |> wrapBoidPosition boundaries


updateDirection : Int -> Int -> (Float -> Float) -> Float
updateDirection angle step trigonometricFn =
    (toFloat step)
        * (angle
            |> toFloat
            |> degrees
            |> trigonometricFn
          )


wrapBoidPosition : ( Int, Int ) -> Boid -> Boid
wrapBoidPosition ( width, height ) boid =
    { boid
        | location =
            Utils.wrapPosition
                boid.location
                (V2.vec2 (toFloat width) (toFloat height))
    }
