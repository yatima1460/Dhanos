module Examples.Minimal;

import std.path : dirName, buildNormalizedPath, absolutePath, buildPath;


import DhanosInterface : DhanosInterface;
import Dhanos : getNewPlatformInstance;
import std.stdio : writeln;

void callback(immutable(string) value)
{
    writeln("a");
    
}



int main(string[] args)
{
    immutable(string) title = "Borderless Window";
    immutable(string) dhanos_project_path = dirName(dirName(absolutePath(buildNormalizedPath(args[0]))));
    immutable(string) url = buildPath("file:" ~ dhanos_project_path ~ "/index.html");
    immutable int width = 800;
    immutable int height = 250;
    immutable bool resizable = false;
    DhanosInterface d = getNewPlatformInstance(title, url, width, height, resizable);
   
    //d.setBorder(false);
    auto f = &callback;
    //d.setJSCallback(f);
    d.mainLoop();
    return 0;
}
