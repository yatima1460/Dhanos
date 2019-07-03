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

// struct IInternetSecurityManagerVtbl
// {
// 	HRESULT(STDMETHODCALLTYPE *QueryInterface)(IInternetSecurityManager *, REFIID, void **);
// 	ULONG(STDMETHODCALLTYPE *AddRef)(IInternetSecurityManager *);
// 	ULONG(STDMETHODCALLTYPE *Release)(IInternetSecurityManager *);
// 	LPVOID SetSecuritySite;
// 	LPVOID GetSecuritySite;
// 	HRESULT(STDMETHODCALLTYPE *MapUrlToZone)(IInternetSecurityManager *, LPCWSTR, DWORD *, DWORD);
// 	LPVOID GetSecurityId;
// 	LPVOID ProcessUrlAction;
// 	LPVOID QueryCustomPolicy;
// 	LPVOID SetZoneMapping;
// 	LPVOID GetZoneMappings;
// };

// IInternetSecurityManagerVtbl MyInternetSecurityManagerTable = {IS_QueryInterface, IS_AddRef, IS_Release, IS_SetSecuritySite, IS_GetSecuritySite, IS_MapUrlToZone, IS_GetSecurityId, IS_ProcessUrlAction, IS_QueryCustomPolicy, IS_SetZoneMapping, IS_GetZoneMappings};

int EmbedBrowserObject(Dhanos_Windows w) {
  RECT rect;
  IWebBrowser2 *webBrowser2 = null;
  LPCLASSFACTORY pClassFactory = null;
  _IOleClientSiteEx *_iOleClientSiteEx = null;
  IOleObject** browser = cast(IOleObject **)GlobalAlloc(  GMEM_FIXED, (IOleObject *).sizeof + _IOleClientSiteEx.sizeof);
  if (browser == null) {
    goto error;
  }
  w.browser = browser;

  _iOleClientSiteEx = cast(_IOleClientSiteEx *)(browser + 1);
  _iOleClientSiteEx.client.lpVtbl = &MyIOleClientSiteTable;
  _iOleClientSiteEx.inplace.inplace.lpVtbl = &MyIOleInPlaceSiteTable;
  _iOleClientSiteEx.inplace.frame.frame.lpVtbl = &MyIOleInPlaceFrameTable;
  _iOleClientSiteEx.inplace.frame.window = w.hwnd;
  _iOleClientSiteEx.ui.ui.lpVtbl = &MyIDocHostUIHandlerTable;
  _iOleClientSiteEx.external.lpVtbl = &ExternalDispatchTable;
  _iOleClientSiteEx.provider.provider.lpVtbl = &MyServiceProviderTable;
  _iOleClientSiteEx.provider.mgr.mgr.lpVtbl = &MyInternetSecurityManagerTable;

  if (CoGetClassObject(iid_unref(&CLSID_WebBrowser),
                       CLSCTX_INPROC_SERVER | CLSCTX_INPROC_HANDLER, NULL,
                       iid_unref(&IID_IClassFactory),
                       cast(void **)&pClassFactory) != S_OK) {
    goto error;
  }

  if (pClassFactory == NULL) {
    goto error;
  }

  if (pClassFactory.lpVtbl.CreateInstance(pClassFactory, 0,
                                            iid_unref(&IID_IOleObject),
                                            cast(void **)browser) != S_OK) {
    goto error;
  }
  pClassFactory.lpVtbl.Release(pClassFactory);
  if ((*browser).lpVtbl.SetClientSite(
          *browser, cast(IOleClientSite *)_iOleClientSiteEx) != S_OK) {
    goto error;
  }
  (*browser).lpVtbl.SetHostNames(*browser, "My Host Name", 0);

  if (OleSetContainedObject(cast(IUnknown *)(*browser), TRUE) != S_OK) {
    goto error;
  }
  GetClientRect(w.priv.hwnd, &rect);
  if ((*browser).lpVtbl.DoVerb((*browser), OLEIVERB_SHOW, NULL,
                                 cast(IOleClientSite *)_iOleClientSiteEx, -1,
                                 w.priv.hwnd, &rect) != S_OK) {
    goto error;
  }
  if ((*browser).lpVtbl.QueryInterface((*browser),
                                         iid_unref(&IID_IWebBrowser2),
                                         cast(void **)&webBrowser2) != S_OK) {
    goto error;
  }

  webBrowser2.lpVtbl.put_Left(webBrowser2, 0);
  webBrowser2.lpVtbl.put_Top(webBrowser2, 0);
  webBrowser2.lpVtbl.put_Width(webBrowser2, rect.right);
  webBrowser2.lpVtbl.put_Height(webBrowser2, rect.bottom);
  webBrowser2.lpVtbl.Release(webBrowser2);

  return 0;
error:
  UnEmbedBrowserObject(w);
  if (pClassFactory != NULL) {
    pClassFactory.lpVtbl.Release(pClassFactory);
  }
  if (browser != NULL) {
    GlobalFree(browser);
  }
  return -1;
}


