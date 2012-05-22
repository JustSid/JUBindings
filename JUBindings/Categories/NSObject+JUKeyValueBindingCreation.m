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
#import "JUBindings.h"
#import "JUBindingProxy.h"
#import "JUExplicitBinding.h"

static NSString *JUBindingProxyKey = @"JUBindingProxyKey";

NSString *NSValueTransformerBindingOption   = @"NSValueTransformerBindingOption";
NSString *NSNullPlaceholderBindingOption    = @"NSNullPlaceholderBindingOption";
NSString *NSAllowsNullArgumentBindingOption = @"NSAllowsNullArgumentBindingOption";

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


// Helper to check
+ (NSArray *)exposedBindingsForClass:(Class)class
{
    NSMutableArray *bindings = [NSMutableArray array];
    
    do {
        NSSet *set = [JUBindingExposedBindings objectForKey:class];
        
        [bindings addObjectsFromArray:[set allObjects]];
    } while((class = class_getSuperclass(class)));
    
    return bindings;
}

+ (NSSet *)exposedBindingsForClassAsSet:(Class)class
{
    NSMutableSet *bindings = [NSMutableSet set];
    
    do {
        NSSet *set = [JUBindingExposedBindings objectForKey:class];
        
        [bindings unionSet:set];
    } while((class = class_getSuperclass(class)));
    
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
#ifdef JUBindingAvailabilityChecks
    if(![self exposesBinding:bindingKey])
    {
        @throw [NSException exceptionWithName:[NSString stringWithFormat:@"%@ doesn't expose %@!", self, bindingKey] reason:@"No such binding found!" userInfo:nil];
        return;
    }
#endif
    
    
    JUBindingProxy *proxy = [self bindingProxy];
    JUExplicitBinding *binding = [proxy explicitBindingForBinding:bindingKey];
    
    // Remove the old binding
    [binding unbind];
    [proxy setExplicitBinding:nil forBinding:bindingKey];
    
    // Create a new binding
    binding = [[JUExplicitBinding alloc] initWithBindingKey:bindingKey observable:observableController withKeyPath:keyPath options:options andTarget:self];
    [proxy setExplicitBinding:binding forBinding:bindingKey];
    
    [binding bind];
    [binding release];
}

- (void)unbind:(NSString *)binding
{
    JUBindingProxy *proxy = [self bindingProxy];
    JUExplicitBinding *ebinding = [proxy explicitBindingForBinding:binding];
    
    [ebinding unbind];
    [proxy setExplicitBinding:nil forBinding:binding];
}


#ifdef JUBindingsRuntimeChecks
#define JUCheckObjectAndReturnClass(object, cls) if([object isKindOfClass:[cls class]]) return [cls class];

- (Class)guessClassForBinding:(JUExplicitBinding *)binding
{
    id object = [[binding object] valueForKeyPath:[binding keyPath]];
    if(object && ![object isKindOfClass:[NSNull class]])
    {
        // Take extra care of the known class clusters
        JUCheckObjectAndReturnClass(object, NSArray);
        JUCheckObjectAndReturnClass(object, NSSet);
        JUCheckObjectAndReturnClass(object, NSDictionary);
        JUCheckObjectAndReturnClass(object, NSNumber);
        JUCheckObjectAndReturnClass(object, NSString);
        JUCheckObjectAndReturnClass(object, NSData);
        JUCheckObjectAndReturnClass(object, NSDate);
        
        return [object class];
    }
    
    // TODO: This only works everything non nil!
    // One could check the ivars/properties directly using the Objective-C runtime, but this would require
    
    return nil;
}
#endif

- (Class)valueClassForBinding:(NSString *)bindingKey
{
#ifdef JUBindingsRuntimeChecks
    // This is just a helper, should probably overwritten in subclasses!
    JUBindingProxy *proxy = [self bindingProxy];
    JUExplicitBinding *binding = [proxy explicitBindingForBinding:bindingKey];
    
    if(!binding)
        return nil;
    
    return [self guessClassForBinding:binding];
#endif
    
    @throw [NSException exceptionWithName:@"valueClassForBinding: must be implemented" reason:[NSString stringWithFormat:@"Overwrite valueClassForBinding: for \"%@\" or define JUBindingsRuntimeChecks", bindingKey] userInfo:nil];
    return nil;
}

- (NSDictionary *)infoForBinding:(NSString *)bindingKey
{
    JUBindingProxy *proxy = [self bindingProxy];
    JUExplicitBinding *binding = [proxy explicitBindingForBinding:bindingKey];
    
    if(!binding)
        return nil;
    
    return [NSDictionary dictionaryWithObjectsAndKeys:[binding object], NSObservedObjectKey, [binding keyPath], NSObservedKeyPathKey, [binding options], NSOptionsKey, nil];

}

- (NSArray *)optionDescriptionsForBinding:(NSString *)binding
{
    // Not implemented anywhere because this is only used by IB afair
    return nil;
}



- (JUBindingProxy *)bindingProxy
{
    id proxy;
    
    @autoreleasepool {
        proxy = objc_getAssociatedObject(self, JUBindingProxyKey);
        if(!proxy)
        {
            proxy = [[JUBindingProxy alloc] init];
            objc_setAssociatedObject(self, JUBindingProxyKey, proxy, OBJC_ASSOCIATION_RETAIN);
            [proxy release];
        }
    }
    
    return proxy;
}

@end
