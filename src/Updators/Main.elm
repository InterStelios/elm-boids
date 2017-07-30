module Updators.Main exposing (updateBoidsWithUniqColourBySpeed, updateBoids)

import Boid.Core
import Color


updateBoidsWithUniqColourBySpeed model colours =
    let
        setColour boid =
            { boid
                | colour =
                    List.indexedMap (,) colours
                        |> List.filter (\( i, colour ) -> i == boid.speed)
                        |> List.head
                        |> Maybe.withDefault ( 0, Color.white )
                        |> \( i, colour ) -> colour
            }

        nextBoids =
            List.map
                (\boid -> setColour boid |> Boid.Core.update model.world)
                model.boids
    in
        { model | boids = nextBoids }


updateBoids model =
    let
        nextBoids =
            List.map (Boid.Core.update model.world) model.boids
    in
        { model | boids = nextBoids }
