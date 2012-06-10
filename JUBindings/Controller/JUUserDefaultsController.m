//
//  JUUserDefaultsController.m
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

#import "JUUserDefaultsController.h"
#import "JUBindings.h"

@interface JUUserDefaultsControllerTransformer : NSValueTransformer
@end

@implementation JUUserDefaultsControllerTransformer

- (id)transformedValue:(id)value
{
    return value;
}

@end



@implementation JUUserDefaultsController

- (void)setValue:(id)value forKey:(NSString *)key
{
    [defaults setObject:value forKey:key];
}

- (id)valueForKey:(NSString *)key
{
    return [defaults valueForKey:key];
}


- (BOOL)exposesBinding:(NSString *)binding
{
    // Yup, we can do everything!
    return YES;
}



- (void)bind:(NSString *)binding toObject:(id)observableController withKeyPath:(NSString *)keyPath options:(NSDictionary *)options
{
    if(![options objectForKey:NSValueTransformerBindingOption])
    {
        // This is a bit hacky, since we return YES to every binding we are asked to, but have actually no idea what the value class will be
        // So what we do is; we create a custom transformer that just returns the object without transforming it in any way, and set it for the NSValueTransformerBindingOption option.
        // This way we make sure that the binding runtime doesn't try to convert the value.
        
        NSMutableDictionary *doptions = [NSMutableDictionary dictionaryWithDictionary:options];
        [doptions setObject:transformer forKey:NSValueTransformerBindingOption];
        
        options = doptions;
    }
    
    [super bind:binding toObject:observableController withKeyPath:keyPath options:options];
}


+ (JUUserDefaultsController *)sharedDefaultsController
{
    static JUUserDefaultsController *controller = nil;
    if(!controller)
        controller = [[JUUserDefaultsController alloc] initWithDefaults:[NSUserDefaults standardUserDefaults]];
    
    return controller;
}

- (id)initWithDefaults:(NSUserDefaults *)tdefaults
{
    tdefaults = (!tdefaults) ? [NSUserDefaults standardUserDefaults]: tdefaults; 
    
    if((self = [super init]))
    {
        defaults = [tdefaults retain];
        transformer = [[JUUserDefaultsControllerTransformer alloc] init];
    }
    
    return self;
}

- (void)dealloc
{
    [transformer release];
    [defaults release];
    
    [super dealloc];
}

@end
