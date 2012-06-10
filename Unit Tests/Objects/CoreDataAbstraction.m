//
//  CoreDataAbstraction.m
//  Unit Tests
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

#import "CoreDataAbstraction.h"

@implementation CoreDataAbstraction
@synthesize persistentStoreCoordinator, managedObjectModel, managedObjectContext;

- (NSManagedObject *)insertEntity:(NSString *)entity
{
    return [NSEntityDescription insertNewObjectForEntityForName:entity inManagedObjectContext:managedObjectContext];
}

- (void)removeObject:(NSManagedObject *)object
{
    [managedObjectContext deleteObject:object];
}

- (void)save
{
    [managedObjectContext save:NULL];
}




- (id)init
{
    if((self = [super init]))
    {
        NSURL *URL = [[NSBundle bundleForClass:[CoreDataAbstraction class]]  URLForResource:@"TestModel" withExtension:@"momd"];
        
        managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:URL];
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        
        persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
        
        persistentStore = [persistentStoreCoordinator addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:NULL];
        [managedObjectContext setPersistentStoreCoordinator:persistentStoreCoordinator];
    }
    
    return self;
}

- (void)dealloc
{
    [managedObjectModel release];
    [managedObjectContext release];
    
    [persistentStoreCoordinator release];
    
    [super dealloc];
}

@end
