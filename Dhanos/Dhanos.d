module Dhanos;

import DhanosInterface : DhanosInterface;


DhanosInterface getNewPlatformInstance(in immutable(string) title,in  immutable(string) url,in  int width,in  int height,in  bool resizable, void function(DhanosInterface) loadFinished)
in (title !is null)
in (title.length > 0)
in (url !is null)
in (url.length > 0)
in (width > 0)
in (height > 0)
{
    import std.stdio;

    DhanosInterface d = null;
    version (Windows)
    {
        import Dhanos_Windows : Dhanos_Windows;
        d = cast(DhanosInterface) new Dhanos_Windows();
    }
    version (linux)
    {
        import Dhanos_Linux : Dhanos_Linux;
        auto d_l = new Dhanos_Linux();
        d = cast(DhanosInterface) d_l;
    }
    version (OSX)
    {
        import Dhanos_OSX : Dhanos_OSX;
        d = cast(DhanosInterface) new Dhanos_OSX();
    }
    if (d is null)
    {
        throw new Exception("Your platform is still not supported!");
    }
    d.init(title, url, width, height, resizable,loadFinished);
    return d;
}

version (Windows)
{
    // Windows requires a main in a library????
    int main()
    {
        return 1;
    }
}
