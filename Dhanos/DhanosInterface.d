module DhanosInterface;


alias DhanosJSCallback = void function(ref DhanosInterface, immutable(string));

interface DhanosInterface
{
   void init(in immutable(string) title,in  immutable(string) url,in  int width,in  int height,in bool resizable,void function(DhanosInterface) loadFinished)
   in (title !is null)
   in (title.length > 0)
   in (url !is null)
   in (url.length > 0)
   in (width > 0)
   in (height > 0)
   in (loadFinished !is null);

   void runJavascript(immutable(string) js)
   in (js !is null)
   in (js.length > 0);

   // void setJSCallback(void function(immutable(string)) cb)
   // in (cb !is null);

   // void function(DhanosInterface dhanos) loadFinished();

   void setCallback(in immutable(string) callbackName,in DhanosJSCallback cb) nothrow
   in (callbackName !is null)
   in (callbackName.length > 0)
   in (cb !is null);

   void mainLoop() nothrow;

   void close() nothrow; 
   void setBorder(bool); 

   import std.variant : Variant;

   void setUserObject(Variant o);

   Variant getUserObject() ;

   //void clearUserObject() nothrow;

   void setAlwaysOnTop(bool flag) nothrow;

   void setTitle(immutable(string) title) nothrow
   in (title !is null)
   in (title.length > 0);

   void setWindowSize(int width,int height) nothrow
   in (width > 0)
   in (height > 0);


}
