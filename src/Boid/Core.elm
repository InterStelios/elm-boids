module Boid.Core exposing (create, update)

import Boid.Model exposing (Boid)
import Boid.Utils
import Collage
import Math.Vector2 as V2


create : Boid -> Collage.Form
create { location, direction, colour } =
    Collage.polygon
        [ ( 0, 0 )
        , ( 0 - 4, 0 + 5 )
        , ( 0 + 10, 0 )
        , ( 0 - 4, 0 - 5 )
        ]
        |> Collage.filled colour
        |> Collage.rotate (degrees (toFloat direction))
        |> Collage.move (V2.toTuple location)


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
                    (Boid.Utils.direction direction speed cos + x)
                    (Boid.Utils.direction direction speed sin + y)
                )
                direction
                speed
                colour
    in
        nextBoid
            |> Boid.Utils.wrapBoidPosition boundaries
