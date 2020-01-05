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
import MyStyles exposing (myStyles)



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
        [ css myStyles.contName ]
        [ h4 [] [ text str ] ]


renderNameSpacer : String -> Html msg
renderNameSpacer str =
    div
        [ css myStyles.contNameSpacer ]
        [ h4 [] [ text str ] ]


renderSubtitle : String -> Html msg
renderSubtitle str =
    div
        [ css myStyles.contSubtitle ]
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
        [ css myStyles.contComment, onClick (CommentSelected cmt) ]
        [ div
            [ css myStyles.commentInner ]
            [ div
                [ css myStyles.flexStart ]
                [ span [ css myStyles.textAuthor ] [ text cmt.author ]
                ]
            , div
                [ css myStyles.flexStart ]
                [ span [ css myStyles.contAuthor ] [ text cmt.createdAt ] ]
            , div
                [ css myStyles.contClose ]
                [ img [ src "./images/close.png", css myStyles.iconClose ] [] ]
            ]
        , div [ css myStyles.textContent ] [ text cmt.content ]
        ]


makeThumbnail : String -> Html Msg
makeThumbnail link =
    div
        [ css (backgroundImage (url link) :: myStyles.thumbnail)
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
        [ div [ css myStyles.displayComment, onClick (CommentSelected emptyComment) ] [ text c.author ] ]

    else
        []


displaySocial : SocialPlatform -> Html Msg
displaySocial s =
    div [ css myStyles.contSocial ] [ text s.text ]


viewLoaded : List String -> List (Html Msg)
viewLoaded gallery =
    [ div [ css myStyles.contLoaded ] (List.map makeThumbnail gallery) ]


displayOpt : String -> SocialPlatform -> Html Msg
displayOpt url social =
    div
        [ css myStyles.contOpt, onClick (SocialSelected url) ]
        [ img [ src social.icon, css myStyles.iconSocial ] [] ]


displaySelectedImage : String -> Html Msg
displaySelectedImage link =
    if link == "" then
        div [] []

    else
        div
            [ css (backgroundImage (url link) :: myStyles.contSelectedImage) ]
            [ div
                [ css myStyles.contOverlay ]
                [ div
                    [ css myStyles.contOverlayClose, onClick (ImageSelected "") ]
                    [ img [ src "./images/close.png", css myStyles.iconCloseOverlay ] [] ]
                ]
            , div [ css myStyles.fgrow ] []
            , div [ css myStyles.contSocialOverlay ] <| List.map (displayOpt link) socialPlatforms
            ]


loader =
    [ div
        [ css myStyles.contLoader ]
        [ img [ src "./images/loader.gif", css myStyles.iconLoader ] [] ]
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
        [ css myStyles.contMain ]
        [ div
            [ css myStyles.contFlower ]
            [ img [ css myStyles.contFlowerImage, src "https://i.imgur.com/IcVqiOb.png" ] []
            , div [ css myStyles.contFlowerText ] introText
            ]
        , div [ css myStyles.contGallery ] <| renderGallery model.status
        , displaySelectedImage model.selectedImage
        , div [ css myStyles.contComments ] <| renderComments model.status
        , div [ css myStyles.contSelectedComment ] <| displayComment model.selectedComment
        , div
            [ css myStyles.contMap ]
            [ div [ id "map", css myStyles.map ] [] ]
        , div [] <| List.map displaySocial socialPlatforms
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
