module Main exposing (main)

import Updators.Main
import Boid.Model exposing (Boid)
import Boid.Core
import Collage
import Color exposing (Color)
import Dict exposing (Dict)
import Element
import Html
import Html.Attributes
import List
import Boid.Seed
import Task
import Time
import Utils
import Window


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type alias Model =
    { boids : List Boid
    , coloursPerSpeed : Dict Int Color
    , world : ( Int, Int )
    , config :
        { maxRandomSpeed : Int
        }
    }


type GeneratorOutcome
    = BoidsGenerated (List Boid)
    | ColoursGenerated (List Color)


type Msg
    = Tick Time.Time
    | UpdateWorld Window.Size
    | GeneratorMsg GeneratorOutcome


init : ( Model, Cmd Msg )
init =
    ( { boids = []
      , world = ( 0, 0 )
      , coloursPerSpeed = Dict.empty
      , config =
            { maxRandomSpeed = 5
            }
      }
    , Task.perform UpdateWorld Window.size
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick _ ->
            ( Updators.Main.updateBoids model, Cmd.none )

        UpdateWorld { width, height } ->
            ( { model | world = ( width, height ) }
            , Boid.Seed.generateBoids (GeneratorMsg << BoidsGenerated) 1500 ( 0, 0 ) model.config.maxRandomSpeed
            )

        GeneratorMsg generatorOutcome ->
            case generatorOutcome of
                BoidsGenerated generatedBoids ->
                    ( { model | boids = generatedBoids }
                    , Boid.Seed.generateRandomColours (GeneratorMsg << ColoursGenerated) model.config.maxRandomSpeed
                    )

                ColoursGenerated colours ->
                    ( Updators.Main.updateBoidsWithUniqColourBySpeed model colours, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch
        [ Time.every 16 Tick
        ]


view : Model -> Html.Html msg
view { boids, world } =
    let
        ( width, height ) =
            world
    in
        Html.div
            [ Html.Attributes.style
                [ ( "backgroundColor", "black" )
                , ( "color", "black" )
                ]
            ]
            [ Collage.collage
                width
                height
                (List.map Boid.Core.create boids
                    |> Utils.addAxis width height
                )
                |> Element.toHtml
            ]
