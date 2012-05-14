//
//  JUArrayController.m
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

#import "JUArrayController.h"
#import "JUBindings.h"


@implementation JUArrayController
@synthesize sortDescriptors, filterPredicate;

+ (void)initialize
{
    [self exposeBinding:@"contentArray"];
    [self exposeBinding:@"contentSet"];
    [self exposeBinding:@"sortDescriptors"];
    [self exposeBinding:@"filterPredicate"];
}

- (Class)valueClassForBinding:(NSString *)binding
{
    if([binding isEqualToString:@"contentArray"] || [binding isEqualToString:@"sortDescriptors"])
        return [NSArray class];
    
    if([binding isEqualToString:@"contentSet"])
        return [NSSet class];
    
    if([binding isEqualToString:@"filterPredicate"])
        return [NSPredicate class];    
    
    return [super valueClassForBinding:binding];
}



- (void)setSortDescriptors:(NSArray *)tsortDescriptors
{
    [sortDescriptors autorelease];
    sortDescriptors = [tsortDescriptors retain];
    
    [self rearrangeObjects];
}

- (void)setFilterPredicate:(NSPredicate *)tfilterPredicate
{
    [filterPredicate autorelease];
    filterPredicate = [tfilterPredicate retain];
    
    [self rearrangeObjects];
}



- (NSArray *)arrangedObjects
{
    return arrangedObjects;
}

- (NSArray *)arrangedObjects:(NSArray *)objects
{
   if(filterPredicate)
       objects = [objects filteredArrayUsingPredicate:filterPredicate];
    
    if(sortDescriptors)
        objects = [objects sortedArrayUsingDescriptors:sortDescriptors];
    
    return objects;
}

- (void)rearrangeObjects
{
    [self willChangeValueForKey:@"arrangedObjects"];
    
    NSArray *objects = ([[self content] isKindOfClass:[NSArray class]]) ? [self content] : [[self content] allObjects];
    [arrangedObjects release];
    arrangedObjects = [[self arrangedObjects:objects] retain];
    
    [self didChangeValueForKey:@"arrangedObjects"];
}



- (void)setValue:(id)value forKey:(NSString *)key
{
    if([key isEqualToString:@"contentArray"] || [key isEqualToString:@"contentSet"])
    {
        [super setContent:value];
        [self rearrangeObjects];
        
        return;
    }
    
    [super setValue:value forKey:key];
}


- (void)setContent:(id)tcontent
{
    [super setContent:tcontent];
    [self rearrangeObjects];
}

- (void)dealloc
{
    [sortDescriptors release];
    [filterPredicate release];
    [arrangedObjects release];
    
    [super dealloc];
}

@end

