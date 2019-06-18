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
    extern (C) struct GtkWindow;
    //extern (C) GtkWindow* GTK_WINDOW(GtkWidget*);
    //extern (C) GtkWindow* gtk_window_new(int);
    extern (C) void gtk_window_set_title(GtkWindow*, const char*);
    extern (C) void gtk_window_set_default_size(GtkWindow*, int, int);
    extern (C) void gtk_window_set_resizable(GtkWindow*, bool);
    extern (C) void gtk_window_set_decorated(GtkWindow*, bool);

    extern (C) int gtk_main_iteration_do(int);

    extern (C) void gtk_window_fullscreen(GtkWindow*);
    extern (C) void gtk_window_unfullscreen(GtkWindow*);

    enum GtkWindowType
    {
        GTK_WINDOW_TOPLEVEL,
        GTK_WINDOW_POPUP
    };
}
//extern (C) enum GtkWindowType;

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
extern (C) int webview_init(webview* w);
extern (C) int webview_loop(webview* w, bool);
extern (C) int webview_eval(webview* w, const char* js);
extern (C) void webview_exit(webview* w);

alias webview_dispatch_fn = void function(webview* w, void* arg);
extern (C) void webview_dispatch(webview* w, webview_dispatch_fn fn, void* arg);


import std.stdio : writeln;
import std.string : fromStringz;

class Dhanos
{
    // int ready;
    // int should_exit;
    // GAsyncQueue* queue;
    // GtkWidget* window;

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
