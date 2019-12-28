module Main exposing (main)

import Html exposing (..)
import Html.Attributes exposing (..)


renderName str =
    div [ class "name" ] [ h4 [] [ text str ] ]


renderNameSpacer str =
    div [ id "name-spacer" ] [ h4 [] [ text str ] ]


renderSubtitle str =
    div [ class "subtitle" ] [ h4 [] [ text str ] ]


view model =
    div [ id "container-main" ]
        [ div
            [ id "container-flower" ]
            [ img [ id "flower-border", src "https://i.imgur.com/IcVqiOb.png" ] []
            , div
                [ id "container-flower-text" ]
                (renderName "최성필"
                    :: renderNameSpacer "그리고"
                    :: renderName "최수강"
                    :: List.map
                        renderSubtitle
                        [ "2020.04.19 SUN AM 11:00"
                        , "서울특별시 종로구 종로1길 50 (중학동)"
                        , "더케이트윈타워 A동 LL층 (지하2층)"
                        ]
                )
            ]
        , div [ id "container-thumbnails" ] (List.map makeThumbnail model.gallery)
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


assembleLink fname =
    let
        bucket =
            "choi-choi"

        region =
            "ap-northeast-2"
    in
    "https://" ++ bucket ++ ".s3." ++ region ++ ".amazonaws.com/" ++ fname


makeThumbnail link =
    div
        [ class "thumbnail"
        , style "background" ("url(" ++ link ++ ") no-repeat center")
        ]
        []


initialModel =
    { gallery = List.map assembleLink galleryImages
    }


main =
    view initialModel
