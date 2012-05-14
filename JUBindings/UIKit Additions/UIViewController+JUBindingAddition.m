//
//  UIViewController+JUBindingAddition.m
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

#import "UIViewController+JUBindingAddition.h"
#import "NSString+JUMassComparison.h"
#import "JUBindings.h"

@implementation UIViewController (JUBindingAddition)

+ (void)initializeBindings
{
    [self exposeBinding:@"title"];
    [self exposeBinding:@"view"];
    [self exposeBinding:@"wantsFullScreenLayout"];
    [self exposeBinding:@"editing"];
    [self exposeBinding:@"modalTransitionStyle"];
    [self exposeBinding:@"modalPresentationStyle"];
    [self exposeBinding:@"hidesBottomBarWhenPushed"];
    [self exposeBinding:@"tabBarItem"];
    [self exposeBinding:@"modalInPopover"];
}

- (Class)valueClassForBinding:(NSString *)binding
{
    if([binding isEqualToString:@"title"])
        return [NSString class];
    
    if([binding isEqualToString:@"view"])
        return [UIView class];
    
    if([binding isEqualToAnyStringInArray:JUArray(@"wantsFullScreenLayout", @"editing", @"modalTransitionStyle", @"modalPresentationStyle", @"hidesBottomBarWhenPushed", @"modalInPopover")])
        return [NSNumber class];
    
    if([binding isEqualToString:@"tabBarItem"])
        return [UITabBarItem class];
    
    return [super valueClassForBinding:binding];
}

@end

__attribute__((constructor)) void _UIViewControllerInitBindings()
{
    [UIViewController initializeBindings];
}
