module Environment.Model exposing (Model, initModel)

import Boid.Model exposing (Boid)
import Color exposing (Color)
import Dict exposing (Dict)
import Environment.Messages exposing (Msg(..))
import Task
import Window


type alias Model =
    { boids : List Boid
    , coloursPerSpeed : Dict Int Color
    , world : ( Int, Int )
    , config :
        { speed : ( Int, Int )
        , orientation : ( Int, Int )
        , bounds : ( Int, Int )
        , boids : Int
        }
    }


initModel : ( Model, Cmd Msg )
initModel =
    ( { boids = []
      , world = ( 0, 0 )
      , coloursPerSpeed = Dict.empty
      , config =
            { speed = ( 1, 10 )
            , boids = 1500
            , orientation = ( 90, 180 )
            , bounds = ( 0, 0 )
            }
      }
    , Task.perform UpdateWorld Window.size
    )