// extern (C) int DisplayHTMLPage(webview *w);
// extern (C) int webview_loop(webview *w, int blocking);
import core.stdc.string : memset;

Dhanos_Windows DHANOS_PTR;

extern(Windows) LRESULT wndproc(HWND hwnd, UINT uMsg, WPARAM wParam, LPARAM lParam) 
{
  //struct webview *w = (struct webview *)GetWindowLongPtr(hwnd, GWLP_USERDATA);

  switch (uMsg) {
  case WM_CREATE:
    //w = (struct webview *)((CREATESTRUCT *)lParam)->lpCreateParams;
    DHANOS_PTR.hwnd = hwnd;
    return EmbedBrowserObject(w);
  case WM_DESTROY:
    //UnEmbedBrowserObject(w);
    PostQuitMessage(0);
    return TRUE;
  case WM_SIZE: {
    IWebBrowser2 *webBrowser2;
    IOleObject *browser = *DHANOS_PTR.browser;
    if (browser.lpVtbl.QueryInterface(browser, iid_unref(&IID_IWebBrowser2), cast(void **)&webBrowser2) == S_OK) {
      RECT rect;
      GetClientRect(hwnd, &rect);
      webBrowser2.lpVtbl.put_Width(webBrowser2, rect.right);
      webBrowser2.lpVtbl.put_Height(webBrowser2, rect.bottom);
    }
    return TRUE;
  }
  case WM_WEBVIEW_DISPATCH: {
    webview_dispatch_fn f = cast(webview_dispatch_fn)wParam;
    void *arg = cast(void *)lParam;
    (*f)(w, arg);
    return TRUE;
  }
  }
  return DefWindowProc(hwnd, uMsg, wParam, lParam);
}

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
    private:
    HWND hwnd;
    IOleObject **browser;
    BOOL is_fullscreen;
    DWORD saved_style;
    DWORD saved_ex_style;
    RECT saved_rect;


    bool fullscreen;
   // LONG saved_style;

    string title;
    string url;
    int width;
    int height;
    bool resizable;


    // webview data;

    static const TCHAR *classname = "WebView";

