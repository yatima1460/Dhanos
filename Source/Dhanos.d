module Dhanos;

import std.string : toStringz;

static extern (C) int webview(const char* title, const char* url, int width, int height, int resizable);

class Dhanos
{
    static int launch(immutable(string) title, immutable(string) url, int width, int height, bool resizable)
    {
        return webview(toStringz(title), toStringz(url), width, height, cast(int) resizable);
    }
}
