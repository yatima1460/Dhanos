module Dhanos_Linux;

import std.string : toStringz;



/+
    GLIB GAsyncQueue
+/
@nogc nothrow extern (C) struct GAsyncQueue;
@trusted @nogc nothrow extern (C) GAsyncQueue* g_async_queue_new();

/+
    GTK
+/
@trusted @nogc nothrow extern (C) int gtk_init_check(int* argc, char*** argv);
@trusted @nogc nothrow extern (C) int gtk_main_iteration_do(int);
@trusted @nogc nothrow extern (C) void* G_CALLBACK(void*);

@nogc nothrow extern (C) struct GCancellable;
@nogc nothrow extern (C) struct GAsyncResult;
@nogc nothrow extern (C) struct GObject;

enum GConnectFlags
{
    G_CONNECT_AFTER,
    G_CONNECT_SWAPPED
};

/+
    GTKWidget
+/
@nogc nothrow extern (C) struct GtkWidget;
@trusted @nogc nothrow extern (C) GObject* G_OBJECT(GtkWidget*);
@trusted @nogc nothrow extern (C) void gtk_widget_set_size_request(GtkWidget*, int, int);
@trusted @nogc nothrow extern (C) void gtk_widget_show_all(GtkWidget*);

/*
    GTKWindow
*/
enum GtkWindowType
{
    GTK_WINDOW_TOPLEVEL,
    GTK_WINDOW_POPUP
};
enum GtkWindowPosition
{
    GTK_WIN_POS_NONE,
    GTK_WIN_POS_CENTER,
    GTK_WIN_POS_MOUSE,
    GTK_WIN_POS_CENTER_ALWAYS,
    GTK_WIN_POS_CENTER_ON_PARENT
}

@nogc nothrow extern (C) struct GtkWindow;
@trusted @nogc nothrow extern (C) GtkWindow* GTK_WINDOW(GtkWidget*);
@trusted @nogc nothrow extern (C) GtkWindow* gtk_window_new(GtkWindowType);
@trusted @nogc nothrow extern (C) void gtk_window_set_gravity(GtkWindow*, GdkGravity);
@trusted @nogc nothrow extern (C) void gtk_window_set_title(GtkWindow*, const char*);
@trusted @nogc nothrow extern (C) void gtk_window_set_default_size(GtkWindow*, int, int);
@trusted @nogc nothrow extern (C) void gtk_window_set_default_geometry(GtkWindow* window, int width, int height);
@trusted @nogc nothrow extern (C) void gtk_window_set_resizable(GtkWindow*, bool);
@trusted @nogc nothrow extern (C) void gtk_window_set_decorated(GtkWindow*, bool);
@trusted @nogc nothrow extern (C) void gtk_window_fullscreen(GtkWindow*);
@trusted @nogc nothrow extern (C) void gtk_window_unfullscreen(GtkWindow*);
@trusted @nogc nothrow extern (C) void gtk_window_set_position(GtkWindow*, GtkWindowPosition);
@trusted @nogc nothrow extern (C) void gtk_window_move(GtkWindow* window, int x, int y);
@trusted @nogc nothrow extern (C) void gtk_window_set_keep_above(GtkWindow* w, bool);

/+
    GDK
+/
@trusted @nogc nothrow extern (C) int gdk_screen_width();
@trusted @nogc nothrow extern (C) int gdk_screen_height();
@trusted @nogc nothrow extern (C) void g_signal_connect_data(void* instance, const char* detailed_signal, void* c_handler, void* data, void* destroy_data, GConnectFlags connect_flags);

@nogc nothrow extern (C) struct GtkAdjustment;
@trusted @nogc nothrow extern (C) GtkWidget* gtk_scrolled_window_new(GtkAdjustment* hadjustment, GtkAdjustment* vadjustment);

/+
    GTKContainer
+/
@nogc nothrow extern (C) struct GtkContainer;
@trusted @nogc nothrow extern (C) GtkContainer* GTK_CONTAINER(GtkWidget*);
@trusted @nogc nothrow extern (C) void gtk_container_add(GtkContainer* container, GtkWidget* widget);

/+
    WebKitUserContentManager
