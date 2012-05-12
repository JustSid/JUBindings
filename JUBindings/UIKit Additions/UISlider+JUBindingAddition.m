//
//  UISlider+JUBindingAddition.m
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

#import <objc/runtime.h>
#import "UISlider+JUBindingAddition.h"
#import "NSObject+JUAssociatedSet.h"

static NSString *JUBindingUISliderValueKey = @"JUBindingUISliderValueKey";

@implementation UISlider (JUBindingAddition)

+ (void)initializeBindings
{
    [self exposeBinding:@"value"];
    [self exposeBinding:@"minimumValue"];
    [self exposeBinding:@"maximumValue"];
}

- (Class)valueClassForBinding:(NSString *)bindingKey
{
    if([bindingKey isEqualToString:@"value"])
        return [NSNumber class];
    
    if([bindingKey isEqualToString:@"minimumValue"] || [bindingKey isEqualToString:@"maximumValue"])
        return [NSNumber class];
    
    return [super valueClassForBinding:bindingKey];
}




- (void)__valueDidChange:(id)object
{
    NSArray *observer = [self objectsInSetWithKey:JUBindingUISliderValueKey];
    NSNumber *value = [NSNumber numberWithFloat:[self value]];
    
    for(JUExplicitBinding *binding in observer)
        [binding boundValueChangedTo:value];
}


- (void)addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context
{
    [super addObserver:observer forKeyPath:keyPath options:options context:context];
    
    if([keyPath isEqualToString:@"value"])
    {
        [self addObject:observer intoSetWithKey:JUBindingUISliderValueKey];
        
        if([[self objectsInSetWithKey:JUBindingUISliderValueKey] count] == 1)
            [self addTarget:self action:@selector(__valueDidChange:) forControlEvents:UIControlEventValueChanged];
    }
}

- (void)removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath context:(void *)context
{
    [super removeObserver:observer forKeyPath:keyPath context:context];
    
    if([keyPath isEqualToString:@"value"])
    {
        [self removeObject:observer fromSetWithKey:JUBindingUISliderValueKey];
        
        if([[self objectsInSetWithKey:JUBindingUISliderValueKey] count] == 0)
            [self removeTarget:self action:@selector(__valueDidChange:) forControlEvents:UIControlEventValueChanged];
    }
}


@end


__attribute__((constructor)) void _UISliderInitBindings()
{
    [UISlider initializeBindings];
}
