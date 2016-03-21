import XMonad
import XMonad.Actions.WorkspaceNames -- workspaceNamesPP
import XMonad.Actions.Promote


import XMonad.Hooks.SetWMName
import XMonad.Hooks.EwmhDesktops

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks

import XMonad.Layout.Accordion
import XMonad.Layout.Fullscreen
import XMonad.Layout.NoBorders
import XMonad.Layout.Spiral
import XMonad.Layout.Tabbed
import XMonad.Layout.Circle
import XMonad.Layout.Grid
import XMonad.Layout.ThreeColumns
import XMonad.Layout.Mosaic
import XMonad.Layout.Drawer -- ClassName Selector
import XMonad.Layout.Renamed

import qualified XMonad.StackSet as W
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig
import System.IO
import System.Exit

ctrlMask = controlMask
altMask = mod1Mask

--
-- Set up how things look
--

-- Fonts
monospaceFontFace  = "Ubuntu Mono"
monospaceFontSize = 12
monospaceFont = monospaceFontFace ++ "-" ++ show monospaceFontSize
normalFontFace = "Ubuntu Sans"
normalFontSize = 11
normalFont = normalFontFace ++ "-" ++ show normalFontSize

-- Common Colors
orange   = "#dd4814"   -- Ubuntu orange
darkgrey = "#3c3b37"   -- Ambiance background grey

--
-- Window Selectors
--

-- Window Selectors (Generic)
selectMusic     = selectSpotify
selectTerminal  = selectXTerm

-- Window Selectors (Specific)
selectSpotify, selectXTerm, selectSteamFriends :: Property
selectSpotify      = ClassName "Spotify" `Or` ClassName "spotify"
selectXTerm        = ClassName "xxterm" `Or` ClassName "UXTerm"
selectIrssi        = selectTerminal `And` Title "irssi"

--
-- Define printers for xmobar
--

-- Printer for statusbar (xmobar) windowing information
titlePP = xmobarPP
    { ppTitle = shorten 100
    , ppOrder = \(_:_:t:_) -> [t]
    , ppSep = ""
    }

-- Printer for statusbar (xmobar) windowing information
workspacePP = xmobarPP
    { -- Highlight current workspace in orange
      ppCurrent = xmobarColor orange "" . wrap "" ""
    , ppUrgent = xmobarColor "white" orange . xmobarStrip
    , ppOrder = \(ws:_:_:_) -> [ws]
    , ppSep = ""
    , ppWsSep = "   "
    }

-- Printer for statusbar (xmobar) windowing information
layoutPP = xmobarPP
    { ppOrder = \(_:lt:_:_) -> [lt]
    , ppSep = ""
    }

myManageHook = manageDocks <+> manageHook myConfig

--
-- Custom layouts
--

defaultLayouts    = layoutHook defaultConfig

-- "Tall" with a half width master
standardLayout    = renamed [Replace "Standard"] $ Tall 1 (3/100) (1/2)

-- Fullscreen
fullLayout        = renamed [Replace "Fullscreen"] $ Full

-- Vertical accordion of windows
vAccordionLayout  = renamed [Replace "Vertical Accordion"] $ Accordion
hAccordionLayout  = renamed [Replace "Horizontal Accordion"] $ Mirror Accordion

-- Grid
gridLayout = Grid

-- Drawer with windows stacked vertically
myDrawer prop = drawer 0.01 0.4 prop $ vAccordionLayout
drawerLayout prop layout = renamed [CutWordsLeft 2] $ myDrawer prop `onRight` layout

-- For now, just avoidStruts (Show top + Bottom bars)
-- myLayout = avoidStruts $ layoutHook defaultConfig
myLayout = standardLayout ||| ThreeCol 1 (3/100) (1/2) ||| fullLayout ||| gridLayout ||| mosaic 2 [3,2] ||| vAccordionLayout ||| hAccordionLayout

--
-- Set up any custom config
--
myConfig = defaultConfig
    {
        -- Use Windows key, not Alt as mod key
        modMask = mod4Mask

        , terminal = "uxterm"
        , layoutHook = smartBorders $ myLayout
    }

myWorkspaces = map show [1..12]

myBindings =
    [ ("M-<Return>"     , spawn "uxterm")
    , ("M-S-<Return>"   , spawn "google-chrome-stable --ssl-version-min=tls1")
    , ("M-S-q"          , kill)
    , ("M-S-<Space>"    , promote)
    , ("C-M1-q"         , io (exitWith ExitSuccess)) -- Ctrl + Alt + q = Quit xmonad
    , ("C-S-l"          , spawn "dm-tool lock") -- Ctrl + Alt + L = Lock screen
    , ("M-p"            , spawn "dmenu_run")
    , ("M-,"            , sendMessage (IncMasterN 1))
    , ("M-."            , sendMessage (IncMasterN (-1)))
    , ("C-S-M1-q"       , restart "xmonad" True) -- Ctrl + Shift + Alt + q = Reload xmonad
    , ("<XF86AudioMute>"  , spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle; amixer -q -c PCH sset Headphone 100 unmute")
    , ("<XF86AudioRaiseVolume>"  , spawn "pactl set-sink-volume @DEFAULT_SINK@ '+2%'")
    , ("<XF86AudioLowerVolume>"  , spawn "pactl set-sink-volume @DEFAULT_SINK@ '-2%'")
    , ("<XF86AudioPlay>"  , spawn "playerctl play-pause")
    , ("<XF86Launch9>"  , spawn "playerctl next")
    , ("<XF86Launch8>"  , spawn "playerctl previous")
    , ("<XF86HomePage>"  , spawn "bash /home/michael/.screenlayout/work-desk.sh")
    , ("<XF86Mail>"  , spawn "bash /home/michael/.screenlayout/laptop-only.sh")

    ]
    -- Make F-keys switch workspaces too
    ++
    [ (otherModMasks ++ "M-" ++ key, action tag)
        | (tag, key)  <- zip myWorkspaces (map (\x -> "<F" ++ x ++ ">") myWorkspaces)
        , (otherModMasks, action) <- [ ("", windows . W.view) -- or W.greedyView
                                     , ("S-", windows . W.shift)]
    ]
    -- Make Mod+<num> behave the same as the F-keys
    ++
    [ (otherModMasks ++ "M-" ++ [key], action tag)
      | (tag, key)  <- zip myWorkspaces "123456789"
      , (otherModMasks, action) <- [ ("", windows . W.view)
                                      , ("S-", windows . W.shift)]
    ]


myStartupHook = setWMName "LG3D"

--
-- Actually run xmonad
--
main = do

    -- Run xmobar and set printers
    workspaceBar <- spawnPipe "xmobar ~/.xmonad/xmobar/bottom-right.xmobarrc"
    let wsPP = workspacePP { ppOutput = hPutStrLn workspaceBar }
    layoutBar <- spawnPipe "xmobar ~/.xmonad/xmobar/bottom-left.xmobarrc"
    let lytPP = layoutPP { ppOutput = hPutStrLn layoutBar }

    xmonad $ ewmh myConfig
        {
        -- Allow top and bottom bars
        manageHook = myManageHook
        , workspaces = myWorkspaces
        , layoutHook = avoidStruts $ layoutHook myConfig
        -- Set up xmobar
        , logHook = workspaceNamesPP wsPP >>= -- Display workspace names
                        dynamicLogWithPP >>
                        dynamicLogWithPP lytPP >>
                        logHook myConfig
        , startupHook = myStartupHook
        , handleEventHook = ewmhDesktopsEventHook

        -- Set up additional bindings
        } `additionalKeysP` myBindings

