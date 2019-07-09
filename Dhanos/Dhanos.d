module Dhanos;

import DhanosInterface : DhanosInterface;

DhanosInterface getNewPlatformInstance(immutable(string) title, immutable(string) url, int width, int height, bool resizable)
{
    import std.stdio;
    writeln("owo");
    DhanosInterface d = null;
    version(Windows)
    {
        writeln("w");
        import Dhanos_Windows : Dhanos_Windows;
        d = cast(DhanosInterface)new Dhanos_Windows();
    }
    version(linux)
    {
        writeln("l");
        import Dhanos_Linux : Dhanos_Linux;
        auto d_l = new Dhanos_Linux();
        writeln(d_l);
        d = cast(DhanosInterface)d_l;
        writeln(d);
    }
    version(OSX)
    {
        writeln("o");
        import Dhanos_OSX : Dhanos_OSX;
        d = cast(DhanosInterface)new Dhanos_OSX();
    }
    if (d is null)
    {
        throw new Exception("Your platform is still not supported!");
    }
    d.init(title,url,width,height,resizable);
    return d;
}


int main()
{
    return 999;
}