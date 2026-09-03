import XMonad

import XMonad.Util.EZConfig
import XMonad.Util.SpawnOnce (spawnOnce)
import XMonad.Util.Cursor (setDefaultCursor)
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
import XMonad.Actions.GridSelect
import qualified XMonad.StackSet as W

-- Warning to others: If you have monitors plugged into DP-1 and DP-2 this can mess them up. Change if needed!
fixMonitors :: X ()
fixMonitors = do
    spawnOnce "xrandr --output DP-2 --mode 1920x1080 --rate 165 --output DP-1 --mode 1920x1080 --rate 240 --right-of DP-2 --primary"

main :: IO ()
main = xmonad $ ewmh def
    { modMask = mod4Mask -- Rebind Mod to Super
    , focusFollowsMouse = False
    , startupHook = fixMonitors >> setDefaultCursor xC_left_ptr
    , layoutHook = myLayout
    } `additionalKeysP`
    [ ("M-<Delete>", spawn "xscreensaver-command -lock")
    , ("<XF86AudioRaiseVolume>", spawn "wpctl set-volume @DEFAULT_SINK@ 5%+")
    , ("<XF86AudioLowerVolume>", spawn "wpctl set-volume @DEFAULT_SINK@ 5%-")
    , ("<XF86AudioMute>", spawn "wpctl set-mute @DEFAULT_SINK@ toggle")
    , ("M-q",        kill)
    , ("M-<F12>",    spawn "if type xmonad; then xmonad --recompile && xmonad --restart; else xmessage xmonad not in \\$PATH: \"$PATH\"; fi")
    , ("M-t",        spawn "ghostty")
    , ("M-d",        spawn "rofi -show drun")
    , ("M-p",        unGrab *> spawn "scrot -s '/home/theo/Screenshots/%m-%d-%T-ss.png'")
    , ("M-b",        spawn "firefox")
    , ("M-g",        goToSelected def)
    , ("M-S-t",      withFocused $ windows . W.sink)
    , ("M-w",        screenWorkspace 1 >>= flip whenJust (windows . W.view))
    , ("M-e",        screenWorkspace 0 >>= flip whenJust (windows . W.view))
    , ("M-S-w",      screenWorkspace 1 >>= flip whenJust (windows . W.shift))
    , ("M-S-e",      screenWorkspace 0 >>= flip whenJust (windows . W.shift))
    ]


myWorkspaces :: [String]
myWorkspaces = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]

myLayout = lessBorders (Combine Union Screen OnlyFloat) (tiled ||| Mirror tiled ||| Full)
    where
        tiled   = smartSpacing 5 $ Tall nmaster delta ratio
        nmaster = 1
        ratio   = 1/2
        delta   = 3/100
