module Boid.Seed exposing (generateBoids, generateRandomColours)

import Boid.Model exposing (Boid)
import Color exposing (Color)
import Random
import Random.Color
import Math.Vector2 as V2


randomBoid : Float -> Float -> Int -> Int -> Boid
randomBoid x y angle speed =
    Boid (V2.vec2 x y) angle speed Color.white


boidGenerator : ( Int, Int ) -> (Int, Int) -> (Int, Int) -> Random.Generator Boid
boidGenerator ( width, height ) (minSpeed, maxSpeed) (minAngle, maxAngle) =
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
            Random.int minAngle maxAngle

        randomSpeed =
            Random.int minSpeed maxSpeed
        
    in
        Random.map4
            randomBoid
            randomXBounds
            randomYBounds
            randomDirection
            randomSpeed


generateBoids : (List Boid -> msg) -> Int -> ( Int, Int ) -> (Int, Int) -> (Int, Int) -> Cmd msg
generateBoids tagger numberOfBoids bounds orientation speed =
    let
        boidGeneratorWithBounds =
            boidGenerator bounds speed orientation

        randomListBoidGenerator =
            Random.list numberOfBoids boidGeneratorWithBounds
    in
        Random.generate tagger randomListBoidGenerator


generateRandomColours : (List Color -> msg) -> Int -> Cmd msg
generateRandomColours tagger numberOfBoids =
            Random.generate 
                tagger 
                (Random.list numberOfBoids Random.Color.rgb)

