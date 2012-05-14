//
//  JUSectionProxy.m
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

#import "JUSectionProxy.h"

@implementation __JUSectionProxy
@synthesize header, footer;

- (NSArray *)arrangedObjects
{
    return arrangedObjects;
}

- (NSArray *)arrangedObjects:(NSArray *)objects
{
    NSPredicate *filterPredicate = [controller filterPredicate];
    NSArray *sortDescriptors = [controller sortDescriptors];
    
    if(filterPredicate)
        objects = [objects filteredArrayUsingPredicate:filterPredicate];
    
    if(sortDescriptors)
        objects = [objects sortedArrayUsingDescriptors:sortDescriptors];
    
    return objects;
}

- (void)rearrangeObjects
{
    [header autorelease];
    [footer autorelease];
    [arrangedObjects autorelease];
    
    header = [[object valueForKey:[controller sectionHeaderKey]] retain];
    footer = [[object valueForKey:[controller sectionFooterKey]] retain];
    
    id children = [object valueForKey:[controller childrenKey]];
    NSArray *objects = ([children isKindOfClass:[NSArray class]]) ? children : [children allObjects];
    
    arrangedObjects = [[self arrangedObjects:objects] retain];
}



- (id)initWithObject:(id)tobject andTableController:(JUTableController *)tcontroller
{
    if((self = [super init]))
    {
        object = [tobject retain];
        controller = tcontroller;
    }
    
    return self;
}

- (void)dealloc
{
    [object release];
    
    [header release];
    [footer release];
    [arrangedObjects release];
    
    [super dealloc];
}

@end