+/
@nogc nothrow extern (C) struct WebKitUserContentManager;
@trusted @nogc nothrow extern (C) WebKitUserContentManager* webkit_user_content_manager_new();
@trusted @nogc nothrow extern (C) bool webkit_user_content_manager_register_script_message_handler(WebKitUserContentManager* manager, const char* name);
@trusted @nogc nothrow extern (C) WebKitWebView* webkit_web_view_new_with_user_content_manager(WebKitUserContentManager* user_content_manager);


/+
    WebKitWebView
+/
@nogc nothrow extern (C) struct WebKitWebView;

@trusted @nogc nothrow extern (C) void webkit_web_view_load_uri(WebKitWebView* web_view, const char* uri);
@trusted @nogc nothrow extern (C) WebKitSettings* webkit_web_view_get_settings(WebKitWebView* web_view);


// alias GAsyncReadyCallback = void function(GObject* source_object,
//         GAsyncResult* res, void* user_data);
@trusted @nogc nothrow extern (C) void webkit_web_view_run_javascript(WebKitWebView* web_view, char* script, GCancellable* cancellable, void* callback, gpointer user_data);

/+
    WebKitSettings
+/
@nogc nothrow extern (C) struct WebKitSettings;
@trusted @nogc nothrow extern (C) void webkit_settings_set_enable_write_console_messages_to_stdout(WebKitSettings* settings, bool enabled);
@trusted @nogc nothrow extern (C) void webkit_settings_set_enable_developer_extras(WebKitSettings* settings, bool enabled);
@trusted @nogc nothrow extern (C) void webkit_settings_set_allow_file_access_from_file_urls(WebKitSettings*, bool);
@trusted @nogc nothrow extern (C) void webkit_settings_set_allow_universal_access_from_file_urls(WebKitSettings*, bool);

enum GdkGravity
{
    GDK_GRAVITY_NORTH_WEST,
    GDK_GRAVITY_NORTH,
    GDK_GRAVITY_NORTH_EAST,
    GDK_GRAVITY_WEST,
    GDK_GRAVITY_CENTER,
    GDK_GRAVITY_EAST,
    GDK_GRAVITY_SOUTH_WEST,
    GDK_GRAVITY_SOUTH,
    GDK_GRAVITY_SOUTH_EAST,
    GDK_GRAVITY_STATIC
};

struct webview_priv
{
    GtkWindow* window;
    GtkWidget* scroller;
    WebKitWebView* webview;
    GtkWidget* inspector_window;
    GAsyncQueue* queue;

    int ready;
    int js_busy;
    int should_exit;
};


struct webview
{
    char* url;
    char* title;
    int width;
    int height;
    int resizable;
    int webview_debug;
    // webview_external_invoke_cb_t external_invoke_cb;

    webview_priv priv;

    void* userdata;
    Dhanos_Linux dhanos_ptr;
};

//extern (C) int webview(const char* title, const char* url, int width, int height, int resizable);
// extern (C) int webview_init(webview* w);
// extern (C) int webview_loop(webview* w, bool);
@nogc nothrow extern (C) int webview_eval(webview* w, const char* js);
//@nogc nothrow extern (C) void webview_terminate(webview* w);

// alias webview_dispatch_fn = void function(webview* w, void* arg);
// @nogc nothrow extern (C) void webview_dispatch(webview* w, webview_dispatch_fn fn, void* arg);

import std.stdio : writeln;
import std.string : fromStringz;

@nogc extern (C) struct WebKitJavascriptResult;
enum WebKitLoadEvent
{
    WEBKIT_LOAD_STARTED,
    WEBKIT_LOAD_REDIRECTED,
    WEBKIT_LOAD_COMMITTED,
    WEBKIT_LOAD_FINISHED
};

alias JSGlobalContextRef = void*;
alias JSValueRef = void*;
alias JSStringRef = void*;

@nogc nothrow extern (C) JSStringRef JSValueToStringCopy(JSGlobalContextRef, JSValueRef, void*);
@nogc nothrow extern (C) size_t JSStringGetMaximumUTF8CStringSize(JSStringRef);
@nogc nothrow extern (C) JSGlobalContextRef webkit_javascript_result_get_global_context(
        WebKitJavascriptResult* js_result);
@nogc nothrow extern (C) JSValueRef webkit_javascript_result_get_value(
        WebKitJavascriptResult* js_result);
@nogc nothrow extern (C) void JSStringGetUTF8CString(JSStringRef, char*, size_t);
@nogc nothrow extern (C) void JSStringRelease(JSStringRef);

alias gpointer = void*;

