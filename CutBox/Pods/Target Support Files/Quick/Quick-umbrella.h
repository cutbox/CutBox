#ifdef __OBJC__
#import <Cocoa/Cocoa.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "Quick/QuickConfiguration.h"
#import "Quick/QCKDSL.h"
#import "Quick/Quick.h"
#import "Quick/QuickSpec.h"

FOUNDATION_EXPORT double QuickVersionNumber;
FOUNDATION_EXPORT const unsigned char QuickVersionString[];

