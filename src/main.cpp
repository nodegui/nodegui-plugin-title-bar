#include <napi.h>

Napi::Value SetTitleBarStyle(const Napi::CallbackInfo &info)
{
	Napi::Env env = info.Env();

	return env.Null();
}

Napi::Object Main(Napi::Env env, Napi::Object exports)
{
	exports.Set(Napi::String::New(env, "setTitleBarStyle"), Napi::Function::New(env, SetTitleBarStyle));
	return exports;
}

NODE_API_MODULE(NODE_GYP_MODULE_NAME, Main)
