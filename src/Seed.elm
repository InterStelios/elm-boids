module Seed exposing (generateBoids)

import Boid
import Color
import Random
import Random.Color
import Math.Vector2 as V2


randomBoid : Float -> Float -> Int -> Int -> Color.Color -> Boid.Boid
randomBoid x y angle speed colour =
    Boid.Boid (V2.vec2 x y) angle speed colour


boidGenerator : ( Int, Int ) -> Random.Generator Boid.Boid
boidGenerator ( width, height ) =
    let
        x =
            (toFloat width) / 2

        y =
            (toFloat height) / 2

        randomXBounds =
            Random.float -x x

        randomYBounds =
            Random.float -y y

        randomDirection =
            Random.int 0 360

        randomSpeed =
            Random.int 1 5
        
        randomColour = 
            Random.Color.rgb
    in
        Random.map5
            randomBoid
            randomXBounds
            randomYBounds
            randomDirection
            randomSpeed
            randomColour


generateBoids : (List Boid.Boid -> msg) -> Int -> ( Int, Int ) -> Cmd msg
generateBoids tagger numberOfBoids bounds =
    let
        boidGeneratorWithBounds =
            boidGenerator bounds

        randomListBoidGenerator =
            Random.list numberOfBoids boidGeneratorWithBounds
    in
        Random.generate tagger randomListBoidGenerator
