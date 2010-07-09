//Copyright (c) 2010, Yllier
//All rights reserved.
//
//Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//Neither the name of the <ORGANIZATION> nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
//THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import <Foundation/Foundation.h>
#import "substrate.h"

static id (*orig_init)(id self, SEL sel);
id my_init(id self, SEL sel) {
	
	NSLog(@"iAdKiller: init called");
	
	return nil;
}



static int (*orig_UIApplicationMain)(int argc, char *argv[], NSString *principalClassName, NSString *delegateClassName);
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