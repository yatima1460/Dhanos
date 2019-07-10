module Dhanos;

import DhanosInterface : DhanosInterface;

DhanosInterface getNewPlatformInstance(immutable(string) title,
        immutable(string) url, int width, int height, bool resizable)
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
    d.init(title, url, width, height, resizable);
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