import std.exception : enforce;

// nothrow extern (C) void external_message_received_cb(WebKitUserContentManager* manager, WebKitJavascriptResult* js_result, gpointer user_data)
// in (manager != null)
// in (js_result != null)
// in (user_data != null)
// {
//     //writeln("external_message_received_cb");

//     //writeln(user_data);
//     //writeln(cast(Dhanos_Linux*) user_data);

//     Dhanos_Linux w = cast(Dhanos_Linux) user_data;
//     assert(w !is null);

//     //writeln("external_message_received_cb 2");
//    // writeln(w);
//     //writeln("external_message_received_cb 2.5");
//     //writeln(w.toString());
//     //writeln("external_message_received_cb 3");

//     JSGlobalContextRef context = webkit_javascript_result_get_global_context(js_result);
//     assert(context!is null);

//     JSValueRef value = webkit_javascript_result_get_value(js_result);
//     assert(value !is null);

//     JSStringRef js = JSValueToStringCopy(context, value, null);
//     assert(js !is null);

//     size_t n = JSStringGetMaximumUTF8CStringSize(js);

//     // char* s = g_new(char, n);
//     char[] s = new char[n];
//     assert(s !is null);

//     JSStringGetUTF8CString(js, cast(char*) s, n);

//     //writeln("external_message_received_cb external_invoke_cb s");
//     const char* ss = cast(const char*) s;
//     assert(ss !is null);
//     immutable(string) js_command = cast(immutable) fromStringz(ss);
//     assert(js_command !is null);
//     //writeln("external_message_received_cb external_invoke_cb ss");
//    // writeln(w);
//     // writeln(w.external_invoke_cb);
//     // writeln(w.dhanos_ptr);
//     //writeln(js_command);
//     assert(w !is null);
//     w.callback(js_command);
//     //writeln("external_message_received_cb external_invoke_cb e");

//     assert(js);
//     JSStringRelease(js);
//     //writeln("external_message_received_cb e");
//     // g_free(s);
// }
extern (C) struct JSCValue;



extern (C) struct GError
{
  uint       domain;
  int         code;
  char       *message;
};

@trusted @nogc nothrow extern (C) WebKitWebView* WEBKIT_WEB_VIEW(GObject*);

extern (C) WebKitJavascriptResult* webkit_web_view_run_javascript_finish(
        WebKitWebView* web_view, GAsyncResult* result, GError** error);

extern (C) void web_view_javascript_finished(GObject* object, GAsyncResult* result, gpointer user_data)
{
    import core.stdc.stdio : printf;

    Dhanos_Linux dhanos = cast(Dhanos_Linux) user_data;
    printf("web_view_javascript_finished\n");
    WebKitJavascriptResult* js_result;
    JSCValue* value;
    GError* error = null;

    js_result = webkit_web_view_run_javascript_finish(cast(WebKitWebView*)(object),
            result, &error);
    if (!js_result)
    {
        printf("%d\n", error.code);
        printf("Error running javascript: %s\n", error.message);

        return;
    }
}

extern (C) void webview_load_changed_cb(WebKitWebView* wwv, WebKitLoadEvent event, void* arg)
in(wwv !is null)
in(arg !is null)
{
    import core.stdc.stdio : printf;
    printf("webview_load_changed_cb\n");
    Dhanos_Linux dhanos = cast(Dhanos_Linux) arg;
    assert(dhanos !is null);

    switch (event)
    {
        case WebKitLoadEvent.WEBKIT_LOAD_COMMITTED:
            printf("WEBKIT_LOAD_COMMITTED\n");
            break;

        case WebKitLoadEvent.WEBKIT_LOAD_FINISHED:
            printf("WEBKIT_LOAD_FINISHED\n");

            
            dhanos.loadFinished(dhanos);
            // if (dhanos.data.priv.webview !is null)
            // {   
            //     //auto w = dhanos.data.priv.webview;
            //     //dhanos.data.priv.webview = wwv;
                
            // }
            // else
            // {
            //     printf("webview is null\n");
            // }

            dhanos.data.priv.ready = 1;
            break;

        case WebKitLoadEvent.WEBKIT_LOAD_REDIRECTED:
            printf("WEBKIT_LOAD_REDIRECTED\n");
            break;

        case WebKitLoadEvent.WEBKIT_LOAD_STARTED:
            printf("WEBKIT_LOAD_STARTED\n");
            break;
        default:
            assert(0,"WebKitLoadEvent value is invalid");

    }
}

