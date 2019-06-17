module Examples.Minimal;

import std.path : dirName, buildNormalizedPath, absolutePath, buildPath;
import Dhanos : Dhanos;

int main(string[] args)
{
    immutable(string) title = "Minimal Dhanos example";
    immutable(string) dhanos_project_path = dirName(dirName(
            dirName(dirName(dirName(absolutePath(buildNormalizedPath(args[0])))))));
    immutable(string) url = buildPath("file:" ~ dhanos_project_path ~ "/LICENSE");
    immutable int width = 800;
    immutable int height = 450;
    immutable bool resizable = true;
    Dhanos d = new Dhanos(title, url, width, height, resizable);
    d.mainLoop();
    return 0;
}
