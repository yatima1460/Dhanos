module Dhanos_Linux;

import std.string : toStringz;

// GLIB GAsyncQueue
extern (C) struct GAsyncQueue;
extern (C) GAsyncQueue* g_async_queue_new();

// GTK general
extern (C) int gtk_init_check(int* argc, char*** argv);

// GTK widget
extern (C) struct GtkWidget;
extern (C) void gtk_widget_set_size_request(GtkWidget*, int, int);
extern (C) void gtk_widget_show_all(GtkWidget*);

// struct GtkRequisition {
//   int width;
//   int height;
// };

// extern (C) void gtk_widget_size_request(GtkWidget*,GtkRequisition*);

// GTK window
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

extern (C) struct GtkWindow;
extern (C) GtkWindow* GTK_WINDOW(GtkWidget*);
extern (C) GtkWindow* gtk_window_new(GtkWindowType);
extern (C) void gtk_window_set_title(GtkWindow*, const char*);
extern (C) void gtk_window_set_default_size(GtkWindow*, int, int);
extern (C)  void
gtk_window_set_default_geometry (GtkWindow *window,
                                 int width,
                                 int height);
extern (C) void gtk_window_set_resizable(GtkWindow*, bool);
extern (C) void gtk_window_set_decorated(GtkWindow*, bool);
extern (C) void gtk_window_fullscreen(GtkWindow*);
extern (C) void gtk_window_unfullscreen(GtkWindow*);
extern (C) void gtk_window_set_position(GtkWindow*, GtkWindowPosition);
extern (C) void gtk_window_move(GtkWindow* window, int x, int y);
extern (C) int gdk_screen_width();
extern (C) int gdk_screen_height();

enum GConnectFlags
{
    G_CONNECT_AFTER,
    G_CONNECT_SWAPPED
};

extern (C) void g_signal_connect_data(void* instance, const char* detailed_signal,
        void* c_handler, void* data, void* destroy_data, GConnectFlags connect_flags);

extern (C) struct GtkAdjustment;
extern (C) GtkWidget* gtk_scrolled_window_new(GtkAdjustment* hadjustment,
        GtkAdjustment* vadjustment);

extern (C) struct GtkContainer;
extern (C) GtkContainer* GTK_CONTAINER(GtkWidget*);
extern (C) void gtk_container_add(GtkContainer* container, GtkWidget* widget);

extern (C) struct WebKitUserContentManager;

extern (C) GObject* G_OBJECT(GtkWidget*);

extern (C) void* G_CALLBACK(void*);

extern (C) WebKitWebView* WEBKIT_WEB_VIEW(GtkWidget*);
extern (C) WebKitUserContentManager* webkit_user_content_manager_new();
extern (C) bool webkit_user_content_manager_register_script_message_handler(
        WebKitUserContentManager* manager, const char* name);
extern (C) struct WebKitSettings;
extern (C) struct WebKitWebView;

extern (C) int gtk_main_iteration_do(int);
extern (C) WebKitSettings* webkit_web_view_get_settings(WebKitWebView* web_view);
extern (C) void webkit_settings_set_enable_write_console_messages_to_stdout(
        WebKitSettings* settings, bool enabled);
extern (C) void webkit_settings_set_enable_developer_extras(WebKitSettings* settings, bool enabled);

extern (C) void webkit_settings_set_allow_file_access_from_file_urls(WebKitSettings*, bool);
extern (C) void webkit_settings_set_allow_universal_access_from_file_urls(WebKitSettings*, bool);

extern (C) struct GCancellable;
extern (C) struct GAsyncResult;
extern (C) struct GObject;
alias GAsyncReadyCallback = void function(GObject* source_object,
        GAsyncResult* res, void* user_data);
extern (C) void webkit_web_view_run_javascript(WebKitWebView* web_view, const char* script,
        GCancellable* cancellable, GAsyncReadyCallback callback, void* user_data);

