module Examples.Minimal;

// import std.path : dirName, buildNormalizedPath, absolutePath, buildPath;
// import DhanosInterface : DhanosInterface;
// import Dhanos : getNewPlatformInstance;

extern (C++,ultralight) abstract class Platform
{
    extern (C++) static Platform instance();

};

// extern (C++) class Config;

// extern (C++,Platform) Platform instance();

int main(string[] args)
{
    // Setup our Platform
    Platform platform = Platform.instance();
    //   platform.set_config(Config());
    //   platform.set_gpu_driver(new GPUDriverD3D(new D3DRenderer()));
    //   platform.set_font_loader(new FontLoaderWin());

    // Create the Renderer
    //Ref<Renderer> renderer = Renderer.Create();

    // Create the View
    //Ref<View> view = renderer.CreateView(800, 600, false);
    //view.LoadHTML("<h1>Hello World!</h1>");

    return 0;
}
