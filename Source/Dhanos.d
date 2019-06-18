module Dhanos;

import std.string : toStringz;

version (linux)
{

    // GLIB GAsyncQueue
    extern (C) struct GAsyncQueue;
    extern (C) GAsyncQueue* g_async_queue_new();

    // GTK general
    extern (C) int gtk_init_check(int* argc, char*** argv);

    // GTK widget
    extern (C) struct GtkWidget;
    extern (C) void gtk_widget_set_size_request(GtkWidget*, int, int);
    extern (C) void gtk_widget_show_all(GtkWidget*);

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
    extern (C) void gtk_window_set_resizable(GtkWindow*, bool);
    extern (C) void gtk_window_set_decorated(GtkWindow*, bool);
    extern (C) void gtk_window_fullscreen(GtkWindow*);
    extern (C) void gtk_window_unfullscreen(GtkWindow*);
    extern (C) void gtk_window_set_position(GtkWindow*, GtkWindowPosition);

   enum GConnectFlags
   {
       G_CONNECT_AFTER,
       G_CONNECT_SWAPPED
   };

    extern (C) void g_signal_connect_data (void* instance, const char* detailed_signal, void* c_handler, void* data, void* destroy_data, GConnectFlags connect_flags);
    alias g_signal_connect = g_signal_connect_data;
    

    extern (C) struct GtkAdjustment;
    extern (C) GtkWidget *
gtk_scrolled_window_new (GtkAdjustment *hadjustment,
                         GtkAdjustment *vadjustment);

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
    extern (C) void webkit_settings_set_enable_developer_extras(
            WebKitSettings* settings, bool enabled);
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
}
// extern (C) enum GtkWindowType;

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

alias webview_external_invoke_cb_t = void function(webview* w, const char* arg);

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
};

//extern (C) int webview(const char* title, const char* url, int width, int height, int resizable);
// extern (C) int webview_init(webview* w);
// extern (C) int webview_loop(webview* w, bool);
extern (C) int webview_eval(webview* w, const char* js);
extern (C) void webview_exit(webview* w);

alias webview_dispatch_fn = void function(webview* w, void* arg);
extern (C) void webview_dispatch(webview* w, webview_dispatch_fn fn, void* arg);

import std.stdio : writeln;
import std.string : fromStringz;

void webview_destroy_cb(GtkWidget* widget, void* arg)
{
    webview* w = cast(webview*) arg;
    version (linux)
    {
        w.priv.should_exit = 1;
    }
}

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
extern (C) JSStringRef JSValueToStringCopy(JSGlobalContextRef,JSValueRef,void*);
extern (C) size_t  JSStringGetMaximumUTF8CStringSize(JSStringRef);

extern (C) JSGlobalContextRef webkit_javascript_result_get_global_context(
        WebKitJavascriptResult* js_result);

 extern (C)        JSValueRef
webkit_javascript_result_get_value (WebKitJavascriptResult *js_result);

extern (C) void JSStringGetUTF8CString(JSStringRef,char*,size_t);

extern (C) void JSStringRelease(JSStringRef);

void external_message_received_cb(WebKitUserContentManager* m, WebKitJavascriptResult* r, void* arg)
{
  
    webview * w = cast(webview *) arg;
    if (w.external_invoke_cb == null)
    {
        return;
    }
    JSGlobalContextRef context = webkit_javascript_result_get_global_context(r);
    JSValueRef value = webkit_javascript_result_get_value(r);
    JSStringRef js = JSValueToStringCopy(context, value, null);
    size_t n = JSStringGetMaximumUTF8CStringSize(js);
    // char* s = g_new(char, n);
    char[] s = new char[n];
    JSStringGetUTF8CString(js, cast(char*)s, n);
     w.external_invoke_cb(w,  cast(char*)s);
     JSStringRelease(js);
    // g_free(s);
}


void webview_load_changed_cb(WebKitWebView* wwv, WebKitLoadEvent event, void* arg)
{
    webview* w = cast(webview*)arg;
    
    if (event == WebKitLoadEvent.WEBKIT_LOAD_FINISHED)
    {
        w.priv.ready = 1;
    }
}


class Dhanos
{
    // int ready;
    // int should_exit;
    // GAsyncQueue* queue;
    // GtkWidget* window;

