module Examples.Minimal;

import std.path : dirName, buildNormalizedPath, absolutePath, buildPath;
import Dhanos : Dhanos;

int main(string[] args)
{
    import std.stdio : writeln;
    immutable(string) title = "Minimal Dhanos example";
    immutable(string) dhanos_project_path = dirName(dirName(dirName(absolutePath(buildNormalizedPath(args[0])))));
    immutable(string) url = buildPath("file:"~dhanos_project_path~"/LICENSE");
    writeln("file:///"~dhanos_project_path~"/LICENSE");
    int width = 800;
    int height = 450;
    bool resizable = true;
    return Dhanos.launch(title,url, width, height, resizable);
}