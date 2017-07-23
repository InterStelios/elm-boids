module Seed exposing (generateBoids)

import Boid exposing (Boid)
import Random exposing (Generator, generate, list, float, map3)


randomBoid : Float -> Float -> Float -> Boid
randomBoid x y angle = 
  Boid (x, y) angle

boidGenerator : Generator Boid
boidGenerator = 
      (map3 randomBoid (float -250 250) (float -250 250) (float 0 360))

generateBoids : (List Boid -> msg) -> Int -> Cmd msg
generateBoids tagger numberOfBoids =
    generate tagger (list numberOfBoids boidGenerator)
