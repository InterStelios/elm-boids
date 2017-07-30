module Main exposing (main)

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
import Debug


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
      }
    , Task.perform UpdateWorld Window.size
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        maxRandomSpeed =
            1
    in
        case msg of
            Tick _ ->
                let
                    nextBoids =
                        List.map (Boid.Core.update model.world) model.boids
                in
                    ( { model | boids = nextBoids }
                    , Cmd.none
                    )

            UpdateWorld size ->
                let
                    randomPosition =
                        ( 0, 0 )
                in
                    ( { model | world = ( size.width, size.height ) }
                    , Boid.Seed.generateBoids (GeneratorMsg << BoidsGenerated) 1500 randomPosition maxRandomSpeed
                    )

            GeneratorMsg generatorOutcome ->
                case generatorOutcome of
                    BoidsGenerated generatedBoids ->
                        ( { model | boids = generatedBoids }
                        , Boid.Seed.generateRandomColours (GeneratorMsg << ColoursGenerated) maxRandomSpeed
                        )

                    ColoursGenerated colours ->
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
                            ( { model | boids = nextBoids }, Cmd.none )


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
