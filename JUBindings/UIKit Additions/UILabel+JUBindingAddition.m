//
//  UILabel+JUBindingAddition.m
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

#import "UILabel+JUBindingAddition.h"
#import "NSString+JUMassComparison.h"
#import "JUBindings.h"

@implementation UILabel (JUBindingAddition)

+ (void)initializeBindings
{
    [self exposeBinding:@"text"];
    [self exposeBinding:@"textColor"];
    [self exposeBinding:@"font"];
    [self exposeBinding:@"textAlignment"];
    [self exposeBinding:@"lineBreakMode"];
    [self exposeBinding:@"adjustFontSizeToFitWidth"];
    [self exposeBinding:@"baselineAdjustment"];
    [self exposeBinding:@"minimumFontSize"];
    [self exposeBinding:@"numberOfLines"];
    
}

- (Class)valueClassForBinding:(NSString *)binding
{
    if([binding isEqualToString:@"text"])
        return [NSString class];
    
    if([binding isEqualToString:@"textColor"])
        return [UIColor class];
    
    if([binding isEqualToString:@"font"])
        return [UIFont class];
    
    if([binding isEqualToAnyStringInArray:JUArray(@"textAlignment", @"lineBreakMode", @"adjustFontSizeToFitWidth", @"baselineAdjustment", @"minimumFontSize", @"numberOfLines")])
        return [NSNumber class];
    
    return [super valueClassForBinding:binding];
}

@end

__attribute__((constructor)) void _UILabelInitBindings()
{
    [UILabel initializeBindings];
}
