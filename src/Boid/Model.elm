module Boid.Model exposing (Boid)

import Color exposing (Color)
import Math.Vector2 as V2


type alias Boid =
    { location : V2.Vec2
    , direction : Int
    , speed : Int
    , colour : Color
    }
