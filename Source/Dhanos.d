module Dhanos;

import std.string : toStringz;

extern (C) int webview(const char* title, const char* url, int width, int height, int resizable);

extern (C) int gtk_init_check(int,void*);

extern (C) struct GAsyncQueue; 
extern (C) GAsyncQueue* g_async_queue_new();

//extern (C) GtkWindow* GTK_WINDOW(GtkWidget*);
extern (C) struct GtkWidget; 
extern (C) void gtk_widget_set_size_request(GtkWidget*,int,int);
extern (C) void gtk_widget_show_all(GtkWidget*);

extern (C) struct GtkWindow;
extern (C) GtkWidget* gtk_window_new(int);
extern (C) void gtk_window_set_title(GtkWidget*, const char*);
extern (C) void gtk_window_set_default_size(GtkWidget*,int,int);
extern (C) void gtk_window_set_resizable(GtkWidget*,int);

extern (C) int gtk_main_iteration_do(int);
//extern (C) enum GtkWindowType;




enum GtkWindowType
{
  GTK_WINDOW_TOPLEVEL,
  GTK_WINDOW_POPUP
};

class Dhanos
{
    int ready;
    int should_exit;
    GAsyncQueue * queue;
    GtkWidget * window;


    void mainLoop()
    {
        gtk_main_iteration_do(true);
    }

    this(immutable(string) title, int width, int height, bool resizable)
    {
        
        if (gtk_init_check(0, null) == false)
        {
            throw new Exception("GTK not initialized");
        }

        ready = 0;
        should_exit = 0;
        queue = g_async_queue_new();
        window = gtk_window_new(GtkWindowType.GTK_WINDOW_TOPLEVEL);
        gtk_window_set_title(window, toStringz(title));

        if (resizable)
        {
            gtk_window_set_default_size(window, width, height);
        }
        else
        {
            gtk_widget_set_size_request(window, width, height);
        }

        gtk_window_set_resizable(window, resizable);
        //gtk_window_set_position(window, GTK_WIN_POS_CENTER);

        // w.priv.scroller = gtk_scrolled_window_new(NULL, NULL);
        // gtk_container_add(GTK_CONTAINER(w.priv.window), w.priv.scroller);

        // WebKitUserContentManager* m = webkit_user_content_manager_new();
        // webkit_user_content_manager_register_script_message_handler(m, "external");
        // g_signal_connect(m, "script-message-received::external",
        //         G_CALLBACK(external_message_received_cb), w);

        // w.priv.webview = webkit_web_view_new_with_user_content_manager(m);
        // webkit_web_view_load_uri(WEBKIT_WEB_VIEW(w.priv.webview), webview_check_url(w.url));
        // g_signal_connect(G_OBJECT(w.priv.webview), "load-changed",
        //         G_CALLBACK(webview_load_changed_cb), w);
        // gtk_container_add(GTK_CONTAINER(w.priv.scroller), w.priv.webview);

        // debug
        // {
        //     WebKitSettings * settings = webkit_web_view_get_settings(
        //             WEBKIT_WEB_VIEW(w.priv.webview));
        //     webkit_settings_set_enable_write_console_messages_to_stdout(settings, true);
        //     webkit_settings_set_enable_developer_extras(settings, true);
        // }
        // else
        // {
        //     g_signal_connect(G_OBJECT(w.priv.webview), "context-menu",
        //             G_CALLBACK(webview_context_menu_cb), w);
        // }

         gtk_widget_show_all(window);

        // webkit_web_view_run_javascript(WEBKIT_WEB_VIEW(w.priv.webview),
        //         "window.external={invoke:function(x){"~"window.webkit.messageHandlers.external.postMessage(x);}}",
        //         NULL, NULL, NULL);

        // g_signal_connect(G_OBJECT(w.priv.window), "destroy",
        //         G_CALLBACK(webview_destroy_cb), w);
        // return 0;
    }

    static int launch(immutable(string) title, immutable(string) url, int width,
            int height, bool resizable)
    {
        return webview(toStringz(title), toStringz(url), width, height, cast(int) resizable);
    }
}