    static immutable(string) DEFAULT_URL = "data:text/"                          ~
    "html,%3C%21DOCTYPE%20html%3E%0A%3Chtml%20lang=%22en%22%3E%0A%3Chead%3E%"    ~
    "3Cmeta%20charset=%22utf-8%22%3E%3Cmeta%20http-equiv=%22X-UA-Compatible%22%" ~
    "20content=%22IE=edge%22%3E%3C%2Fhead%3E%0A%3Cbody%3E%3Cdiv%20id=%22app%22%" ~
    "3E%3C%2Fdiv%3E%3Cscript%20type=%22text%2Fjavascript%22%3E%3C%2Fscript%3E%"  ~
    "3C%2Fbody%3E%0A%3C%2Fhtml%3E";

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

    void setFullscreen(bool fullscreen)
    {
        version (linux)
        {
            if (fullscreen)
            {
                gtk_window_fullscreen(cast(GtkWindow*) data.priv.window);
            }
            else
            {
                gtk_window_unfullscreen(cast(GtkWindow*) data.priv.window);
            }
        }
        version (Windows)
        {
            if (data.priv.is_fullscreen == !!fullscreen)
            {
                return;
            }
            if (data.priv.is_fullscreen == 0)
            {
                data.priv.saved_style = GetWindowLong(data.priv.hwnd, GWL_STYLE);
                data.priv.saved_ex_style = GetWindowLong(data.priv.hwnd, GWL_EXSTYLE);
                GetWindowRect(data.priv.hwnd, &data.priv.saved_rect);
            }
            data.priv.is_fullscreen = !!fullscreen;
            if (fullscreen)
            {
                MONITORINFO monitor_info;
                SetWindowLong(data.priv.hwnd, GWL_STYLE,
                        data.priv.saved_style & ~(WS_CAPTION | WS_THICKFRAME));
                SetWindowLong(data.priv.hwnd, GWL_EXSTYLE, data.priv.saved_ex_style & ~(
                        WS_EX_DLGMODALFRAME | WS_EX_WINDOWEDGE | WS_EX_CLIENTEDGE | WS_EX_STATICEDGE));
                monitor_info.cbSize = sizeof(monitor_info);
                GetMonitorInfo(MonitorFromWindow(data.priv.hwnd,
                        MONITOR_DEFAULTTONEAREST), &monitor_info);
                RECT r;
                r.left = monitor_info.rcMonitor.left;
                r.top = monitor_info.rcMonitor.top;
                r.right = monitor_info.rcMonitor.right;
                r.bottom = monitor_info.rcMonitor.bottom;
                SetWindowPos(data.priv.hwnd, NULL, r.left, r.top,
                        r.right - r.left, r.bottom - r.top,
                        SWP_NOZORDER | SWP_NOACTIVATE | SWP_FRAMECHANGED);
            }
            else
            {
                SetWindowLong(data.priv.hwnd, GWL_STYLE, data.priv.saved_style);
                SetWindowLong(data.priv.hwnd, GWL_EXSTYLE, data.priv.saved_ex_style);
                SetWindowPos(data.priv.hwnd, NULL, data.priv.saved_rect.left,
                        data.priv.saved_rect.top, data.priv.saved_rect.right - data.priv.saved_rect.left,
                        data.priv.saved_rect.bottom - data.priv.saved_rect.top,
                        SWP_NOZORDER | SWP_NOACTIVATE | SWP_FRAMECHANGED);
            }
        }
        version (OSX)
        {
            ulong windowStyleMask = cast(ulong) objc_msgSend(data.priv.window,
                    sel_registerName("styleMask"));
            immutable(int) b = (((windowStyleMask & NSWindowStyleMaskFullScreen) == NSWindowStyleMaskFullScreen)
                    ? 1 : 0);
            if (b != fullscreen)
            {
                objc_msgSend(data.priv.window, sel_registerName("toggleFullScreen:"), NULL);
            }
        }
    }

    void mainLoop()
    {
        import std.stdio : writeln;

        // version (GTK)
        // {
        // while (gtk_main_iteration_do(true) == 1)
        // {
        // }
        // }

        //         while (webview_loop(&w, true) == 0) {
        //             }
        //   writeln("loop done");
        //         webview_exit(&w);
        //         writeln("exit done");
        //         import core.stdc.stdlib : exit;
        //         exit(0);
        version (linux)
        {
            while (!data.priv.should_exit)
            {
                gtk_main_iteration_do(true);
            }
        }

        // while (webview_loop(&data, 1) == 0)
        // {

        // }

        //webview_exit(&data);

    }

