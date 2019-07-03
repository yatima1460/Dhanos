module DhanosInterface;

interface DhanosInterface
{
    void init(immutable(string) title, immutable(string) url, int width, int height, bool resizable);
    void mainLoop();
}