extern (C) GtkWidget* webkit_web_view_new_with_user_content_manager(
        WebKitUserContentManager* user_content_manager);
extern (C) void webkit_web_view_load_uri(WebKitWebView* web_view, const char* uri);

extern (C) void gtk_window_set_keep_above(GtkWindow*,bool);

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

extern (C) void gtk_window_set_gravity(GtkWindow*, GdkGravity);

struct webview_priv
{

    GtkWidget* window;
    GtkWidget* scroller;
    GtkWidget* webview;
    GtkWidget* inspector_window;
    GAsyncQueue* queue;

    int ready;
    int js_busy;
    int should_exit;
};

//alias void (*webview_external_invoke_cb_t)(struct webview *w, const char *arg);

//extern (C) alias webview_external_invoke_cb_t = int function(webview, const char*);

alias webview_external_invoke_cb_t = void function(Dhanos_Linux w, immutable(string) arg);

struct webview
{
    char* url;
    char* title;
    int width;
    int height;
    int resizable;
    int webview_debug;
    webview_external_invoke_cb_t external_invoke_cb;

    webview_priv priv;

    void* userdata;
    Dhanos_Linux dhanos_ptr;
};

//extern (C) int webview(const char* title, const char* url, int width, int height, int resizable);
// extern (C) int webview_init(webview* w);
// extern (C) int webview_loop(webview* w, bool);
extern (C) int webview_eval(webview* w, const char* js);
extern (C) void webview_terminate(webview* w);

alias webview_dispatch_fn = void function(webview* w, void* arg);
extern (C) void webview_dispatch(webview* w, webview_dispatch_fn fn, void* arg);

import std.stdio : writeln;
import std.string : fromStringz;

extern (C) struct WebKitJavascriptResult;
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
extern (C) JSStringRef JSValueToStringCopy(JSGlobalContextRef, JSValueRef, void*);
extern (C) size_t JSStringGetMaximumUTF8CStringSize(JSStringRef);

extern (C) JSGlobalContextRef webkit_javascript_result_get_global_context(
        WebKitJavascriptResult* js_result);

extern (C) JSValueRef webkit_javascript_result_get_value(WebKitJavascriptResult* js_result);

extern (C) void JSStringGetUTF8CString(JSStringRef, char*, size_t);

extern (C) void JSStringRelease(JSStringRef);

alias gpointer = void*;

extern (C) void external_message_received_cb(WebKitUserContentManager* manager,
        WebKitJavascriptResult* js_result, gpointer user_data)
{

    writeln("external_message_received_cb");

    writeln(user_data);
    writeln(cast(Dhanos_Linux*) user_data);

    Dhanos_Linux w = cast(Dhanos_Linux) user_data;

    writeln("external_message_received_cb 2");
    writeln(w);
    writeln("external_message_received_cb 2.5");
    writeln(w.toString());
    writeln("external_message_received_cb 3");

    JSGlobalContextRef context = webkit_javascript_result_get_global_context(js_result);

    JSValueRef value = webkit_javascript_result_get_value(js_result);

    JSStringRef js = JSValueToStringCopy(context, value, null);

    size_t n = JSStringGetMaximumUTF8CStringSize(js);

    // char* s = g_new(char, n);
    char[] s = new char[n];

    JSStringGetUTF8CString(js, cast(char*) s, n);

    writeln("external_message_received_cb external_invoke_cb s");
    const char* ss = cast(const char*) s;
    immutable(string) js_command = cast(immutable) fromStringz(ss);
    writeln("external_message_received_cb external_invoke_cb ss");
    writeln(w);
    // writeln(w.external_invoke_cb);
    // writeln(w.dhanos_ptr);
    writeln(js_command);
    w.callback(js_command);
    writeln("external_message_received_cb external_invoke_cb e");

    JSStringRelease(js);
    writeln("external_message_received_cb e");
    // g_free(s);
}

