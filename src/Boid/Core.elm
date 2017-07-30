module Boid.Core exposing (create, update)

import Boid.Model exposing (Boid)
import Boid.Utils
import Collage
import Math.Vector2 as V2


create : Boid -> Collage.Form
create { position, angle, colour } =
    Collage.polygon
        [ ( 0, 0 )
        , ( 0 - 4, 0 + 5 )
        , ( 0 + 10, 0 )
        , ( 0 - 4, 0 - 5 )
        ]
        |> Collage.filled colour
        |> Collage.rotate (degrees (toFloat angle))
        |> Collage.move (V2.toTuple position)


update : ( Int, Int ) -> Boid -> Boid
update boundaries { position, angle, speed, colour } =
    let
        x =
            V2.getX position

        y =
            V2.getY position

        nextBoid =
            Boid
                (V2.vec2
                    (Boid.Utils.xDirection angle speed + x)
                    (Boid.Utils.yDirection angle speed + y)
                )
                angle
                speed
                colour
    in
        nextBoid
            |> Boid.Utils.wrapBoidPosition boundaries
