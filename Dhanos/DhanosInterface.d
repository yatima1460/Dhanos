module DhanosInterface;


alias DhanosJSCallback = void function(ref DhanosInterface, immutable(string));

interface DhanosInterface
{
   void init(in immutable(string) title,in  immutable(string) url,in  int width,in  int height,in bool resizable)
   in (title !is null)
   in (title.length > 0)
   in (url !is null)
   in (url.length > 0)
   in (width > 0)
   in (height > 0);

   void runJavascript(immutable(string) js)
   in (js !is null)
   in (js.length > 0);

   // void setJSCallback(void function(immutable(string)) cb)
   // in (cb !is null);

   void setCallback(in immutable(string) callbackName,in DhanosJSCallback cb) nothrow
   in (callbackName !is null)
   in (callbackName.length > 0)
   in (cb !is null);

   void mainLoop() nothrow;

   void close() nothrow; 
   void setBorder(bool) nothrow; 

   void runJavascript(immutable(string) js) nothrow
   in (js !is null)
   in (js.length > 0);

   void setUserObject(shared(void*) o) nothrow
   in (o !is null);

   shared(void*) getUserObject() nothrow ;

   void clearUserObject() nothrow;

   void setAlwaysOnTop(bool flag) nothrow;

   void setTitle(immutable(string) title) nothrow
   in (title !is null)
   in (title.length > 0);

   void setWindowSize(int width,int height) nothrow
   in (width > 0)
   in (height > 0);


}