void webview_load_changed_cb(WebKitWebView* wwv, WebKitLoadEvent event, void* arg)
{
    writeln("webview_load_changed_cb");
    webview* w = cast(webview*) arg;

    if (event == WebKitLoadEvent.WEBKIT_LOAD_FINISHED)
    {
        w.priv.ready = 1;
    }
}

void webview_destroy_cb(GtkWidget* widget, void* arg)
{
    writeln("webview_destroy_cb");
    webview* w = cast(webview*) arg;
    webview_terminate(w);
    writeln("destroy DONE");
}

void webview_context_menu_cb(GtkWidget* widget, void* arg)
{

}

void raw_callback(Dhanos_Linux d, immutable(string) js_command)

{
    writeln("raw_callback");

    if (d is null)
        throw new Exception("Dhanos object is null!");
    if (js_command == null)
        throw new Exception("Javascript callback argument can't be null!");
    if (d.callback == null)
        throw new Exception("JS=>D callback can't be null!");

    d.callback(js_command);

}

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

struct dhanos_callback_data
{
    string padding;
    DhanosInterface dhanos;
    void* callback_func;
    string callback_name;
}

extern (C) void custom_callback(WebKitUserContentManager* manager,
        WebKitJavascriptResult* js_result, gpointer user_data)
{

    dhanos_callback_data* callback_data = cast(dhanos_callback_data*) user_data;

    writeln("[Dhanos] custom_callback '" ~ callback_data.callback_name ~ "' BEGIN");

    // get input value from JS function
    JSGlobalContextRef context = webkit_javascript_result_get_global_context(js_result);
    JSValueRef value = webkit_javascript_result_get_value(js_result);
    JSStringRef js = JSValueToStringCopy(context, value, null);
    size_t n = JSStringGetMaximumUTF8CStringSize(js);
    char[] s = new char[n];
    JSStringGetUTF8CString(js, cast(char*) s, n);
    const char* ss = cast(const char*) s;
    immutable(string) js_value = cast(immutable) fromStringz(ss);

    writeln("[Dhanos] custom_callback value: " ~ js_value);

    auto cf = cast(void function(DhanosInterface, immutable(string))) callback_data.callback_func;

    // DhanosInterface dd = *callback_data.dhanos;
    writeln("[Dhanos] custom_callback call");
    //writeln((&callback_data.dhanos.setTitle).ptr);

    cf(callback_data.dhanos, js_value);
    writeln("[Dhanos] custom_callback END");
}

void dhanos_page_loaded(DhanosInterface di, immutable(string) value)
{
    writeln("[Dhanos] loaded webpage JS loaded");

    di.setTitle("dhanos page loaded test name");
}

class Dhanos_Linux : DhanosInterface
{
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

    static immutable(string) checkURL(immutable(string) url)
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



    void setAlwaysOnTop(bool flag)
    {
        gtk_window_set_keep_above(cast(GtkWindow*)data.priv.window, flag);
    }

    void setCallback(immutable(string) callbackName, void* cb)
    {
        import std.conv : to;

        writeln("[Dhanos] setCallback " ~ callbackName ~ " => " ~ to!string(cb));
        callbacks[callbackName] = cb;
        auto callbackNameCString = toStringz(callbackName);
        webkit_user_content_manager_register_script_message_handler(webkitUserContentManager,
                callbackNameCString);

        dhanos_callback_data* dcd = new dhanos_callback_data();
        dcd.callback_func = cb;

        dcd.dhanos = this;

        dcd.callback_name = callbackName;

        g_signal_connect_data(cast(void*) webkitUserContentManager,
                cast(const char*) toStringz("script-message-received::" ~ callbackName),
                cast(void*)&custom_callback, cast(gpointer) dcd, null,
                GConnectFlags.G_CONNECT_AFTER);
        webkit_web_view_run_javascript(cast(WebKitWebView*)(data.priv.webview),
                toStringz("dhanos." ~ callbackName ~ "=function(x){"
                    ~ "window.webkit.messageHandlers." ~ callbackName ~ ".postMessage(x);}"),
                null, null, null);
    }