    void setTitle(immutable(string) title)
    {
        version (linux)
        {
            gtk_window_set_title(cast(GtkWindow*) data.priv.window, toStringz(title));
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

public:
void raw_callback(webview* wv, const char* arg)
in(wv != null)
in(arg != null)
    {
        if (wv == null)
            throw new Exception("Webview in JS=>D raw callback is null!");
        if (arg == null)
            throw new Exception("Javascript callback argument can't be null!");
        if (this.callback == null)
            throw new Exception("JS=>D callback can't be null!");

        immutable(string) s = cast(immutable(string)) fromStringz(cast(char*) arg);
        this.callback(s);
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

    int webview_init(webview* w)
    {
        if (gtk_init_check(null, null) == false)
        {
            return -1;
        }

        w.priv.ready = 0;
        w.priv.should_exit = 0;
        w.priv.queue = g_async_queue_new();
        w.priv.window = cast(GtkWidget*) gtk_window_new(GtkWindowType.GTK_WINDOW_TOPLEVEL);
        gtk_window_set_title(cast(GtkWindow*)w.priv.window, w.title);

        if (w.resizable)
        {
            gtk_window_set_default_size(cast(GtkWindow*)(w.priv.window), w.width, w.height);
        }
        else
        {
            gtk_widget_set_size_request(w.priv.window, w.width, w.height);
        }
        gtk_window_set_resizable(cast(GtkWindow*)(w.priv.window), !!w.resizable);
        gtk_window_set_position(cast(GtkWindow*)(w.priv.window), GtkWindowPosition.GTK_WIN_POS_CENTER);

        w.priv.scroller = gtk_scrolled_window_new(null, null);
        gtk_container_add(cast(GtkContainer*)(w.priv.window), w.priv.scroller);

        WebKitUserContentManager* m = webkit_user_content_manager_new();
        webkit_user_content_manager_register_script_message_handler(m, "external");
        g_signal_connect(cast(void*)m, cast(const char*)toStringz("script-message-received::external"), cast(void*)&external_message_received_cb, cast(void*)w,null,GConnectFlags.G_CONNECT_AFTER);

        w.priv.webview = webkit_web_view_new_with_user_content_manager(m);
        webkit_web_view_load_uri(cast(WebKitWebView*)(w.priv.webview), toStringz(checkURL(fromStringz(w.url).idup)));
        g_signal_connect(cast(void*)w.priv.webview, cast(const char*)toStringz("load-changed"), &webview_load_changed_cb, cast(void*)w,null,GConnectFlags.G_CONNECT_AFTER);
        gtk_container_add(cast(GtkContainer*)(w.priv.scroller), w.priv.webview);

        debug
        {
            WebKitSettings* settings = webkit_web_view_get_settings(cast(WebKitWebView*)(w.priv.webview));
            webkit_settings_set_enable_write_console_messages_to_stdout(settings, true);
            webkit_settings_set_enable_developer_extras(settings, true);
        }
        else
        {
            g_signal_connect(G_OBJECT(w.priv.webview), "context-menu",
                    G_CALLBACK(webview_context_menu_cb), w);
        }

        gtk_widget_show_all(w.priv.window);

        webkit_web_view_run_javascript(cast(WebKitWebView*)(w.priv.webview),
                "window.external={invoke:function(x){" ~ "window.webkit.messageHandlers.external.postMessage(x);}}",
                null, null, null);

        auto d = toStringz("destroy");
        g_signal_connect(w.priv.window, cast(char*)d, cast(void*)&webview_destroy_cb, cast(void*)w,null,GConnectFlags.G_CONNECT_AFTER);
        return 0;
    }

    this(immutable(string) title, immutable(string) url, int width, int height, bool resizable)
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

        int r = webview_init(&data);
        if (r != 0)
        {
            throw new Exception("Error starting webview");
        }

        auto d = &this.raw_callback;
        data.external_invoke_cb = cast(void function(webview* w, const(char*) arg)) d.ptr;

        //auto d = &noop_callback;
        //this.callback = d.funcptr;
    }

    void setBorder(bool visible)
    {
        version (linux)
        {
            gtk_window_set_decorated(cast(GtkWindow*) data.priv.window, visible);
        }
        version (Windows)
        {

        }
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
