//
//  JUTableController.m
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

#import "JUTableController.h"
#import "JUSectionProxy.h"
#import "JUBindings.h"

@interface JUTableController ()
- (void)softRearrangeObjects;
@end

@implementation JUTableController
@synthesize sectionHeaderKey, sectionFooterKey, sectionTitleKey, childrenKey;
@synthesize preserveEmptySections;

- (void)setSectionHeaderKey:(NSString *)tsectionHeaderKey
{
    [sectionHeaderKey autorelease];
    sectionHeaderKey = [tsectionHeaderKey retain];
    
    [self softRearrangeObjects];
}

- (void)setSectionFooterKey:(NSString *)tsectionFooterKey
{
    [sectionFooterKey autorelease];
    sectionFooterKey = [tsectionFooterKey retain];
    
    [self softRearrangeObjects];
}

- (void)setChildrenKey:(NSString *)tchildrenKey
{
    [childrenKey autorelease];
    childrenKey = [tchildrenKey retain];
    
    [self softRearrangeObjects];
}


- (void)setFilterPredicate:(NSPredicate *)tfilterPredicate
{
    [filterPredicate autorelease];
    filterPredicate = [tfilterPredicate retain];
    
    [self softRearrangeObjects];
}

- (void)setSortDescriptors:(NSArray *)tsortDescriptors
{
    [sortDescriptors autorelease];
    sortDescriptors = [tsortDescriptors retain];
    
    [self softRearrangeObjects];
}


- (void)setSectionTitleKey:(NSString *)tsectionTitleKey
{
    [sectionTitleKey autorelease];
    sectionTitleKey = [tsectionTitleKey retain];
    
    [self willChangeValueForKey:@"arrangedObjects"];
    [arrangedObjects makeObjectsPerformSelector:@selector(rearrangeObjects)];
    [self didChangeValueForKey:@"arrangedObjects"];
}



- (NSArray *)arrangedObjects
{
    return arrangedObjects;
}

- (NSArray *)arrangedObjects:(NSArray *)objects
{
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:[objects count]];
    
    for(id object in objects)
    {
        __JUSectionProxy *proxy = [[__JUSectionProxy alloc] initWithObject:object andTableController:self];
        [result addObject:[proxy autorelease]];
    }
    
    
    [result makeObjectsPerformSelector:@selector(rearrangeObjects)];
    
    if(!preserveEmptySections)
    {
        objects = result;
        result = [NSMutableArray arrayWithCapacity:[objects count]];
        
        for(__JUSectionProxy *proxy in objects)
        {
            if([[proxy arrangedObjects] count] > 0)
                [result addObject:proxy];
        }
    }
    
    return result;
}

- (void)rearrangeObjects
{
    [self willChangeValueForKey:@"arrangedObjects"];
    
    NSArray *objects = ([[self content] isKindOfClass:[NSArray class]]) ? [self content] : [[self content] allObjects];
    [arrangedObjects release];
    arrangedObjects = [[self arrangedObjects:objects] retain];
    
    [self didChangeValueForKey:@"arrangedObjects"];
}

- (void)softRearrangeObjects
{
    if(!preserveEmptySections)
    {
        [self rearrangeObjects];
        return;
    }
    
    [self willChangeValueForKey:@"arrangedObjects"];
    
    [arrangedObjects makeObjectsPerformSelector:@selector(rearrangeObjects)]; // objects only contains __JUSectionProxy instances, which sort their content in their rearrangeObjects function
    
    [self didChangeValueForKey:@"arrangedObjects"];
}



- (void)dealloc
{
    [sectionHeaderKey release];
    [sectionFooterKey release];
    [childrenKey release];
    
    [super dealloc];
}

@end
