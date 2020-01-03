module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)


renderName str =
    div [ class "name" ] [ h4 [] [ text str ] ]


renderNameSpacer str =
    div [ id "name-spacer" ] [ h4 [] [ text str ] ]


renderSubtitle str =
    div [ class "subtitle" ] [ h4 [] [ text str ] ]


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


genLink fname =
    let
        bucket =
            "choi-choi"

        region =
            "ap-northeast-2"
    in
    "https://" ++ bucket ++ ".s3." ++ region ++ ".amazonaws.com/" ++ fname


genComment comment =
    div
        [ class "container-comment" ]
        [ div [ class "container-comment-top" ]
            [ div [ class "container-comment-author" ] [ text comment.author ]
            , div [ class "container-comment-created-at" ] [ text comment.createdAt ]
            ]
        , div
            [ class "container-comment-btm" ]
            [ comment.content ]
        ]


makeThumbnail link =
    div
        [ class "thumbnail"
        , style "background" ("url(" ++ link ++ ") no-repeat center")
        , onClick { desc = "image-selected", data = link }
        ]
        []


defaultComments =
    [ { author = "Mom", createdAt = "2020-01-15", content = "Hi I am a mom" }
    , { author = "Dad", createdAt = "2020-01-15", content = "Hi I am a dad" }
    ]


links =
    List.map genLink galleryImages


initialModel =
    { gallery = links
    , selectedImage =
        case List.head links of
            Nothing ->
                ""

            Just val ->
                val
    }


view model =
    div [ id "container-main" ]
        [ div
            [ id "container-flower" ]
            [ img [ id "flower-border", src "https://i.imgur.com/IcVqiOb.png" ] []
            , div [ id "container-flower-text" ] introText
            ]
        , div [ id "container-thumbnails" ] (List.map makeThumbnail model.gallery)
        , div
            [ id "container-selected"
            , style "background" ("url(" ++ model.selectedImage ++ ") no-repeat center")
            ]
            []
        ]


update msg model =
    case msg.desc of
        "image-selected" ->
            { model | selectedImage = msg.data }

        _ ->
            model


main =
    Browser.sandbox
        { init = initialModel
        , view = view
        , update = update
        }
