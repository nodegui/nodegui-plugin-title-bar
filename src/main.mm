#include <Cocoa/Cocoa.h>
#include <QWindow>
#include <napi.h>
#include <nodegui/QtWidgets/QMainWindow/qmainwindow_wrap.h>

QObject *qObject = new QObject();

bool isInFullScreenMode (NSWindow *window)
{
	return (([window styleMask] & NSFullScreenWindowMask) == NSFullScreenWindowMask);
}

Napi::Value SetTitleBarStyle(const Napi::CallbackInfo &info)
{
	Napi::Env env = info.Env();
	Napi::HandleScope scope(env);

	Napi::Object windowObject = info[0].As<Napi::Object>();
	Napi::String styleArgument = info[1].As<Napi::String>();

	std::string style = styleArgument.Utf8Value();

	QMainWindowWrap *windowWrap = Napi::ObjectWrap<QMainWindowWrap>::Unwrap(windowObject);
	QMainWindow *mainWindow = windowWrap->getInternalInstance();
	QWindow *windowHandle = mainWindow->windowHandle();
	NSView *view = (NSView *) mainWindow->winId();
	NSWindow *window = [view window];
	NSToolbar *toolbar = [[NSToolbar alloc] initWithIdentifier:@"titlebarStylingToolbar"];
	[toolbar setShowsBaselineSeparator:NO];

	// Whenever full screen mode is exited Qt applies a new styleMask
	auto functor = [=] ()
	{
		if (style.compare("hiddenInset") == 0)
		{
			if (isInFullScreenMode(window))
			{
				[window setToolbar:NULL];
			}
			else
			{
				[window setToolbar:toolbar];
			}
		}
		window.styleMask |= NSWindowStyleMaskFullSizeContentView;
	};

	if (style.compare("hidden") == 0)
	{
		[window setTitlebarAppearsTransparent:YES];
		window.titleVisibility = NSWindowTitleHidden;
		[window setToolbar:NULL];
		window.styleMask |= NSWindowStyleMaskFullSizeContentView;
		QObject::disconnect(windowHandle, &QWindow::windowStateChanged, qObject, NULL);
		QObject::connect(windowHandle, &QWindow::windowStateChanged, qObject, functor);
	}
	else if (style.compare("hiddenInset") == 0)
	{
		[window setTitlebarAppearsTransparent:YES];
		window.titleVisibility = NSWindowTitleHidden;
		[window setToolbar:toolbar];
		window.styleMask |= NSWindowStyleMaskFullSizeContentView;
		QObject::disconnect(windowHandle, &QWindow::windowStateChanged, qObject, NULL);
		QObject::connect(windowHandle, &QWindow::windowStateChanged, qObject, functor);
	}
	else // default
	{
		[window setTitlebarAppearsTransparent:NO];
		window.titleVisibility = NSWindowTitleVisible;
		[window setToolbar:NULL];
		window.styleMask ^= NSWindowStyleMaskFullSizeContentView;
		QObject::disconnect(windowHandle, &QWindow::windowStateChanged, qObject, NULL);
	}

	return env.Null();
}

Napi::Object Main(Napi::Env env, Napi::Object exports)
{
	exports.Set(Napi::String::New(env, "setTitleBarStyle"), Napi::Function::New(env, SetTitleBarStyle));
	return exports;
}

NODE_API_MODULE(NODE_GYP_MODULE_NAME, Main)
