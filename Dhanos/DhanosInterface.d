module DhanosInterface;

interface DhanosInterface
{
    void init(immutable(string) title, immutable(string) url, int width, int height, bool resizable);
    void setJSCallback(void function(immutable(string)) cb);
    void setCallback(immutable(string) callbackName, void* cb);
    void mainLoop();
    void close();
    void setBorder(bool);
    void runJavascript(immutable(string) js);
    void setUserObject(Object o);
    Object getUserObject();
      void setAlwaysOnTop(bool flag);
   void setTitle(immutable(string) title);


   void setWindowSize(int,int);
}
