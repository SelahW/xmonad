import XMonad

import XMonad.Util.EZConfig
import XMonad.Operations
import XMonad.Layout.Tabbed
import XMonad.Actions.PhysicalScreens
import XMonad.Layout.Spacing
import XMonad.Layout.Magnifier
import XMonad.Hooks.EwmhDesktops
import XMonad.Layout.NoBorders
import Graphics.X11.ExtraTypes.XF86
import XMonad.Hooks.ManageDocks (avoidStruts)
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP

main :: IO ()
main = xmonad $ ewmh def
    { modMask = mod4Mask -- Rebind Mod to Super
    , layoutHook = myLayout
    } `additionalKeysP`
    [ ("M-<Delete>", spawn "xscreensaver-command -lock")
    , ("<XF86AudioRaiseVolume>", spawn "wpctl set-volume @DEFAULT_SINK@ 5%+")
    , ("<XF86AudioLowerVolume>", spawn "wpctl set-volume @DEFAULT_SINK@ 5%-")
    , ("<XF86AudioMute>", spawn "wpctl set-mute @DEFAULT_SINK@ toggle")
    , ("M-q",        kill)
    , ("M-<F12>",    spawn "if type xmonad; then xmonad --recompile && xmonad --restart; else xmessage xmonad not in \\$PATH: \"$PATH\"; fi")
    , ("M-t",        spawn "ghostty")
    , ("M-d",        spawn "rofi -show combi -modes combi -combi-modes window#drun")
    , ("M-p",        unGrab *> spawn "scrot -s")
    , ("M-b",        spawn "firefox")
    ]

myWorkspaces :: [String]
myWorkspaces = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]

myLayout = lessBorders (Combine Union Screen OnlyFloat) (tiled ||| Mirror tiled ||| Full)
    where
        tiled   = smartSpacing 5 $ Tall nmaster delta ratio
        nmaster = 1
        ratio   = 1/2
        delta   = 3/100
