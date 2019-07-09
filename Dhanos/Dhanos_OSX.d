


     ulong windowStyleMask = cast(ulong) objc_msgSend(data.priv.window,
                    sel_registerName("styleMask"));
            immutable(int) b = (((windowStyleMask & NSWindowStyleMaskFullScreen) == NSWindowStyleMaskFullScreen)
                    ? 1 : 0);
            if (b != fullscreen)
            {
                objc_msgSend(data.priv.window, sel_registerName("toggleFullScreen:"), NULL);
            }