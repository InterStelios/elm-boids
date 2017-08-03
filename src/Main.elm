module Main exposing (..)

import Environment.Messages exposing (GeneratorOutcome(..), Msg(..))
import Environment.Model exposing (Model, initModel)
import Updators.Main
import Boid.View
import Collage
import Element
import Html
import Html.Attributes
import List
import Boid.Seed
import Time
import Utils


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        { speed, boids, orientation, bounds } =
            model.config
    in
        case msg of
            Tick _ ->
                ( Updators.Main.updateBoids model, Cmd.none )

            UpdateWorld { width, height } ->
                ( { model | world = ( width, height ) }
                , Boid.Seed.generateBoids
                    (GeneratorMsg << BoidsGenerated)
                    boids
                    bounds
                    orientation
                    speed
                )

            GeneratorMsg generatorOutcome ->
                case generatorOutcome of
                    BoidsGenerated generatedBoids ->
                        ( { model | boids = generatedBoids }
                        , Boid.Seed.generateRandomColours
                            (GeneratorMsg << ColoursGenerated)
                            (Tuple.second model.config.speed)
                        )

                    ColoursGenerated colours ->
                        ( Updators.Main.updateBoidsWithUniqColourBySpeed
                            model
                            colours
                        , Cmd.none
                        )


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
                (List.map Boid.View.create boids
                    |> Utils.addAxis width height
                )
                |> Element.toHtml
            ]


main : Program Never Model Msg
main =
    Html.program
        { init = initModel
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
