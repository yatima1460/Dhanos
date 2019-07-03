module Dhanos;

import DhanosInterface : DhanosInterface;

DhanosInterface getNewPlatformInstance(immutable(string) title, immutable(string) url, int width, int height, bool resizable)
{
    DhanosInterface d;
    version(Windows)
    {
        import Dhanos_Windows : Dhanos_Windows;
        d = cast(DhanosInterface)new Dhanos_Windows();
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
    return 1;
}