@nogc extern (C) void webview_destroy_cb(GtkWidget* widget, void* arg)
in(widget != null)
in(arg != null)
{
    //writeln("webview_destroy_cb");
    webview* w = cast(webview*) arg;
    w.priv.should_exit = 1;
    //writeln("destroy DONE");
}

extern (C) void webview_context_menu_cb(GtkWidget* widget, void* arg)
in(widget != null)
in(arg != null)
{

}

// extern(C) void raw_callback(Dhanos_Linux d, immutable(string) js_command)

// {
//     writeln("raw_callback");

//     if (d is null)
//         throw new Exception("Dhanos object is null!");
//     if (js_command == null)
//         throw new Exception("Javascript callback argument can't be null!");
//     if (d.callback == null)
//         throw new Exception("JS=>D callback can't be null!");

//     d.callback(js_command);

// }

import DhanosInterface : DhanosInterface;

// extern(C) void custom_callback(WebKitUserContentManager *manager, WebKitJavascriptResult   *js_result, gpointer user_data)
// {
//     auto custom_callback = cast(void function(immutable(string)))user_data;
//     writeln("custom callback");

//     JSGlobalContextRef context = webkit_javascript_result_get_global_context(js_result);
//     JSValueRef value = webkit_javascript_result_get_value(js_result);
//     JSStringRef js = JSValueToStringCopy(context, value, null);
//     size_t n = JSStringGetMaximumUTF8CStringSize(js);
//     char[] s = new char[n];
//     JSStringGetUTF8CString(js, cast(char*) s, n);
//     const char* ss = cast(const char*)s;
//     immutable(string) js_value = cast(immutable)fromStringz(ss);

//     writeln("custom value: "~js_value);
//     custom_callback(js_value);
//  }

import DhanosInterface : DhanosJSCallback;

extern (C) struct DhanosCallbackData
{
    DhanosInterface dhanos;
    invariant
    {
        assert(dhanos !is null);
    }

    DhanosJSCallback callback_func;
    invariant
    {
        assert(callback_func !is null);
    }

    // string callback_name;
    // invariant
    // {
    //     assert(callback_name !is null);
    //     assert(callback_name.length > 0);
    // }
}

extern (C) void custom_callback(WebKitUserContentManager* manager,
        WebKitJavascriptResult* js_result, gpointer user_data)
in(manager !is null)
in(js_result !is null)
in(user_data !is null)
{
    synchronized
    {
        DhanosCallbackData* callback_data = cast(DhanosCallbackData*) user_data;
        assert(callback_data !is null);
        //writeln("[Dhanos] custom_callback '" ~ callback_data.callback_name ~ "' BEGIN");

        // get input value from JS function
        JSGlobalContextRef context = webkit_javascript_result_get_global_context(js_result);
        assert(context !is null);
        JSValueRef value = webkit_javascript_result_get_value(js_result);
        assert(value !is null);
        JSStringRef js = JSValueToStringCopy(context, value, null);
        assert(js !is null);
        size_t n = JSStringGetMaximumUTF8CStringSize(js);
        char[] s = new char[n];
        assert(s !is null);
        JSStringGetUTF8CString(js, cast(char*) s, n);
        const char* ss = cast(const char*) s;
        assert(ss !is null);
        immutable(string) js_value = cast(immutable) fromStringz(ss);
        assert(js_value !is null);

        //immutable(string) js_value = "owo";

        //writeln("[Dhanos] custom_callback value: " ~ js_value);

        // DhanosInterface dd = *callback_data.dhanos;
        //writeln("[Dhanos] custom_callback call");
        //writeln((&callback_data.dhanos.setTitle).ptr);

        assert(callback_data.dhanos !is null);
        assert(callback_data.callback_func !is null);
        callback_data.callback_func(callback_data.dhanos, js_value);
    }
    //writeln("[Dhanos] custom_callback END");
}

void dhanos_page_loaded(DhanosInterface di, immutable(string) value)
in(di !is null)
in(value !is null)
{
    // writeln("[Dhanos] loaded webpage JS loaded");
    
    di.setTitle("dhanos page loaded test name");
}

class Dhanos_Linux : DhanosInterface
{

    void function(DhanosInterface) loadFinished;
    // int ready;
    // int should_exit;
    // GAsyncQueue* queue;
    // GtkWidget* window;

