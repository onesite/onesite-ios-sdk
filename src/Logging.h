//
//  Logging.h
//  onesite-ios-sdk
//
//  Created by Janell Pechacek on 9/27/12.
//  Copyright (c) 2012 ONESite. All rights reserved.
//

#import <Foundation/Foundation.h>

#define __LOGFUNCTION(s, ...) NSLog(@"%s : %@",__FUNCTION__,[NSString stringWithFormat:(s), ##__VA_ARGS__])

#ifdef DEBUG

#define DELOG(...) __LOGFUNCTION(__VA_ARGS__)
#define LLOG(args...) _DebugLog(__FILE__,__LINE__,__PRETTY_FUNCTION__,args);
#define DELERT(args...) _Alert(args)

#else

#define DELOG(...) do {} while (0)
#define LLOG(...)  do {} while (0)
#define DELERT(...)  do {} while (0)

#endif

#define DELOGRECT(rect) DELOG(@"%s %@", #rect, NSStringFromCGRect(rect))
#define DELOGSIZE(size) DELOG(@"%s %@", #size, NSStringFromCGSize(size))
#define DELOGPOINT(point) DELOG(@"%s %@", #point, NSStringFromCGPoint(point))


void _DebugLog(const char *file, int lineNumber, const char *funcName, NSString *format,...);
