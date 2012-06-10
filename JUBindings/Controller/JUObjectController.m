//
//  JUObjectController.m
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

#import "JUObjectController.h"
#import "JUBindings.h"

@interface JUObjectController ()
{
    id content;
    Class objectClass;
    
    BOOL editable;
    BOOL canAdd;
    BOOL canRemove;
    
    // Core Data support
    BOOL usesLazyFetching;
    NSString *entityName;
    NSPredicate *fetchPredicate;
    NSManagedObjectContext *managedObjectContext;
}
@end


@implementation JUObjectController
@synthesize content, objectClass, canAdd, canRemove, editable;
@synthesize usesLazyFetching, entityName, fetchPredicate, managedObjectContext;

+ (void)initialize
{
    [self exposeBinding:@"content"];
    [self exposeBinding:@"contentObject"];
    [self exposeBinding:@"editable"];
    [self exposeBinding:@"managedObjectContext"];
}

- (Class)valueClassForBinding:(NSString *)binding
{
    if([binding isEqualToString:@"content"] || [binding isEqualToString:@"contentObject"])
        return [NSObject class];
    
    if([binding isEqualToString:@"editable"])
        return [NSNumber class];
    
    if([binding isEqualToString:@"managedObjectContext"])
        return [NSManagedObjectContext class];
    
    return [super valueClassForBinding:binding];
}

#pragma mark -
#pragma mark CoreData / Object Mode

- (id)newObject
{
    if([self entityName] == nil || [self managedObjectContext] == nil)
    {
        Class cls = [self objectClass];
        id object = [[cls alloc] init];
        
        return object;
    }
    
    return [[NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:[self managedObjectContext]] retain];
}

- (IBAction)add:(id)sender
{
    if(![self canAdd] || ![self isEditable])
        return;
    
    id object = [[self newObject] autorelease];
    
    if([self content] == nil)
        self.content = object;
}

- (IBAction)remove:(id)sender
{
    if(![self canRemove] || ![self isEditable])
        return;
    
    self.content = nil;
}

#pragma mark -
#pragma mark Core Data

- (NSFetchRequest *)defaultFetchRequest
{
    JUObjectControllerCheckAndThrowOnObjectContext([self managedObjectContext]);
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:[self entityName] inManagedObjectContext:[self managedObjectContext]];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    if(!entityDescription)
    {
        [request release];
        [NSException raise:@"No entity found" format:@"Cannot perform operation because entity with name '%@' cannot be found", [self entityName]];
    }
        
    [request setEntity:entityDescription];
    [request setPredicate:[self fetchPredicate]];
    [request setFetchLimit:1];
    
    return [request autorelease];
}

- (void)fetch:(id)sender
{
    NSError *error = nil;
    BOOL result = [self fetchWithRequest:nil merge:NO error:&error];
    
    if(!result)
        JUAlertViewPresentWithError(error);
}

- (BOOL)fetchWithRequest:(NSFetchRequest *)fetchRequest merge:(BOOL)merge error:(NSError **)error
{
    JUObjectControllerCheckAndThrowOnObjectContext([self managedObjectContext]);
    
    if(!fetchRequest)
        fetchRequest = [self defaultFetchRequest];
    
    NSArray *result = [[self managedObjectContext] executeFetchRequest:fetchRequest error:error];
    if(!result)
        return NO;
    
    id object = ([result count] >= 1) ? [result objectAtIndex:0] : nil;
    self.content = object;
    
    return YES;
}

- (void)managedObjectContextDidSave:(NSNotification *)notification
{
    if([self entityName])
        [self fetch:nil];
}

- (void)setManagedObjectContext:(NSManagedObjectContext *)tmanagedObjectContext
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSManagedObjectContextDidSaveNotification object:managedObjectContext];
    
    [managedObjectContext autorelease];
    managedObjectContext = [tmanagedObjectContext retain];
    
    if(managedObjectContext)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(managedObjectContextDidSave:) name:NSManagedObjectContextDidSaveNotification object:managedObjectContext];
        [self managedObjectContextDidSave:nil];
    }
}


#pragma mark -
#pragma mark Misc

- (id)selection
{
    return self.content;
}

- (NSArray *)selectedObjects
{
    id _content = [self content];
    if(!_content)
        return nil;
    
    return [NSArray arrayWithObject:_content];
}

- (void)setContentObject:(id)object
{
    self.content = object;
}

- (id)contentObject
{
    return self.content;
}


#pragma mark -
#pragma mark Constructor / Destructor

- (id)init
{
    if((self = [super init]))
    {
        self.canAdd = YES;
        self.canRemove = YES;
        self.editable = YES;
        self.usesLazyFetching = YES;
        self.objectClass = [NSMutableDictionary class];
        
        
    }
    
    return self;
}

- (id)initWithContent:(id)tcontent
{
    if((self = [self init]))
    {
        self.content = tcontent;
    }
    
    return self;
}

- (void)dealloc
{
    self.content = nil;
    self.objectClass = nil;
    self.entityName = nil;
    self.fetchPredicate = nil;
    self.managedObjectContext = nil;
    
    [super dealloc];
}

@end
