module Examples.Minimal;

import std.path : dirName, buildNormalizedPath, absolutePath, buildPath;
import DhanosInterface : DhanosInterface;
import Dhanos : getNewPlatformInstance;

int main(string[] args)
{
    immutable(string) dhanos_project_path = dirName(dirName(
            dirName(dirName(dirName(absolutePath(buildNormalizedPath(args[0])))))));

    
    DhanosInterface d = getNewPlatformInstance("Minimal Dhanos example",
                            buildPath("file:" ~ dhanos_project_path ~ "/LICENSE"),
                            800,450,
                            true);
    d.mainLoop();
    return 0;
}