public:
    void init(immutable(string) title, immutable(string) url, int width, int height, bool resizable)
    {
        DHANOS_PTR = this;
        import std.stdio : writeln;
        writeln("Dhanos Windows started");
        // import std.string : toStringz;
        // this.title = cast(char*)toStringz(title);
        // this.url = cast(char*)toStringz(url);
        this.title = title;
        this.url = url;
        this.width = width;
        this.height = height;
        this.resizable = resizable;
        WNDCLASSEX wc;
        HINSTANCE hInstance;
        DWORD style;
        RECT clientRect;
        RECT rect;

        if (webview_fix_ie_compat_mode() < 0) {
            throw new Exception("WebView fix IE compat mode failed");
        }

        hInstance = GetModuleHandle(NULL);
        if (hInstance == NULL) {
            throw new Exception("Module handle is null");
        }
        if (OleInitialize(NULL) != S_OK) {
            throw new Exception("OleInitialize is not S_OK");
        }
        memset(&wc, 0, WNDCLASSEX.sizeof);
        wc.cbSize = WNDCLASSEX.sizeof;
        wc.hInstance = hInstance;
        wc.lpfnWndProc = &wndproc;
        wc.lpszClassName = classname;
        RegisterClassEx(&wc);

        style = WS_OVERLAPPEDWINDOW;
        if (!this.resizable) {
            style = WS_OVERLAPPED | WS_CAPTION | WS_MINIMIZEBOX | WS_SYSMENU;
        }

        rect.left = 0;
        rect.top = 0;
        rect.right = this.width;
        rect.bottom = this.height;
        AdjustWindowRect(&rect, WS_OVERLAPPEDWINDOW, 0);

        GetClientRect(GetDesktopWindow(), &clientRect);
        int left = (clientRect.right / 2) - ((rect.right - rect.left) / 2);
        int top = (clientRect.bottom / 2) - ((rect.bottom - rect.top) / 2);
        rect.right = rect.right - rect.left + left;
        rect.left = left;
        rect.bottom = rect.bottom - rect.top + top;
        rect.top = top;

        this.hwnd =
            CreateWindowEx(0, classname, cast(const(wchar)*)this.title, style, rect.left, rect.top,
                            rect.right - rect.left, rect.bottom - rect.top,
                            HWND_DESKTOP, NULL, hInstance, cast(void *)this);
        if (this.hwnd == null) {
            OleUninitialize();
             throw new Exception("hwnd can't be null");
        }

        //SetWindowLongPtr(this.hwnd, GWLP_USERDATA, cast(void *)this);

        //DisplayHTMLPage(&data);

        SetWindowText(this.hwnd, cast(const(wchar*))this.title);
        ShowWindow(this.hwnd, SW_SHOWDEFAULT);
        UpdateWindow(this.hwnd);
        SetFocus(this.hwnd);
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
        //     saved_style = GetWindowLong(this.hwnd, GWL_STYLE);
        //     this.saved_ex_style = GetWindowLong(this.hwnd, GWL_EXSTYLE);
        //     GetWindowRect(this.hwnd, &this.saved_rect);
        // }
        // fullscreen = !!fullscreen;
        // if (fullscreen)
        // {
        //     MONITORINFO monitor_info;
        //     SetWindowLong(this.hwnd, GWL_STYLE,
        //             saved_style & ~(WS_CAPTION | WS_THICKFRAME));
        //     SetWindowLong(this.hwnd, GWL_EXSTYLE, this.saved_ex_style & ~(
        //             WS_EX_DLGMODALFRAME | WS_EX_WINDOWEDGE | WS_EX_CLIENTEDGE | WS_EX_STATICEDGE));
        //     monitor_info.cbSize = monitor_info.sizeof;
        //     GetMonitorInfo(MonitorFromWindow(this.hwnd,
        //             MONITOR_DEFAULTTONEAREST), &monitor_info);
        //     RECT r;
        //     r.left = monitor_info.rcMonitor.left;
        //     r.top = monitor_info.rcMonitor.top;
        //     r.right = monitor_info.rcMonitor.right;
        //     r.bottom = monitor_info.rcMonitor.bottom;
        //     SetWindowPos(this.hwnd, NULL, r.left, r.top,
        //             r.right - r.left, r.bottom - r.top,
        //             SWP_NOZORDER | SWP_NOACTIVATE | SWP_FRAMECHANGED);
        // }
        // else
        // {
        //     SetWindowLong(this.hwnd, GWL_STYLE, saved_style);
        //     SetWindowLong(this.hwnd, GWL_EXSTYLE, this.saved_ex_style);
        //     SetWindowPos(this.hwnd, NULL, this.saved_rect.left,
        //             this.saved_rect.top, this.saved_rect.right - this.saved_rect.left,
        //             this.saved_rect.bottom - this.saved_rect.top,
        //             SWP_NOZORDER | SWP_NOACTIVATE | SWP_FRAMECHANGED);
        // }
        
      
       
        
    }
}