#include <Cocoa/Cocoa.h>
#include <QWindow>
#include <napi.h>
#include <nodegui/QtWidgets/QMainWindow/qmainwindow_wrap.h>

@interface TBWindowDelegate : NSObject <NSWindowDelegate>

@property (strong, nonatomic) NSObject <NSWindowDelegate> *delegate;

- (instancetype)initWithOtherDelegate:(NSObject <NSWindowDelegate> *)delegate;

@end

@implementation TBWindowDelegate

- (instancetype)initWithOtherDelegate:(NSObject <NSWindowDelegate> *)delegate
{
	self = [super init];
    if (self) {
        _delegate = delegate;
    }
    return self;
}


- (NSApplicationPresentationOptions)window:(NSWindow *)window
      willUseFullScreenPresentationOptions:(NSApplicationPresentationOptions)proposedOptions
{
	return (NSApplicationPresentationAutoHideToolbar | NSApplicationPresentationFullScreen | NSApplicationPresentationAutoHideMenuBar);
}

// https://github.com/qt/qtbase/blob/dev/src/plugins/platforms/cocoa/qnswindowdelegate.mm
- (BOOL)windowShouldClose:(NSWindow *)window
{
	return [_delegate windowShouldClose:window];
}

- (NSRect)windowWillUseStandardFrame:(NSWindow *)window defaultFrame:(NSRect)proposedFrame
{
    return [_delegate windowWillUseStandardFrame:window defaultFrame:proposedFrame];
}

- (BOOL)window:(NSWindow *)window shouldPopUpDocumentPathMenu:(NSMenu *)menu
{
    return [_delegate window:window shouldPopUpDocumentPathMenu:menu];
}

- (BOOL)window:(NSWindow *)window shouldDragDocumentWithEvent:(NSEvent *)event from:(NSPoint)dragImageLocation withPasteboard:(NSPasteboard *)pasteboard
{
	return [_delegate window:window shouldDragDocumentWithEvent:event from:dragImageLocation withPasteboard:pasteboard];
}
// #endregion
@end

QObject *qObject = new QObject();

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
		window.styleMask |= NSWindowStyleMaskFullSizeContentView;
	};

	if (style.compare("hidden") == 0)
	{
		[window setTitlebarAppearsTransparent:YES];
		window.titleVisibility = NSWindowTitleHidden;
		if ([window.delegate isKindOfClass:[TBWindowDelegate class]])
		{
			window.delegate = ((TBWindowDelegate *) window.delegate).delegate;
		}
		[window setToolbar:NULL];
		window.styleMask |= NSWindowStyleMaskFullSizeContentView;
		QObject::disconnect(windowHandle, &QWindow::windowStateChanged, qObject, NULL);
		QObject::connect(windowHandle, &QWindow::windowStateChanged, qObject, functor);
	}
	else if (style.compare("hiddenInset") == 0)
	{
		[window setTitlebarAppearsTransparent:YES];
		window.titleVisibility = NSWindowTitleHidden;
		if (![window.delegate isKindOfClass:[TBWindowDelegate class]])
		{
			window.delegate = [[TBWindowDelegate alloc] initWithOtherDelegate:window.delegate];
		}
		[window setToolbar:toolbar];
		window.styleMask |= NSWindowStyleMaskFullSizeContentView;
		QObject::disconnect(windowHandle, &QWindow::windowStateChanged, qObject, NULL);
		QObject::connect(windowHandle, &QWindow::windowStateChanged, qObject, functor);
	}
	else // default
	{
		[window setTitlebarAppearsTransparent:NO];
		window.titleVisibility = NSWindowTitleVisible;
		if ([window.delegate isKindOfClass:[TBWindowDelegate class]])
		{
			window.delegate = ((TBWindowDelegate *) window.delegate).delegate;
		}
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
