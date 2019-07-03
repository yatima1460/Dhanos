


class Dhanos_Linux : Dhanos
{
 void setFullscreen(bool value)
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
    }
}