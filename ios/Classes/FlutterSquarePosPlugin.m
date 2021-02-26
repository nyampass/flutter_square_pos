#import "FlutterSquarePosPlugin.h"
#if __has_include(<flutter_square_pos/flutter_square_pos-Swift.h>)
#import <flutter_square_pos/flutter_square_pos-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_square_pos-Swift.h"
#endif

@implementation FlutterSquarePosPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterSquarePosPlugin registerWithRegistrar:registrar];
}
@end