    this()
    {
        //setCallback("exit",)
    }

    static immutable(string) DEFAULT_URL = "data:text/"
        ~ "html,%3C%21DOCTYPE%20html%3E%0A%3Chtml%20lang=%22en%22%3E%0A%3Chead%3E%"
        ~ "3Cmeta%20charset=%22utf-8%22%3E%3Cmeta%20http-equiv=%22X-UA-Compatible%22%"
        ~ "20content=%22IE=edge%22%3E%3C%2Fhead%3E%0A%3Cbody%3E%3Cdiv%20id=%22app%22%"
        ~ "3E%3C%2Fdiv%3E%3Cscript%20type=%22text%2Fjavascript%22%3E%3C%2Fscript%3E%"
        ~ "3C%2Fbody%3E%0A%3C%2Fhtml%3E";

    @nogc static immutable(string) checkURL(immutable(string) url)
    {
        if (url == null || url.length == 0)
        {
            return DEFAULT_URL;
        }
        return url;
    }

    string title;
    string url;
    int width;
    int height;
    bool resizable;
    webview data;

    //void setFullscreen(bool fullscreen);
    void*[immutable(string)] callbacks;

    @safe @nogc nothrow void setAlwaysOnTop(bool flag)
    {
        synchronized
        {
            gtk_window_set_keep_above(data.priv.window, flag);
        }
    }

    void setCallback(immutable(string) callbackName, DhanosJSCallback cb)
    in(callbackName !is null)
    in(callbackName.length != 0)
    in(cb !is null)
    {
        synchronized
        {
            import std.conv : to;

            //writeln("[Dhanos] setCallback " ~ callbackName ~ " => " ~ to!string(cb));
            callbacks[callbackName] = cb;
            auto callbackNameCString = toStringz(callbackName);
            webkit_user_content_manager_register_script_message_handler(webkitUserContentManager,
                    callbackNameCString);

            DhanosCallbackData* dcd = new DhanosCallbackData();
            dcd.callback_func = cb;

            dcd.dhanos = this;

            //dcd.callback_name = callbackName;

            g_signal_connect_data(webkitUserContentManager,
                    cast(const char*) toStringz("script-message-received::" ~ callbackName),
                    &custom_callback, dcd, null, GConnectFlags.G_CONNECT_AFTER);

            webkit_web_view_run_javascript(
      data.priv.webview,
      cast(char*)toStringz("window."~callbackName~"={invoke:function(x){window.webkit.messageHandlers."~callbackName~".postMessage(x);}}"),
      null, null, null);
            
        // webkit_web_view_run_javascript(
        //                 data.priv.webview,
        //                 cast(char*)toStringz("dhanos." ~ callbackName ~ "=function(x){" ~ "window.webkit.messageHandlers." ~ callbackName ~ ".postMessage(x);}"),
        //                 null, 
        //                 null, 
        //                 null
        //             );
        }
    }

    void runJavascript(immutable(string) js)
    in(data.priv.webview !is null)
    {
        synchronized
        {
            webkit_web_view_run_javascript(data.priv.webview, cast(char*)toStringz(js), null, null, null);
        }
    }

    @safe @nogc void mainLoop()

    {
        import std.stdio : writeln;

        while (!data.priv.should_exit)
        {

            gtk_main_iteration_do(true);
        }

    }

    @nogc nothrow void setWindowSize(int w, int h)
    in(w > 0)
    in(h > 0)
    in(data.priv.window !is null)
    {
        synchronized
        {
            gtk_widget_set_size_request(cast(GtkWidget*) data.priv.window, w, h);
        }
    }

    @safe nothrow void setTitle(immutable(string) title)
    in(title !is null)
    in(title.length > 0)
    {
        synchronized
        {
            gtk_window_set_title(data.priv.window, toStringz(title));
        }
    }
    // this(immutable(string) title, int width, int height, bool resizable)
    // {

    //     if (gtk_init_check(0, null) == false)
    //     {
    //         throw new Exception("GTK not initialized");
    //     }

    //     ready = 0;
    //     should_exit = 0;
    //     queue = g_async_queue_new();
    //     window = gtk_window_new(GtkWindowType.GTK_WINDOW_TOPLEVEL);
    //     gtk_window_set_title(window, toStringz(title));

