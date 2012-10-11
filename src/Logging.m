//
//  Logging.m
//  onesite-ios-sdk
//
//  Created by Janell Pechacek on 9/27/12.
//  Copyright (c) 2012 ONESite. All rights reserved.
//

#import "Logging.h"

void _DebugLog(const char *file, int lineNumber, const char *funcName, NSString *format,...) {
	va_list ap;
	
	va_start (ap, format);
	if (![format hasSuffix: @"\n"]) {
		format = [format stringByAppendingString: @"\n"];
	}
	NSString *body =  [[NSString alloc] initWithFormat: format arguments: ap];
	va_end (ap);
	const char *threadName = [[[NSThread currentThread] name] UTF8String];
	NSString *fileName=[[NSString stringWithUTF8String:file] lastPathComponent];
	if (threadName) {
		fprintf(stderr,"%s/%s (%s:%d) %s",threadName,funcName,[fileName UTF8String],lineNumber,[body UTF8String]);
	} else {
		fprintf(stderr,"%p/%s (%s:%d) %s",[NSThread currentThread],funcName,[fileName UTF8String],lineNumber,[body UTF8String]);
	}
	[body release];
}
