module Boid.View exposing (create)

import Boid.Model exposing (Boid)
import Collage
import Math.Vector2 as V2


createBoidShape : Collage.Shape
createBoidShape =
    Collage.polygon
        [ ( 0, 0 )
        , ( 0 - 4, 0 + 5 )
        , ( 0 + 10, 0 )
        , ( 0 - 4, 0 - 5 )
        ]


create : Boid -> Collage.Form
create { location, direction, colour } =
    createBoidShape
        |> Collage.filled colour
        |> Collage.rotate (degrees (toFloat direction))
        |> Collage.move (V2.toTuple location)