    //     if (resizable)
    //     {
    //         gtk_window_set_default_size(window, width, height);
    //     }
    //     else
    //     {
    //         gtk_widget_set_size_request(window, width, height);
    //     }

    //     gtk_window_set_resizable(window, resizable);
    //     //gtk_window_set_position(window, GTK_WIN_POS_CENTER);

    //     // w.priv.scroller = gtk_scrolled_window_new(NULL, NULL);
    //     // gtk_container_add(GTK_CONTAINER(w.priv.window), w.priv.scroller);

    //     // WebKitUserContentManager* m = webkit_user_content_manager_new();
    //     // webkit_user_content_manager_register_script_message_handler(m, "external");
    //     // g_signal_connect(m, "script-message-received::external",
    //     //         G_CALLBACK(external_message_received_cb), w);

    //     // w.priv.webview = webkit_web_view_new_with_user_content_manager(m);
    //     // webkit_web_view_load_uri(WEBKIT_WEB_VIEW(w.priv.webview), webview_check_url(w.url));


    //     // debug
    //     // {
    //     //     WebKitSettings * settings = webkit_web_view_get_settings(
    //     //             WEBKIT_WEB_VIEW(w.priv.webview));
    //     //     webkit_settings_set_enable_write_console_messages_to_stdout(settings, true);
    //     //     webkit_settings_set_enable_developer_extras(settings, true);
    //     // }
    //     // else
    //     // {
    //     //     g_signal_connect(G_OBJECT(w.priv.webview), "context-menu",
    //     //             G_CALLBACK(webview_context_menu_cb), w);
    //     // }

    //     gtk_widget_show_all(window);

    //     // webkit_web_view_run_javascript(WEBKIT_WEB_VIEW(w.priv.webview),
    //     //         "window.external={invoke:function(x){"~"window.webkit.messageHandlers.external.postMessage(x);}}",
    //     //         NULL, NULL, NULL);

    //     // g_signal_connect(G_OBJECT(w.priv.window), "destroy",
    //     //         G_CALLBACK(webview_destroy_cb), w);
    //     // return 0;
    // }
private:

    WebKitUserContentManager* webkitUserContentManager;

public:

    @safe @nogc nothrow void close()
    {
        data.priv.should_exit = 1;
    }

    //    ~this()
    //    {
    //       import std.stdio : writeln;
    //       writeln("Dhanos_Linux de-allocated");
    //    }

    // @nogc pure void function(immutable(string)) getJSCallback()
    // {
    //     return callback;
    // }

    // @nogc void setJSCallback(void function(immutable(string)) cb)
    // in(cb !is null)
    // {
    //     this.callback = cb;
    // }

    // void noop_callback(immutable(string) value)
    // {
    //         writeln("noop_callback");

    // }

    import std.variant : Variant;

    Variant o;

    void setUserObject(Variant o)
    {
        synchronized
        {
            this.o = o;
        }
    }

    Variant getUserObject()
    {
        synchronized return o;
    }

    //    @safe @nogc nothrow void clearUserObject()
    //     {
    //           synchronized
    //         this.o = null;
    //     }

