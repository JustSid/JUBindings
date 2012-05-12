//
//  UISwitch+JUBindingAddition.m
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

#import "UISwitch+JUBindingAddition.h"
#import "NSObject+JUAssociatedSet.h"
#import "JUBindings.h"

static NSString *JUBindingUISwitchValueKey = @"JUBindingUISwitchValueKey";

@implementation UISwitch (JUBindingAddition)

+ (void)initializeBindings
{
    [self exposeBinding:@"on"];
}

- (Class)valueClassForBinding:(NSString *)binding
{
    if([binding isEqualToString:@"on"])
        return [NSNumber class];
        
    return [super valueClassForBinding:binding];
}




- (void)__valueDidChange:(id)object
{
    NSArray *observer = [self objectsInSetWithKey:JUBindingUISwitchValueKey];
    NSNumber *value = [NSNumber numberWithBool:[self isOn]];
    
    for(JUExplicitBinding *binding in observer)
        [binding boundValueChangedTo:value];
}


- (void)addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context
{
    [super addObserver:observer forKeyPath:keyPath options:options context:context];
    
    if([keyPath isEqualToString:@"on"])
    {
        [self addObject:observer intoSetWithKey:JUBindingUISwitchValueKey];
        
        if([[self objectsInSetWithKey:JUBindingUISwitchValueKey] count] == 1)
            [self addTarget:self action:@selector(__valueDidChange:) forControlEvents:UIControlEventValueChanged];
    }
}

- (void)removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath context:(void *)context
{
    [super removeObserver:observer forKeyPath:keyPath context:context];
    
    if([keyPath isEqualToString:@"on"])
    {
        [self removeObject:observer fromSetWithKey:JUBindingUISwitchValueKey];
        
        if([[self objectsInSetWithKey:JUBindingUISwitchValueKey] count] == 0)
            [self removeTarget:self action:@selector(__valueDidChange:) forControlEvents:UIControlEventValueChanged];
    }
}

@end

__attribute__((constructor)) void _UISwitchInitBindings()
{
    [UISwitch initializeBindings];
}
