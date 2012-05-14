//
//  NSObject+JUAssociatedSet.m
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
#import "NSObject+JUAssociatedSet.h"

@implementation NSObject (JUAssociatedSet)

- (void)addObject:(id)object intoSetWithKey:(void *)key
{
    NSMutableSet *set = objc_getAssociatedObject(self, key);
    if(!set)
    {
        set = [[[NSMutableSet alloc] init] autorelease];
        objc_setAssociatedObject(self, key, set, OBJC_ASSOCIATION_RETAIN);
    }
    
    
    [set addObject:object];
}

- (void)removeObject:(id)object fromSetWithKey:(void *)key
{
    NSMutableSet *set = objc_getAssociatedObject(self, key);
    if(!set)
        return;
    
    [set removeObject:object];
    
    if([set count] == 0)
        objc_setAssociatedObject(self, key, nil, OBJC_ASSOCIATION_RETAIN);
}

- (NSArray *)objectsInSetWithKey:(void *)key
{
    NSMutableSet *set = objc_getAssociatedObject(self, key);
    return [set allObjects];
}

@end
