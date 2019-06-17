module Examples.Minimal;

import std.path : dirName, buildNormalizedPath, absolutePath, buildPath;
import Dhanos : Dhanos;

int main(string[] args)
{
    immutable(string) title = "Borderless Window";
    immutable(string) dhanos_project_path = dirName(dirName(dirName(absolutePath(buildNormalizedPath(args[0])))));
    immutable(string) url = buildPath("file:" ~ dhanos_project_path ~ "/index.html");
    immutable int width = 800;
    immutable int height = 450;
    immutable bool resizable = false;
    Dhanos d = new Dhanos(title, url, width, height, resizable);
    d.setBorder(false);
    d.mainLoop();
    return 0;
}
