module Main exposing (main)

import Array exposing (Array)
import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)


type alias Comment =
    { author : String, createdAt : String, content : String }


type alias Comments =
    List Comment


type alias Msg =
    { desc : String, data : String }


type alias Model =
    { gallery : List String, comments : Comments, selectedImage : String, selectedComment : String }


renderName : String -> Html msg
renderName str =
    div [ class "name" ] [ h4 [] [ text str ] ]


renderNameSpacer : String -> Html msg
renderNameSpacer str =
    div [ id "name-spacer" ] [ h4 [] [ text str ] ]


renderSubtitle : String -> Html msg
renderSubtitle str =
    div [ class "subtitle" ] [ h4 [] [ text str ] ]


introText : List (Html msg)
introText =
    [ renderName "최성필"
    , renderNameSpacer "그리고"
    , renderName "최수강"
    ]
        ++ List.map
            renderSubtitle
            [ "2020.04.19 SUN AM 11:00"
            , "서울특별시 종로구 종로1길 50 (중학동)"
            , "더케이트윈타워 A동 LL층 (지하2층)"
            ]


galleryImages : List String
galleryImages =
    [ "DSC00897_Resize.jpg"
    , "DSC00314_Resize.jpg"
    , "DSC00746_Resize.jpg"
    , "DSC00421_Resize.jpg"
    , "DSC00886_Resize.jpg"
    , "DSC00900_Resize.jpg"
    , "DSC00446_Resize.jpg"
    , "DSC00873_Resize.jpg"
    , "DSC00297_Resize.jpg"
    ]


genLink : String -> String
genLink fname =
    let
        bucket =
            "choi-choi"

        region =
            "ap-northeast-2"
    in
    "https://" ++ bucket ++ ".s3." ++ region ++ ".amazonaws.com/" ++ fname


stringifyComment : Comment -> String
stringifyComment comment =
    String.join "/////" [ comment.author, comment.createdAt, comment.content ]


genComment : Comment -> Html Msg
genComment comment =
    div
        [ class "container-comment", onClick { desc = "comment-clicked", data = stringifyComment comment } ]
        [ div [ class "container-comment-top" ]
            [ div [ class "container-comment-author" ] [ span [ class "text-author" ] [ text comment.author ] ]
            , div [ class "container-comment-created-at" ] [ text comment.createdAt ]
            ]
        , div
            [ class "container-comment-btm" ]
            [ text comment.content ]
        ]


makeThumbnail : String -> String -> Html Msg
makeThumbnail selected link =
    div
        [ class
            (if selected == link then
                "thumbnail-selected"

             else
                "thumbnail"
            )
        , style "background" ("url(" ++ link ++ ") no-repeat center")
        , onClick { desc = "image-selected", data = link }
        ]
        []


defaultComments : List Comment
defaultComments =
    [ { author = "Mom", createdAt = "2020-01-15", content = "Hi I am a mom" }
    , { author = "Dad", createdAt = "2020-01-15", content = "Hi I am a dad" }
    ]


links : List String
links =
    List.map genLink galleryImages


initialModel : Model
initialModel =
    { gallery = links
    , comments = defaultComments
    , selectedComment = ""
    , selectedImage =
        case List.head links of
            Nothing ->
                ""

            Just val ->
                val
    }


view : Model -> Html Msg
view model =
    div [ id "container-main" ]
        [ div
            [ id "container-flower" ]
            [ img [ id "flower-border", src "https://i.imgur.com/IcVqiOb.png" ] []
            , div [ id "container-flower-text" ] introText
            ]
        , div [ id "container-thumbnails" ] (List.map (makeThumbnail model.selectedImage) model.gallery)
        , div
            [ id "container-selected"
            , style "background" ("url(" ++ model.selectedImage ++ ") no-repeat center")
            ]
            []
        , div
            [ id "container-comments" ]
            (List.map genComment model.comments)
        , div
            [ id "container-map" ]
            [ div [ id "map" ] [] ]
        ]


update msg model =
    case msg.desc of
        "image-selected" ->
            { model | selectedImage = msg.data }

        "comment-clicked" ->
            { model | selectedImage = msg.data }

        _ ->
            model


main =
    Browser.sandbox
        { init = initialModel
        , view = view
        , update = update
        }
