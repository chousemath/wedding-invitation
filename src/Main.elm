module Main exposing (main)

import Array exposing (Array)
import Browser
import Css exposing (..)
import Debug exposing (log)
import Html
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (class, css, href, id, src, style)
import Html.Styled.Events exposing (onClick)
import Http
import Json.Decode exposing (Decoder, int, list, string, succeed)
import Json.Decode.Pipeline exposing (optional, required)



-- custom types and type aliases go here


type Status
    = Loading
    | Loaded ( List String, Comments )
    | Errored String


type SocialMedia
    = KakaoStory
    | Facebook
    | Twitter
    | GooglePlus
    | Instagram
    | LinkedIn


type Msg
    = CommentSelected Comment
    | ImageSelected String
    | Social SocialMedia
    | SocialSelected String
    | GotPhotos (Result Http.Error InitialData)


type alias Comment =
    { author : String, createdAt : String, content : String }


type alias Comments =
    List Comment


type alias InitialData =
    { comments : List String
    , photos : List String
    }


type alias Model =
    { status : Status
    , comments : Comments
    , selectedImage : String
    , selectedComment : Comment
    }


type alias SocialPlatform =
    { company : SocialMedia, text : String, icon : String }



-- json decoders go here


initialDataDecoder : Decoder InitialData
initialDataDecoder =
    succeed buildInitialData
        |> required "comments" (list string)
        |> required "photos" (list string)


buildInitialData : List String -> List String -> InitialData
buildInitialData comments photos =
    { comments = comments, photos = photos }



-- default data goes here


socialPlatforms : List SocialPlatform
socialPlatforms =
    [ { company = KakaoStory, text = "kakao story", icon = "./images/KakaoStory.png" }
    , { company = Facebook, text = "facebook", icon = "./images/Facebook.png" }
    , { company = Twitter, text = "twitter", icon = "./images/Twitter.png" }
    , { company = GooglePlus, text = "google plus", icon = "./images/GooglePlus.png" }
    , { company = Instagram, text = "instagram", icon = "./images/Instagram.png" }
    , { company = LinkedIn, text = "linkedin", icon = "./images/LinkedIn.png" }
    ]


emptyComment : Comment
emptyComment =
    { author = ""
    , createdAt = ""
    , content = ""
    }



-- commonly used styles go here


flexCenterX =
    [ displayFlex, justifyContent center, alignItems center ]


flexColX =
    [ displayFlex, flexDirection column, flex (num 1) ]


flexEndX =
    [ displayFlex, flex (num 1), justifyContent flexEnd, alignItems center ]


flexRowX =
    [ displayFlex, flexDirection row ]


flexStartX =
    [ displayFlex, flex (num 1), justifyContent flexStart, alignItems center ]



-- helper functions go here


safeGetStr : Int -> Array String -> String
safeGetStr idx arr =
    case Array.get idx arr of
        Just v ->
            v

        Nothing ->
            ""


extractComment : String -> Comment
extractComment com =
    let
        arr =
            com |> String.split "/////" |> Array.fromList

        author =
            safeGetStr 0 arr

        content =
            safeGetStr 1 arr

        createdAt =
            safeGetStr 2 arr
    in
    { author = author, content = content, createdAt = createdAt }


renderName : String -> Html msg
renderName str =
    div
        [ css
            (flexCenterX
                ++ [ width (pct 100)
                   , height (px 50)
                   , fontSize (px 18)
                   ]
            )
        ]
        [ h4 [] [ text str ] ]


renderNameSpacer : String -> Html msg
renderNameSpacer str =
    div [ css (flexCenterX ++ [ width (pct 100), height (px 30) ]) ] [ h4 [] [ text str ] ]


renderSubtitle : String -> Html msg
renderSubtitle str =
    div
        [ css
            (flexCenterX
                ++ [ width (pct 100)
                   , fontSize (px 12)
                   , height (px 30)
                   ]
            )
        ]
        [ h4 [] [ text str ] ]


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


bucket =
    "https://choi-choi"


region =
    "ap-northeast-2.amazonaws.com/"


genLink : String -> String
genLink fname =
    bucket ++ ".s3." ++ region ++ fname


renderComment : Comment -> Html Msg
renderComment cmt =
    div
        [ css
            (flexColX
                ++ [ marginBottom (px 16)
                   , padding4 (px 0) (px 16) (px 0) (px 16)
                   ]
            )
        , onClick (CommentSelected cmt)
        ]
        [ div [ css (flexRowX ++ [ marginBottom (px 8) ]) ]
            [ div
                [ css flexStartX ]
                [ span
                    [ css
                        [ whiteSpace noWrap
                        , textOverflow ellipsis
                        , fontWeight bold
                        , fontSize (px 18)
                        ]
                    ]
                    [ text cmt.author ]
                ]
            , div
                [ css flexStartX ]
                [ span [ css [ fontWeight lighter, fontSize (px 14), color (hex "bbded6") ] ] [ text cmt.createdAt ] ]
            , div
                [ css (flexEndX ++ [ width (px 30) ]) ]
                [ img [ src "./images/close.png", css [ width (px 25), height (px 25) ] ] [] ]
            ]
        , div
            [ css [ fontSize (px 14) ] ]
            [ text cmt.content ]
        ]


makeThumbnail : String -> Html Msg
makeThumbnail link =
    div
        [ css
            [ width (vw 31)
            , height (vw 31)
            , float left
            , marginBottom (vw 2)
            , marginLeft (vw 2)
            , backgroundImage (url link)
            , backgroundPosition center
            , backgroundRepeat noRepeat
            ]
        , onClick (ImageSelected link)
        ]
        []


