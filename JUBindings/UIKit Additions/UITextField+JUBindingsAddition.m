//
//  UITextField+JUBindingsAddition.m
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

#import "UITextField+JUBindingsAddition.h"
#import "NSString+JUMassComparison.h"

@implementation UITextField (JUBindingsAddition)

+ (void)initializeBindings
{
    [self exposeBinding:@"text"];
    [self exposeBinding:@"placeholder"];
    [self exposeBinding:@"font"];
    [self exposeBinding:@"textColor"];
    [self exposeBinding:@"textAlignment"];
    [self exposeBinding:@"adjustFontSizeToFitWidth"];
    [self exposeBinding:@"minimumFontSize"];
    [self exposeBinding:@"clearsOnBeginEditing"];
    [self exposeBinding:@"clearButtonMode"];
    [self exposeBinding:@"leftView"];
    [self exposeBinding:@"leftViewMode"];
    [self exposeBinding:@"rightView"];
    [self exposeBinding:@"rightViewMode"];
    [self exposeBinding:@"inputView"];
    [self exposeBinding:@"inputAccessoryView"];
}

- (Class)valueClassForBinding:(NSString *)binding
{
    if([binding isEqualToString:@"text"] || [binding isEqualToString:@"placeholder"])
        return [NSString class];
    
    if([binding isEqualToString:@"textColor"])
        return [UIColor class];
    
    if([binding isEqualToString:@"font"])
        return [UIFont class];
    
    if([binding ju_isEqualToAnyStringInArray:JUArray(@"textAlignment", @"adjustFontSizeToFitWidth", @"minimumFontSize", @"clearsOnBeginEditing", @"clearButtonMode", @"leftViewMode", @"rightViewMode")])
        return [NSNumber class];
    
    if([binding ju_isEqualToAnyStringInArray:JUArray(@"leftView", @"rightView", @"inputView", @"inputAccessoryView")])
        return [UIView class];
    
    return [super valueClassForBinding:binding];
}

@end

__attribute__((constructor)) void _UITextFieldInitBindings()
{
    [UITextField initializeBindings];
}
