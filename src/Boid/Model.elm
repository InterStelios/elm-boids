module Boid.Model exposing (Boid)

import Color exposing (Color)
import Math.Vector2 as V2

type alias Boid =
    { position : V2.Vec2
    , angle : Int
    , speed : Int
    , colour : Color
    }


