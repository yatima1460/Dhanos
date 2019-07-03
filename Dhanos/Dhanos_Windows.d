import DhanosInterface : DhanosInterface;

import core.sys.windows.windows;


// struct webview_priv {
//   HWND hwnd;
//   IOleObject **browser;
//   BOOL is_fullscreen;
//   DWORD saved_style;
//   DWORD saved_ex_style;
//   RECT saved_rect;
// };

// alias webview_external_invoke_cb_t = void function(webview *w, const char *arg);

// struct webview {
//   char *url;
//   char *title;
//   int width;
//   int height;
//   int resizable;
//   int _debug;
//   webview_external_invoke_cb_t external_invoke_cb;
//   webview_priv priv;
//   void *userdata;
// };

// extern (Windows) void ZeroMemory(PVOID Destination,SIZE_T Length);

// extern (Windows) LRESULT wndproc(HWND hwnd, UINT uMsg, WPARAM wParam, LPARAM lParam) nothrow;

// extern (C) int DisplayHTMLPage(webview *w);
// extern (C) int webview_loop(webview *w, int blocking);



extern (Windows) int webview_fix_ie_compat_mode() 
{
  string WEBVIEW_KEY_FEATURE_BROWSER_EMULATION = "Software\\Microsoft\\Internet Explorer\\Main\\FeatureControl\\FEATURE_BROWSER_EMULATION";
  HKEY hKey;
  DWORD ie_version = 11000;
  TCHAR[MAX_PATH + 1] appname;
  TCHAR *p;
  if (GetModuleFileName(NULL, &appname[0], MAX_PATH + 1) == 0) {
    return -1;
  }
  
  for (p = &appname[lstrlen(&appname[0]) - 1]; p != &appname[0] && *p != '\\'; p--) {
  }
  p++;
  import std.utf : toUTF16z;
  if (RegCreateKey(HKEY_CURRENT_USER, WEBVIEW_KEY_FEATURE_BROWSER_EMULATION.toUTF16z,
                   &hKey) != ERROR_SUCCESS) {
    return -1;
  }
  if (RegSetValueEx(hKey, p, 0, REG_DWORD, cast(BYTE *)&ie_version,
                    ie_version.sizeof) != ERROR_SUCCESS) {
    RegCloseKey(hKey);
    return -1;
  }
  RegCloseKey(hKey);
  return 0;
}


class Dhanos_Windows : DhanosInterface
{
    bool fullscreen;
    LONG saved_style;
    // webview data;

    static const TCHAR *classname = "WebView";


    void init(immutable(string) title, immutable(string) url, int width, int height, bool resizable)
    {
        import std.stdio : writeln;
        writeln("Dhanos Windows started");
        // import std.string : toStringz;
        // data.title = cast(char*)toStringz(title);
        // data.url = cast(char*)toStringz(url);
        // data.width = width;
        // data.height = height;
        // data.resizable = resizable;
        // WNDCLASSEX wc;
        // HINSTANCE hInstance;
        // DWORD style;
        // RECT clientRect;
        // RECT rect;

        if (webview_fix_ie_compat_mode() < 0) {
            throw new Exception("WebView fix IE compat mode failed");
        }

        // hInstance = GetModuleHandle(NULL);
        // if (hInstance == NULL) {
        //     throw new Exception("Module handle is null");
        // }
        // if (OleInitialize(NULL) != S_OK) {
        //     throw new Exception("OleInitialize is not S_OK");
        // }
        // ZeroMemory(&wc, WNDCLASSEX.sizeof);
        // wc.cbSize = WNDCLASSEX.sizeof;
        // wc.hInstance = hInstance;
        // wc.lpfnWndProc = &wndproc;
        // wc.lpszClassName = classname;
        // RegisterClassEx(&wc);

        // style = WS_OVERLAPPEDWINDOW;
        // if (!data.resizable) {
        //     style = WS_OVERLAPPED | WS_CAPTION | WS_MINIMIZEBOX | WS_SYSMENU;
        // }

        // rect.left = 0;
        // rect.top = 0;
        // rect.right = data.width;
        // rect.bottom = data.height;
        // AdjustWindowRect(&rect, WS_OVERLAPPEDWINDOW, 0);

        // GetClientRect(GetDesktopWindow(), &clientRect);
        // int left = (clientRect.right / 2) - ((rect.right - rect.left) / 2);
        // int top = (clientRect.bottom / 2) - ((rect.bottom - rect.top) / 2);
        // rect.right = rect.right - rect.left + left;
        // rect.left = left;
        // rect.bottom = rect.bottom - rect.top + top;
        // rect.top = top;

        // data.priv.hwnd =
        //     CreateWindowEx(0, classname, cast(const(wchar)*)data.title, style, rect.left, rect.top,
        //                     rect.right - rect.left, rect.bottom - rect.top,
        //                     HWND_DESKTOP, NULL, hInstance, cast(void *)&data);
        // if (data.priv.hwnd == null) {
        //     OleUninitialize();
        //      throw new Exception("hwnd can't be null");
        // }

        // SetWindowLongPtr(data.priv.hwnd, GWLP_USERDATA, cast(LONG_PTR)&data);

        // DisplayHTMLPage(&data);

        // SetWindowText(data.priv.hwnd, cast(const(wchar*))data.title);
        // ShowWindow(data.priv.hwnd, SW_SHOWDEFAULT);
        // UpdateWindow(data.priv.hwnd);
        // SetFocus(data.priv.hwnd);
    }