    void init(in immutable(string) title, in immutable(string) url, in int width,
            in int height, in bool resizable, void function(DhanosInterface) loadFinished)
    in(title !is null)
    in(url !is null)
    in(width > 0)
    in(height > 0)
    {
        this.loadFinished = loadFinished;
        import core.stdc.stdio : printf;
        printf("Dhanos init\n");
        this.title = title;
        this.url = url;
        this.width = width;
        this.height = height;
        this.resizable = resizable;
        data.title = cast(char*) toStringz(title);
        assert(data.title !is null);
        data.url = cast(char*) toStringz(url);
        assert(data.url !is null);
        data.width = width;
        data.height = height;
        data.resizable = resizable;
        data.dhanos_ptr = this;
        

        if (gtk_init_check(null, null) == false)
        {
            printf("can't initialize GTK\n");
            throw new Exception("Can't initialize GTK");
        }
        else
        {
            printf("GTK can be initialized\n");
        }

       
        data.priv.ready = 0;
        data.priv.should_exit = 0;
        data.priv.queue = g_async_queue_new();
        assert(data.priv.queue !is null);
        data.priv.window = gtk_window_new(GtkWindowType.GTK_WINDOW_TOPLEVEL);
        assert(data.priv.window !is null);

        //   GdkScreen *screen = gtk_widget_get_screen(widget);
        //     GdkColormap *colormap = gdk_screen_get_rgba_colormap(screen);

        //     if (!colormap)
        //     {
        //         printf("Your screen does not support alpha channels!\n");
        //         colormap = gdk_screen_get_rgb_colormap(screen);
        //         supports_alpha = FALSE;
        //     }
        //     else
        //     {
        //         printf("Your screen supports alpha channels!\n");
        //         supports_alpha = TRUE;
        //     }
        //         gtk_widget_set_colormap(   data.priv.window, colormap);
    

        gtk_window_set_title(data.priv.window, data.title);

        //gtk_window_set_default_geometry (cast(GtkWindow*)(data.priv.window),   width,   height);
        //gtk_widget_set_size_request(data.priv.window, data.width, data.height);
        //gtk_window_set_default_size(cast(GtkWindow*)(data.priv.window), data.width, data.height);

        //    gtk_window_set_default_size(cast(GtkWindow*)(data.priv.window),
        //     data.width, data.height);              
        if (data.resizable)
        {
            //writeln("a");
            gtk_window_set_default_size(data.priv.window, data.width, data.height);
        }
        else
        {
            //writeln("b");
            // gtk_window_set_default_size(cast(GtkWindow*)(data.priv.window), 1920, 1080);

            //gtk_window_set_default_size(cast(GtkWindow*)(data.priv.window),
            //        data.width, data.height);

            // gtk_window_set_default_geometry (GtkWindow *window,
            //                                  gint width,
            //                                  gint height);
            gtk_widget_set_size_request(cast(GtkWidget*) data.priv.window,
                    data.width, data.height);
        }
        gtk_window_set_resizable(data.priv.window, cast(bool)data.resizable);
        gtk_window_set_position(data.priv.window, GtkWindowPosition.GTK_WIN_POS_CENTER);

        //gtk_window_unfullscreen(cast(GtkWindow*) data.priv.window);

        
        printf("gtk_window_set_resizable\n");

        // Add scrollbar if needed
        data.priv.scroller = gtk_scrolled_window_new(null, null);
        gtk_container_add(cast(GtkContainer*)(data.priv.window), data.priv.scroller);

        webkitUserContentManager = webkit_user_content_manager_new();
        assert(webkitUserContentManager !is null);
        printf("webkitUserContentManager\n");
        // webkit_user_content_manager_register_script_message_handler(webkitUserContentManager,
        //         "external");

        // g_signal_connect_data(cast(void*) webkitUserContentManager,
        //         cast(const char*) toStringz("script-message-received::external"),
        //         cast(void*)&external_message_received_cb, cast(void*) this,
        //         null, GConnectFlags.G_CONNECT_AFTER);
    
        // Create new internal browser
        data.priv.webview = webkit_web_view_new_with_user_content_manager(webkitUserContentManager);
        printf("webkit_web_view_new_with_user_content_manager webkitUserContentManager\n");

        // Load input URL
        webkit_web_view_load_uri(data.priv.webview,toStringz(checkURL(fromStringz(data.url).idup)));
        printf("webkit_web_view_load_uri data.url\n");

  // Callback when the browser loading changed
        g_signal_connect_data(data.priv.webview, "load-changed", &webview_load_changed_cb, cast(void*)this, null, GConnectFlags.G_CONNECT_AFTER);
        printf("g_signal_connect_data load-changed\n");




        // Add the browser to GTK
        gtk_container_add(cast(GtkContainer*)(data.priv.scroller), cast(GtkWidget*) data.priv.webview);
        //gtk_container_add(cast(GtkContainer*)(data.priv.window), cast(GtkWidget*)data.priv.webview);
        //printf("gtk_container_add data.priv.webview\n");
        //gtk_container_add(cast(GtkContainer*)(data.priv.window), cast(GtkWidget*) data.priv.webview);

        // Webkit settings here
        WebKitSettings* settings = webkit_web_view_get_settings(cast(WebKitWebView*)(data.priv.webview));
        assert(settings !is null);
        printf("webkit_web_view_get_settings\n");


        // Allow access to local files to load icons or thumbnails
        // webkit_settings_set_allow_file_access_from_file_urls(settings, true);
        // printf("webkit_settings_set_allow_file_access_from_file_urls\n");
        // webkit_settings_set_allow_universal_access_from_file_urls(settings, true);
        // printf("webkit_settings_set_allow_universal_access_from_file_urls\n");

        // If we are in debug mode enable developer tools
        debug
        {
            webkit_settings_set_enable_write_console_messages_to_stdout(settings, true);
            printf("webkit_settings_set_enable_write_console_messages_to_stdout\n");
            webkit_settings_set_enable_developer_extras(settings, true);
            printf("webkit_settings_set_enable_developer_extras\n");

        }
        else
        {
            // g_signal_connect_data(data.priv.webview, "context-menu",
            //         &webview_context_menu_cb, null, null,
            //     GConnectFlags.G_CONNECT_AFTER);
            // webkit_web_view_run_javascript(cast(WebKitWebView*)(data.priv.webview),
            //         "document.oncontextmenu = null", null, null, null);

        }

       

        // Spawn the window
        gtk_widget_show_all(cast(GtkWidget*) data.priv.window);
        printf("gtk_widget_show_all\n");

        //  char* js = cast(char*)toStringz("window.dhanos={};");
        //  webkit_web_view_run_javascript(data.priv.webview, js, null, cast(void*)&web_view_javascript_finished, cast(void*)this);
        //     assert(loadFinished !is null);

    //         webkit_web_view_run_javascript(
    //   data.priv.webview,
    //   cast(char*)toStringz("window.external={invoke:function(x){window.webkit.messageHandlers.external.postMessage(x);}}"),
    //   null, null, null);



    //         webkit_web_view_run_javascript(
    //   data.priv.webview,
    //   cast(char*)toStringz("console.log('aaaa'"),
    //   null, null, null);

    //         webkit_web_view_run_javascript(
    //   data.priv.webview,
    //   cast(char*)toStringz("window.external={invoke:function(x){window.webkit.messageHandlers.external.postMessage(x);}}"),
    //   null, null, null);

             // Callback when the window [X] is pressed
        g_signal_connect_data(data.priv.window, "destroy", &webview_destroy_cb, &data, null, GConnectFlags.G_CONNECT_AFTER);
        printf("g_signal_connect_data destroy\n");

      



             //gtk_window_set_position(cast(GtkWindow*) data.priv.window, GtkWindowPosition.GTK_WIN_POS_CENTER_ALWAYS);

            // GtkRequisition requisition;
            // gtk_widget_size_request (data.priv.window, &requisition);

            // writeln(requisition.width);
            // writeln(requisition.height);

            // Create the dhanos object to hold the callbacks
           



// version (none)
//         {




            // g_signal_connect(G_OBJECT(data.priv.webview), "load-changed",
            //     cast(void*)&webview_load_changed_cb, null, GConnectFlags.G_CONNECT_AFTER);
       // gtk_container_add(GTK_CONTAINER(w.priv.scroller), w.priv.webview);

            //data.external_invoke_cb = cast(webview_external_invoke_cb_t)&raw_callback;

            //gtk_window_set_gravity(cast(GtkWindow*) data.priv.window, GdkGravity.GDK_GRAVITY_CENTER);
            // gtk_window_move(cast(GtkWindow*) data.priv.window, gdk_screen_width()/2, gdk_screen_height()/2);
            //  gtk_window_set_position(cast(GtkWindow*) data.priv.window, GtkWindowPosition.GTK_WIN_POS_CENTER);
            //gtk_window_move (cast(GtkWindow*) data.priv.window, 0, 0);

            //gtk_window_set_position(cast(GtkWindow*) data.priv.window, GtkWindowPosition.GTK_WIN_POS_CENTER_ALWAYS);

        // }

    }

    @safe void setBorder(bool visible)
    {
        import core.stdc.stdio : printf;
        import std.stdio : writeln;
        writeln("Dhanos.setBorder");
        gtk_window_set_decorated(data.priv.window, visible);
    }

    // static int launch(immutable(string) title, immutable(string) url, int width,  int height, bool resizable)
    // {
    //     webview w;
    //     w.title = cast(char*) toStringz(title);
    //     w.url = cast(char*) toStringz(url);
    //     w.width = width;
    //     w.height = height;
    //     w.resizable = resizable;
    //     int r = webview_init(&w);
    //     if (r != 0)
    //     {
    //         return r;
    //     }
    //     while (webview_loop(&w, 1) == 0)
    //     {
    //     }
    //     webview_exit(&w);
    //     return 0;
    // }
}
