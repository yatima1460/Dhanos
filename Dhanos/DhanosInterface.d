module DhanosInterface;


alias DhanosJSCallback = extern(C) void function(DhanosInterface, immutable(string));

interface DhanosInterface
{
   void init(immutable(string) title, immutable(string) url, int width, int height, bool resizable)
   in (title !is null)
   in (title.length > 0)
   in (url !is null)
   in (url.length > 0)
   in (width > 0)
   in (height > 0);

   // void setJSCallback(void function(immutable(string)) cb)
   // in (cb !is null);

   void setCallback(immutable(string) callbackName, DhanosJSCallback cb) nothrow
   in (callbackName !is null)
   in (callbackName.length > 0)
   in (cb !is null);

   void mainLoop() nothrow;

   void close() nothrow; 
   void setBorder(bool) nothrow; 

   void runJavascript(immutable(string) js) nothrow
   in (js !is null)
   in (js.length > 0);

   void setUserObject(void* o) nothrow
   in (o !is null);

   void* getUserObject() nothrow;

   void clearUserObject() nothrow;

   void setAlwaysOnTop(bool flag) nothrow;

   void setTitle(immutable(string) title) nothrow
   in (title !is null)
   in (title.length > 0);

   void setWindowSize(int width,int height) nothrow
   in (width > 0)
   in (height > 0);
}