    void mainLoop()
    {
        // while (webview_loop(&data, 1) == 0) {
        // }
    }


    void setFullscreen(bool value)
    {
        // if (fullscreen == !!fullscreen)
        // {
        //     return;
        // }
        // if (fullscreen == 0)
        // {
        //     saved_style = GetWindowLong(data.priv.hwnd, GWL_STYLE);
        //     data.priv.saved_ex_style = GetWindowLong(data.priv.hwnd, GWL_EXSTYLE);
        //     GetWindowRect(data.priv.hwnd, &data.priv.saved_rect);
        // }
        // fullscreen = !!fullscreen;
        // if (fullscreen)
        // {
        //     MONITORINFO monitor_info;
        //     SetWindowLong(data.priv.hwnd, GWL_STYLE,
        //             saved_style & ~(WS_CAPTION | WS_THICKFRAME));
        //     SetWindowLong(data.priv.hwnd, GWL_EXSTYLE, data.priv.saved_ex_style & ~(
        //             WS_EX_DLGMODALFRAME | WS_EX_WINDOWEDGE | WS_EX_CLIENTEDGE | WS_EX_STATICEDGE));
        //     monitor_info.cbSize = monitor_info.sizeof;
        //     GetMonitorInfo(MonitorFromWindow(data.priv.hwnd,
        //             MONITOR_DEFAULTTONEAREST), &monitor_info);
        //     RECT r;
        //     r.left = monitor_info.rcMonitor.left;
        //     r.top = monitor_info.rcMonitor.top;
        //     r.right = monitor_info.rcMonitor.right;
        //     r.bottom = monitor_info.rcMonitor.bottom;
        //     SetWindowPos(data.priv.hwnd, NULL, r.left, r.top,
        //             r.right - r.left, r.bottom - r.top,
        //             SWP_NOZORDER | SWP_NOACTIVATE | SWP_FRAMECHANGED);
        // }
        // else
        // {
        //     SetWindowLong(data.priv.hwnd, GWL_STYLE, saved_style);
        //     SetWindowLong(data.priv.hwnd, GWL_EXSTYLE, data.priv.saved_ex_style);
        //     SetWindowPos(data.priv.hwnd, NULL, data.priv.saved_rect.left,
        //             data.priv.saved_rect.top, data.priv.saved_rect.right - data.priv.saved_rect.left,
        //             data.priv.saved_rect.bottom - data.priv.saved_rect.top,
        //             SWP_NOZORDER | SWP_NOACTIVATE | SWP_FRAMECHANGED);
        // }
        
      
       
        
    }
}