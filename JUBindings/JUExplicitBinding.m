//
//  JUBinding.m
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

#import "JUExplicitBinding.h"
#import "JUBindings.h"

@interface JUExplicitBinding ()
{
    BOOL usesKVO;
    BOOL usesCustomBinding;
}

@end


@implementation JUExplicitBinding
@synthesize target, binding, object, keyPath, options;

- (id)convertObject:(id)tobject toClass:(Class)class
{
    if([tobject isKindOfClass:class])
        return tobject;
    
    if([class isSubclassOfClass:[NSString class]])
    {
        return [tobject description];
    }
    
    if([class isSubclassOfClass:[NSNumber class]])
    {
        if([object isKindOfClass:[NSString class]])
        {
            return [NSNumber numberWithFloat:[object floatValue]];
        }
    }
    
    return nil;
}

- (void)boundValueChangedTo:(id)newValue
{
    NSValueTransformer *transformer = [options objectForKey:NSValueTransformerBindingOption];
    id placeholder = [options objectForKey:NSNullPlaceholderBindingOption];
    id result = nil;
    

    if(newValue && ![newValue isKindOfClass:[NSNull class]])
    {
        result = transformer ? [transformer transformedValue:newValue] : [self convertObject:newValue toClass:[target valueClassForBinding:binding]];
        if(!result)
            result = placeholder;
    }
    else 
    {
        result = placeholder;
    }
    
    [target setValue:result forKeyPath:binding];
}



#pragma mark -
#pragma mark KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self boundValueChangedTo:[change objectForKey:NSKeyValueChangeNewKey]];
}

- (void)bindUsingKVO
{
    NSKeyValueObservingOptions ovserverOptions = NSKeyValueObservingOptionNew;
    [object addObserver:self forKeyPath:keyPath options:ovserverOptions context:self];
    [object fireKeyPath:keyPath];
    
    usesKVO = YES;
}

- (void)bindCustomBinding
{
    [target createCustomBindingWithExplicitBinding:self];    
    usesCustomBinding = YES;
}

- (void)forceUnbind
{
    if(usesKVO)
        [object removeObserver:self forKeyPath:keyPath context:self];
    
    if(usesCustomBinding)
        [object unbindCustomBinding:self];
    
    usesKVO = usesCustomBinding = NO;
}



- (id)initWithBindingKey:(NSString *)tkey observable:(id)tobject withKeyPath:(NSString *)tkeyPath options:(NSDictionary *)toptions andTarget:(id)ttarget
{
    if((self = [super init]))
    {
        binding = [tkey copy];
        
        target  = ttarget;
        object  = [tobject retain];
        keyPath = [tkeyPath copy];
        options = [toptions copy];
    }
    
    return self;
}

- (void)dealloc
{
    [self forceUnbind];
    
    [binding release];
    [object release];
    [keyPath release];
    [options release];
    
    [super dealloc];
}

@end

