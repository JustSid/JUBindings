//
//  NSObject+JUKeyValueBindingCreation.m
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

#import "NSObject+JUKeyValueBindingCreation.h"
#import "JUBindingProxy.h"
#import "JUExplicitBinding.h"

static NSString *JUBindingProxyKey = @"JUBindingProxyKey";

NSString *NSValueTransformerBindingOption   = @"NSValueTransformerBindingOption";
NSString *NSSelectorNameBindingOption       = @"NSSelectorNameBindingOption";
NSString *NSNullPlaceholderBindingOption    = @"NSNullPlaceholderBindingOption";

NSString *NSObservedObjectKey   = @"NSObservedObjectKey";
NSString *NSObservedKeyPathKey  = @"NSObservedKeyPathKey";
NSString *NSOptionsKey          = @"NSOptionsKey";

@interface NSObject (JUKeyValueBindingCreationPrivate)

- (JUBindingProxy *)bindingProxy;

@end


NSMutableDictionary *JUBindingExposedBindings = nil;

@implementation NSObject (JUKeyValueBindingCreation)

+ (void)exposeBinding:(NSString *)binding
{
    if(!JUBindingExposedBindings)
        JUBindingExposedBindings = [[NSMutableDictionary alloc] init];
    
    NSMutableSet *bindings = [JUBindingExposedBindings objectForKey:self];
    if(!bindings)
    {
        bindings = [[NSMutableSet alloc] init];
        [JUBindingExposedBindings setObject:bindings forKey:self];
        [bindings release]; // We most certainly have no autorelease pool in place at this time!
    }
    
    [bindings addObject:binding];
}

+ (NSArray *)exposedBindingsForClass:(Class)class
{
    NSMutableArray *bindings = [NSMutableArray array];
    
    do {
        NSSet *set = [JUBindingExposedBindings objectForKey:class];
        
        [bindings addObjectsFromArray:[set allObjects]];
    } while ((class = class_getSuperclass(class)));
    
    return bindings;
}

+ (NSSet *)exposedBindingsForClassAsSet:(Class)class
{
    NSMutableSet *bindings = [NSMutableSet set];
    
    do {
        NSSet *set = [JUBindingExposedBindings objectForKey:class];
        
        [bindings unionSet:set];
    } while ((class = class_getSuperclass(class)));
    
    return bindings;
}


- (NSArray *)exposedBindings
{
    return [NSObject exposedBindingsForClass:self->isa];
}

- (BOOL)exposesBinding:(NSString *)binding
{
    NSSet *allBindings = [NSObject exposedBindingsForClassAsSet:self->isa];
    return [allBindings containsObject:binding];
}




- (void)bind:(NSString *)bindingKey toObject:(id)observableController withKeyPath:(NSString *)keyPath options:(NSDictionary *)options
{
    if(![self exposesBinding:bindingKey])
    {
        @throw [NSException exceptionWithName:[NSString stringWithFormat:@"%@ doesn't expose %@!", self, bindingKey] reason:@"No such binding found!" userInfo:nil];
        return;
    }
    
    
    JUBindingProxy *proxy = [self bindingProxy];
    JUExplicitBinding *binding = [proxy explicitBindingForBinding:bindingKey];
    
    // Remove the old binding
    [binding unbind];
    [proxy setExplicitBinding:nil forBinding:bindingKey];
    
    // Create a new binding
    binding = [[[JUExplicitBinding alloc] initWithBindingKey:bindingKey observable:observableController withKeyPath:keyPath options:options andTarget:self] autorelease];
    
    [binding bind];
    [proxy setExplicitBinding:binding forBinding:bindingKey];
    
}

- (void)unbind:(NSString *)binding
{
    JUBindingProxy *proxy = [self bindingProxy];
    JUExplicitBinding *ebinding = [proxy explicitBindingForBinding:binding];
    
    [ebinding unbind];
    [proxy setExplicitBinding:nil forBinding:binding];
}





- (Class)valueClassForBinding:(NSString *)bindingKey
{
    // This is just a helper, should probably overwritten in subclasses!
    JUBindingProxy *proxy = [self bindingProxy];
    JUExplicitBinding *binding = [proxy explicitBindingForBinding:bindingKey];
    
    if(!binding)
        return nil;
    
    id object = [[binding object] valueForKeyPath:[binding keyPath]];
    return [object class];
}

- (NSDictionary *)infoForBinding:(NSString *)bindingKey
{
    JUBindingProxy *proxy = [self bindingProxy];
    JUExplicitBinding *binding = [proxy explicitBindingForBinding:bindingKey];
    
    return [NSDictionary dictionaryWithObjectsAndKeys:[binding object], NSObservedObjectKey, [binding keyPath], NSObservedKeyPathKey, [binding options], NSOptionsKey, nil];

}

- (NSArray *)optionDescriptionsForBinding:(NSString *)binding
{
    // Not implemented anywhere because this is most of the time only used by IB
    return nil;
}



- (void)fireKeyPath:(NSString *)keyPath
{
    NSRange range = [keyPath rangeOfString:@"."];
    if(range.location == NSNotFound)
    {
        [self willChangeValueForKey:keyPath];
        [self didChangeValueForKey:keyPath];
        
        return;
    }
    
    NSString *key = [keyPath substringToIndex:range.location];
    keyPath = [keyPath substringFromIndex:range.location + 1];

    NSObject *object = [self valueForKey:key];
    [object fireKeyPath:keyPath];    
}



- (JUBindingProxy *)bindingProxy
{
    id proxy = objc_getAssociatedObject(self, JUBindingProxyKey);
    if(!proxy)
    {
        proxy = [[[JUBindingProxy alloc] init] autorelease];
        objc_setAssociatedObject(self, JUBindingProxyKey, proxy, OBJC_ASSOCIATION_RETAIN);
    }
    
    return proxy;
}

@end