defaultComments : List Comment
defaultComments =
    [ { author = "Mom", createdAt = "2020-01-15", content = "Hi I am a mom" }
    , { author = "Dad", createdAt = "2020-01-15", content = "Hi I am a dad" }
    ]


displayComment : Comment -> List (Html Msg)
displayComment c =
    if c.author /= "" then
        [ div [ css [ width (pct 100) ], onClick (CommentSelected emptyComment) ] [ text c.author ] ]

    else
        []


displaySocial : SocialPlatform -> Html Msg
displaySocial s =
    div
        [ class "cont-social" ]
        [ text s.text ]


viewLoaded : List String -> List (Html Msg)
viewLoaded gallery =
    [ div
        [ css [ marginTop (px 16) ] ]
        (List.map makeThumbnail gallery)
    ]


displayOpt : String -> SocialPlatform -> Html Msg
displayOpt url social =
    div
        [ css (flexCenterX ++ [ flex (num 1) ]), onClick (SocialSelected url) ]
        [ img [ src social.icon, css [ width (px 30), height (px 30) ] ] [] ]


displaySelectedImage : String -> Html Msg
displaySelectedImage url =
    if url == "" then
        div [] []

    else
        div
            [ css
                (flexColX
                    ++ [ width (pct 100)
                       , height (vh 100)
                       , position fixed
                       , top (px 0)
                       , left (px 0)
                       ]
                )
            , style "background" ("url(" ++ url ++ ") no-repeat center")
            ]
            [ div
                [ css
                    [ displayFlex
                    , justifyContent flexEnd
                    , alignItems center
                    , width (pct 100)
                    , height (px 50)
                    ]
                ]
                [ div
                    [ css
                        (flexCenterX
                            ++ [ marginTop (px 16)
                               , marginRight (px 8)
                               , width (px 50)
                               , height (px 50)
                               , borderRadius (pct 50)
                               , backgroundColor (rgba 241 241 246 0.8)
                               ]
                        )
                    , onClick (ImageSelected "")
                    ]
                    [ img [ src "./images/close.png", css [ width (px 30), height (px 30) ] ] [] ]
                ]
            , div [ css [ flexGrow (num 1) ] ] []
            , div
                [ css
                    (flexRowX
                        ++ [ width (pct 100)
                           , height (px 75)
                           , backgroundColor (rgba 0 0 0 0.8)
                           ]
                    )
                ]
              <|
                List.map (displayOpt url) socialPlatforms
            ]


loader =
    [ div
        [ css (flexCenterX ++ [ width (pct 100) ]) ]
        [ img [ src "./images/loader.gif", css [ maxHeight (px 150) ] ] [] ]
    ]


initialCmd : Cmd Msg
initialCmd =
    Http.get
        { url = "https://raw.githubusercontent.com/chousemath/wedding-invitation/master/response.json"
        , expect = Http.expectJson GotPhotos initialDataDecoder
        }


initialModel : Model
initialModel =
    { status = Loading
    , comments = defaultComments
    , selectedComment = emptyComment
    , selectedImage = ""
    }


renderGallery : Status -> List (Html Msg)
renderGallery status =
    case status of
        Loaded ( gallery, _ ) ->
            viewLoaded gallery

        Loading ->
            loader

        Errored err ->
            [ div [] [ text err ] ]


renderComments : Status -> List (Html Msg)
renderComments status =
    case status of
        Loaded ( _, comments ) ->
            List.map renderComment comments

        Loading ->
            loader

        Errored err ->
            [ div [] [ text err ] ]


view : Model -> Html Msg
view model =
    div
        [ css
            [ width (vw 100)
            , height (vh 100)
            ]
        ]
        [ div
            [ css
                [ width (pct 100)
                , position relative
                , textAlign center
                , backgroundColor (hex "EADEC8")
                , padding4 (px 16) (px 0) (px 16) (px 0)
                ]
            ]
            [ img
                [ css [ width (calc (pct 100) minus (px 32)) ]
                , src "https://i.imgur.com/IcVqiOb.png"
                ]
                []
            , div
                [ css
                    [ position absolute
                    , top (pct 50)
                    , left (pct 50)
                    , transform (translate2 (pct -50) (pct -50))
                    , width (pct 100)
                    ]
                ]
                introText
            ]
        , div [ css [ width (pct 100), float left ] ] <| renderGallery model.status
        , displaySelectedImage model.selectedImage
        , div [ css (flexColX ++ [ width (pct 100), float left ]) ] <| renderComments model.status
        , div [ css [ padding (px 16) ] ] <| displayComment model.selectedComment
        , div
            [ css (flexCenterX ++ [ height (px 300), padding (px 16), overflow hidden ]) ]
            [ div [ id "map", css [ width (pct 100), height (px 400) ] ] [] ]
        , div [ id "cont-socials" ] <| List.map displaySocial socialPlatforms
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ImageSelected url ->
            ( { model | selectedImage = url }
            , Cmd.none
            )

        CommentSelected c ->
            ( { model | selectedComment = c }
            , Cmd.none
            )

        Social platform ->
            ( model
            , Cmd.none
            )

        SocialSelected url ->
            ( model, Cmd.none )

        GotPhotos (Ok initialData) ->
            let
                comments =
                    List.map extractComment initialData.comments

                photos =
                    List.map genLink initialData.photos
            in
            ( { model | status = Loaded ( photos, comments ) }, Cmd.none )

        GotPhotos (Err httpError) ->
            ( { model | status = Errored "Internal Server Error" }, Cmd.none )


main : Program () Model Msg
main =
    Browser.element
        { init = \flags -> ( initialModel, initialCmd )
        , view = view >> toUnstyled
        , update = update
        , subscriptions = \model -> Sub.none
        }
