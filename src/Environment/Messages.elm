module Environment.Messages exposing (GeneratorOutcome(..), Msg(..))

import Boid.Model exposing (Boid)
import Color exposing (Color)
import Time
import Window


type GeneratorOutcome
    = BoidsGenerated (List Boid)
    | ColoursGenerated (List Color)


type Msg
    = Tick Time.Time
    | UpdateWorld Window.Size
    | GeneratorMsg GeneratorOutcome
