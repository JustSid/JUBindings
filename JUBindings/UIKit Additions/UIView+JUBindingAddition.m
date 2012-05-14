//
//  UIView+JUBindingAddition.m
//  JUBindings
//
//  Copyright (c) 2012 by Sidney Just
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated 
//  documentation files (the "Software"), to deal in the Software without restriction, including without limitation 
//  the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, 
//  and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
//  INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR 
//  PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE 
//  FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, 
//  ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "UIView+JUBindingAddition.h"
#import "NSString+JUMassComparison.h"
#import "JUBindings.h"

@implementation UIView (JUBindingAddition)

+ (void)initializeBindings
{
    [self exposeBinding:@"backgroundColor"];
    [self exposeBinding:@"hidden"];
    [self exposeBinding:@"alpha"];
    [self exposeBinding:@"opaque"];
    [self exposeBinding:@"clipsToBounds"];
    [self exposeBinding:@"userInteractionEnabled"];
    [self exposeBinding:@"multipleTouchEnabled"];
    [self exposeBinding:@"exclusiveTouch"];
    [self exposeBinding:@"autoresizingMask"];
    [self exposeBinding:@"autoresizesSubviews"];
    [self exposeBinding:@"contentMode"];
    [self exposeBinding:@"contentScaleFactor"];
}

- (Class)valueClassForBinding:(NSString *)binding
{
    if([binding isEqualToAnyStringInArray:JUArray(@"hidden", @"alpha", @"opaque", @"clipsToBounds", @"userInteractionEnabled", @"multipleTouchEnabled", @"exclusiveTouch", @"autoresizingMask", @"autoresizingSubviews", @"contentMode", @"contentScaleFactor")])
        return [NSNumber class];
        
    if([binding isEqualToString:@"backgroundColor"])
        return [UIColor class];
    
    return [super valueClassForBinding:binding];
}

@end


__attribute__((constructor)) void _UIViewInitBindings()
{
    [UIView initializeBindings];
}

