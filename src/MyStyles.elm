module MyStyles exposing (..)

import Css exposing (..)


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


sty =
    { contName = flexCenterX ++ [ height (px 40), fontSize (px 36) ]
    , flexGrowX = [ displayFlex, flexGrow (num 1) ]
    , contNameSpacer = flexCenterX ++ [ fontSize (px 12), margin2 (px 0) (px 16) ]
    , contNames = flexRowX ++ [ width (calc (vw 100) minus (px 64)), paddingLeft (px 32) ]
    , contSubtitle = flexCenterX ++ [ width (pct 100), fontSize (px 16), height (px 30) ]
    , contComment = flexColX ++ [ marginBottom (px 16), padding4 (px 0) (px 16) (px 0) (px 16) ]
    , commentInner = flexRowX ++ [ marginBottom (px 8) ]
    , flexStart = flexStartX
    , textAuthor =
        [ whiteSpace noWrap
        , textOverflow ellipsis
        , fontWeight bold
        , fontSize (px 18)
        ]
    , contClose = flexEndX ++ [ width (px 30) ]
    , contAuthor = [ fontWeight lighter, fontSize (px 14), color (hex "bbded6") ]
    , iconClose = [ width (px 25), height (px 25) ]
    , textContent = [ fontSize (px 14) ]
    , thumbnail =
        [ width (vw 31)
        , height (vw 31)
        , float left
        , marginBottom (vw 2)
        , marginLeft (vw 2)
        , backgroundPosition center
        , backgroundRepeat noRepeat
        ]
    , displayComment = [ width (pct 100) ]
    , contSocial = [ width (pct 100) ]
    , contLoaded = [ marginTop (px 16) ]
    , contOpt = flexCenterX ++ [ flex (num 1) ]
    , iconSocial = [ width (px 30), height (px 30) ]
    , contSelectedImage =
        flexColX
            ++ [ width (pct 100)
               , height (vh 100)
               , position fixed
               , top (px 0)
               , left (px 0)
               , backgroundPosition center
               , backgroundRepeat noRepeat
               ]
    , contOverlay =
        [ displayFlex
        , justifyContent flexEnd
        , alignItems center
        , width (pct 100)
        , height (px 50)
        ]
    , contOverlayClose =
        flexCenterX
            ++ [ marginTop (px 16)
               , marginRight (px 8)
               , width (px 50)
               , height (px 50)
               , borderRadius (pct 50)
               , backgroundColor (rgba 241 241 246 0.8)
               ]
    , iconCloseOverlay = [ width (px 30), height (px 30) ]
    , fgrow = [ flexGrow (num 1) ]
    , contSocialOverlay = flexRowX ++ [ width (pct 100), height (px 75), backgroundColor (rgba 0 0 0 0.8) ]
    , contLoader = flexCenterX ++ [ width (pct 100) ]
    , iconLoader = [ maxHeight (px 150) ]
    , contMain = [ width (vw 100), height (vh 100) ]
    , contFlower =
        [ width (pct 100)
        , height (vh 100)
        , position relative
        , textAlign center
        , backgroundColor (hex "#729FB2")
        , backgroundImage (url "./images/bg2.jpg")
        , backgroundPosition center
        , backgroundRepeat noRepeat
        ]
    , contFlowerImage = [ width (calc (pct 100) minus (px 32)) ]
    , contFlowerText = flexColX ++ [ width (pct 100) ]
    , contGallery = [ width (vw 100), height (vh 100), float left ]
    , contComments = flexColX ++ [ width (pct 100), float left ]
    , contSelectedComment = [ padding (px 16) ]
    , contMap = flexCenterX ++ [ height (vh 40), overflow hidden ]
    , sectionMap = flexColX ++ [ width (vw 100), height (vh 100) ]
    , map = [ width (pct 100), height (px 400) ]
    , contProgress = flexCenterX ++ [ width (vw 100), height (vh 20), backgroundColor (hex "f6eec7") ]
    , contOptions = flexStartX ++ [ width (vw 100), paddingLeft (px 16) ]
    , boxOptions = flexStartX ++ [ width (px 50), height (px 50) ]
    , fontImg = [ width (px 20), height (px 20) ]
    , contSidebar =
        flexColX
            ++ [ width (vw 75)
               , height (vh 100)
               , backgroundColor (rgba 255 255 255 0.9)
               , position fixed
               , top (vw 0)
               ]
    , contSideOpt =
        [ width (pct 100)
        , height (px 50)
        , paddingLeft (px 16)
        , displayFlex
        , justifyContent flexStart
        , alignItems center
        ]
    }
