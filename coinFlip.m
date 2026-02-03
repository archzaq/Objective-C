//
//  coinFlip.m
//  
//
//  Created by arch on 2/2/26.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

int main() {
    @autoreleasepool {
      NSApplication *app = [NSApplication sharedApplication];

      NSWindow *window = [[NSWindow alloc]
          initWithContentRect:NSMakeRect(100, 100, 400, 200)
          styleMask:NSWindowStyleMaskTitled | NSWindowStyleMaskClosable
          backing:NSBackingStoreBuffered
          defer:NO];

      [window setTitle:@"Hello"];

      NSTextField *label = [[NSTextField alloc] initWithFrame:NSMakeRect(50, 80, 300, 30)];
      [label setStringValue:@"Hello from Objective-C!"];
      [label setBezeled:NO];
      [label setDrawsBackground:NO];
      [label setEditable:NO];
      [label setSelectable:NO];

      [[window contentView] addSubview:label];
      [window makeKeyAndOrderFront:nil];

      [app run];
    }
    return 0;
}
