//
//  iAdKiller.h
//  iAdKiller
//
//  Created by _X_ on 08.07.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "substrate.h"

static id (*orig_init)(id self, SEL sel);
id my_init(id self, SEL sel) {
	NSLog(@"iAdKiller: init called");
	
	return nil;
}



int (*orig_UIApplicationMain)(int argc, char *argv[], NSString *principalClassName, NSString *delegateClassName);


int my_UIApplicationMain (int argc, char *argv[], NSString *principalClassName, NSString *delegateClassName) {
	
	
	MSHookMessageEx(objc_getClass("ADManager"), @selector(init), (IMP) my_init, (IMP *)&orig_init);
	
	return orig_UIApplicationMain(argc, argv, principalClassName, delegateClassName);
}



__attribute__((constructor)) static void FirewallInitialize() {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSString *currentBundleIdentifier = [[[NSBundle mainBundle] bundleIdentifier] lowercaseString];
	if ([currentBundleIdentifier isEqualToString:@"com.apple.springboard"] != YES ||
		currentBundleIdentifier == nil)
		
	{
		NSLog(@"iAdKiller: hooking into %@", currentBundleIdentifier);
		MSHookFunction((void *) &UIApplicationMain, (void *)&my_UIApplicationMain, (void **) &orig_UIApplicationMain);
		
	}
	
	
	[pool release];
}