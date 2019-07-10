module DhanosInterface;

interface DhanosInterface
{
    void init(immutable(string) title, immutable(string) url, int width, int height, bool resizable);
    void setJSCallback(void function(immutable(string)) cb);
    void mainLoop();
}