    void runJavascript(immutable(string) js)
    {
        webkit_web_view_run_javascript(cast(WebKitWebView*)(data.priv.webview),
                toStringz(js), null, null, null);
    }

    void mainLoop()
    {
        import std.stdio : writeln;

        while (!data.priv.should_exit)
        {

            gtk_main_iteration_do(true);
        }

    }

    void setWindowSize(int w,int h)
    {
        gtk_widget_set_size_request(data.priv.window, w, h);
    }

    void setTitle(immutable(string) title)
    {
        gtk_window_set_title(cast(GtkWindow*) data.priv.window, toStringz(title));
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
    //     // g_signal_connect(G_OBJECT(w.priv.webview), "load-changed",
    //     //         G_CALLBACK(webview_load_changed_cb), w);
    //     // gtk_container_add(GTK_CONTAINER(w.priv.scroller), w.priv.webview);

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
    void function(immutable(string)) callback;
    WebKitUserContentManager* webkitUserContentManager;

public:

    void close()
    {
        writeln("[Dhanos] pre-terminate");
        webview_terminate(&data);
        writeln("[Dhanos] post-terminate");
    }

    void function(immutable(string)) getJSCallback()
    {
        return callback;
    }

    void setJSCallback(void function(immutable(string)) cb)
    in(cb != null)
    {
        if (cb == null)
            throw new Exception("D JS input callback is null!");
        this.callback = cb;
    }

    // void noop_callback(immutable(string) value)
    // {
    //         writeln("noop_callback");

    // }

    Object o;

    void setUserObject(Object o)
    {
        this.o = o;
    }

    Object getUserObject()
    {
        return o;
    }

    void init(immutable(string) title, immutable(string) url, int width, int height, bool resizable)
    {
        this.title = title;
        this.url = url;
        this.width = width;
        this.height = height;
        this.resizable = resizable;

        data.title = cast(char*) toStringz(title);
        data.url = cast(char*) toStringz(url);
        data.width = width;
        data.height = height;
        data.resizable = resizable;
        data.dhanos_ptr = this;
        writeln(data.dhanos_ptr);

        if (gtk_init_check(null, null) == false)
        {
            throw new Exception("Can't initialize GTK");
        }

        data.priv.ready = 0;
        data.priv.should_exit = 0;
        data.priv.queue = g_async_queue_new();
        data.priv.window = cast(GtkWidget*) gtk_window_new(GtkWindowType.GTK_WINDOW_TOPLEVEL);

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

        gtk_window_set_title(cast(GtkWindow*) data.priv.window, data.title);


        //gtk_window_set_default_geometry (cast(GtkWindow*)(data.priv.window),   width,   height);
        //gtk_widget_set_size_request(data.priv.window, data.width, data.height);
         //gtk_window_set_default_size(cast(GtkWindow*)(data.priv.window), data.width, data.height);
                                

                //    gtk_window_set_default_size(cast(GtkWindow*)(data.priv.window),
                //     data.width, data.height);              
        if (data.resizable)
        {
            //writeln("a");
            gtk_window_set_default_size(cast(GtkWindow*)(data.priv.window),
                    data.width, data.height);
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
            gtk_widget_set_size_request(data.priv.window, data.width, data.height);     
        }


        gtk_window_set_position(cast(GtkWindow*) data.priv.window, GtkWindowPosition.GTK_WIN_POS_CENTER);

        //gtk_window_unfullscreen(cast(GtkWindow*) data.priv.window);

        gtk_window_set_resizable(cast(GtkWindow*)(data.priv.window), cast(bool) data.resizable);

        // Add scrollbar if needed
        data.priv.scroller = gtk_scrolled_window_new(null, null);
        gtk_container_add(cast(GtkContainer*)(data.priv.window), data.priv.scroller);

        webkitUserContentManager = webkit_user_content_manager_new();
        // webkit_user_content_manager_register_script_message_handler(webkitUserContentManager,
        //         "external");

        // g_signal_connect_data(cast(void*) webkitUserContentManager,
        //         cast(const char*) toStringz("script-message-received::external"),
        //         cast(void*)&external_message_received_cb, cast(void*) this,
        //         null, GConnectFlags.G_CONNECT_AFTER);

        data.priv.webview = webkit_web_view_new_with_user_content_manager(webkitUserContentManager);

        // Load input URL
        webkit_web_view_load_uri(cast(WebKitWebView*)(data.priv.webview),
                toStringz(checkURL(fromStringz(data.url).idup)));
        g_signal_connect_data(cast(void*) data.priv.webview,
                cast(const char*) toStringz("load-changed"), &webview_load_changed_cb,
                cast(void*)&data, null, GConnectFlags.G_CONNECT_AFTER);

        // Add the browser to GTK
        gtk_container_add(cast(GtkContainer*)(data.priv.scroller), data.priv.webview);

        // Webkit settings here
        WebKitSettings* settings = webkit_web_view_get_settings(cast(WebKitWebView*)(data.priv.webview));

        // Allow access to local files to load icons or thumbnails
        webkit_settings_set_allow_file_access_from_file_urls(settings, true);
        webkit_settings_set_allow_universal_access_from_file_urls(settings, true);

        // If we are in debug mode enable developer tools
        debug
        {
            webkit_settings_set_enable_write_console_messages_to_stdout(settings, true);
            webkit_settings_set_enable_developer_extras(settings, true);


        }
        else
        {
            // g_signal_connect_data(data.priv.webview, "context-menu",
            //         &webview_context_menu_cb, null, null,
            //     GConnectFlags.G_CONNECT_AFTER);
        // webkit_web_view_run_javascript(cast(WebKitWebView*)(data.priv.webview),
        //         "document.oncontextmenu = null", null, null, null);

            
        }

        //gtk_window_set_position(cast(GtkWindow*) data.priv.window, GtkWindowPosition.GTK_WIN_POS_CENTER_ALWAYS);

        // Spawn the window
        gtk_widget_show_all(data.priv.window);

        // GtkRequisition requisition;
        // gtk_widget_size_request (data.priv.window, &requisition);

        // writeln(requisition.width);
        // writeln(requisition.height);

         // Create the dhanos object to hold the callbacks
        webkit_web_view_run_javascript(cast(WebKitWebView*)(data.priv.webview),
                "dhanos = {}", null, null, null);

        // Callback when the window [X] is pressed
        g_signal_connect_data(data.priv.window, "destroy", cast(void*)&webview_destroy_cb,
                cast(void*)&data, null, GConnectFlags.G_CONNECT_AFTER);

        //data.external_invoke_cb = cast(webview_external_invoke_cb_t)&raw_callback;

      

           //gtk_window_set_gravity(cast(GtkWindow*) data.priv.window, GdkGravity.GDK_GRAVITY_CENTER);
        // gtk_window_move(cast(GtkWindow*) data.priv.window, gdk_screen_width()/2, gdk_screen_height()/2);
        //  gtk_window_set_position(cast(GtkWindow*) data.priv.window, GtkWindowPosition.GTK_WIN_POS_CENTER);
           //gtk_window_move (cast(GtkWindow*) data.priv.window, 0, 0);

        
        //gtk_window_set_position(cast(GtkWindow*) data.priv.window, GtkWindowPosition.GTK_WIN_POS_CENTER_ALWAYS);


       
      

       
    }

    void setBorder(bool visible)
    {
        gtk_window_set_decorated(cast(GtkWindow*) data.priv.window, visible);
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
