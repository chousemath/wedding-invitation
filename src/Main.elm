module Main exposing (main)

import Array exposing (Array)
import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Http
import Json.Decode exposing (Decoder, int, list, string, succeed)
import Json.Decode.Pipeline exposing (optional, required)



-- custom types and type aliases go here


type Status
    = Loading
    | Loaded (List String)
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
    | GotPhotos (Result Http.Error String)


type alias Comment =
    { author : String, createdAt : String, content : String }


type alias Comments =
    List Comment


type alias InitialData =
    { comments : List String
    , images : List String
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
        |> required "images" (list string)


buildInitialData : List String -> List String -> InitialData
buildInitialData comments images =
    { comments = comments, images = images }



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



-- helper functions go here


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


genLink : String -> String
genLink fname =
    let
        bucket =
            "choi-choi"

        region =
            "ap-northeast-2"
    in
    "https://" ++ bucket ++ ".s3." ++ region ++ ".amazonaws.com/" ++ fname


genComment : Comment -> Html Msg
genComment comment =
    div
        [ class "container-comment", onClick (CommentSelected comment) ]
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
        [ div [ id "selected-comment-content", onClick (CommentSelected emptyComment) ] [ text c.author ] ]

    else
        []


displaySocial : SocialPlatform -> Html Msg
displaySocial s =
    div
        [ class "container-social" ]
        [ text s.text ]


viewLoaded : List String -> List (Html Msg)
viewLoaded gallery =
    [ div
        [ id "container-thumbnails" ]
        (List.map (makeThumbnail "") gallery)
    ]


displaySelectedImage : String -> Html Msg
displaySelectedImage url =
    if url == "" then
        div [] []

    else
        div
            [ id "container-selected"
            , style "background" ("url(" ++ url ++ ") no-repeat center")
            , onClick (ImageSelected "")
            ]
            []


loader =
    [ div
        [ class "container-loader" ]
        [ img [ src "./images/loader.gif", class "loader" ] [] ]
    ]


initialCmd : Cmd Msg
initialCmd =
    Http.get
        { url = "https://raw.githubusercontent.com/chousemath/wedding-invitation/master/test-images.txt"
        , expect = Http.expectString GotPhotos
        }


initialModel : Model
initialModel =
    { status = Loading
    , comments = defaultComments
    , selectedComment = emptyComment
    , selectedImage = ""
    }


view : Model -> Html Msg
view model =
    div [ id "container-main" ]
        [ div
            [ id "container-flower" ]
            [ img [ id "flower-border", src "https://i.imgur.com/IcVqiOb.png" ] []
            , div [ id "container-flower-text" ] introText
            ]
        , div [ class "container-loaded" ] <|
            case model.status of
                Loaded gallery ->
                    viewLoaded gallery

                Loading ->
                    loader

                Errored err ->
                    [ div [] [ text err ] ]
        , displaySelectedImage model.selectedImage
        , div
            [ id "container-comments" ]
          <|
            List.map genComment model.comments
        , div
            [ id "container-selected-comment" ]
          <|
            displayComment model.selectedComment
        , div
            [ id "container-map" ]
            [ div [ id "map" ] [] ]
        , div
            [ id "container-socials" ]
          <|
            List.map displaySocial socialPlatforms
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

        GotPhotos (Ok responseStr) ->
            let
                urls =
                    String.split "," responseStr

                photos =
                    List.map genLink urls
            in
            ( { model | status = Loaded photos }, Cmd.none )

        GotPhotos (Err httpError) ->
            ( { model | status = Errored "Internal Server Error" }, Cmd.none )


main : Program () Model Msg
main =
    Browser.element
        { init = \flags -> ( initialModel, initialCmd )
        , view = view
        , update = update
        , subscriptions = \model -> Sub.none
        }
