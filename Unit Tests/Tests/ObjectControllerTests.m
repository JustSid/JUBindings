//
//  ObjectControllerTests.m
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

#import "ObjectControllerTests.h"

@implementation ObjectControllerTests

- (void)setUp
{
    [super setUp];
    
    coreData = [[CoreDataAbstraction alloc] init];
    controller = [[JUObjectController alloc] initWithContent:nil];
    [controller setManagedObjectContext:[coreData managedObjectContext]];
    [controller setEntityName:@"SimpleEntity"];
}

- (void)tearDown
{
    [coreData release];
    [controller release];
    
    [super tearDown];
}


- (void)testObjectInsertion
{
    STAssertEqualObjects([controller selectedObjects], nil, @"");
    
    NSArray *objects;
    NSManagedObject *object = [coreData insertEntity:@"SimpleEntity"];
    [object setValue:@"Hello World" forKey:@"string"];
    [object setValue:[NSDate date] forKey:@"date"];
    
    [coreData save];
    
    objects = [controller selectedObjects];
    STAssertTrue(([objects count] == 1), @"");
    STAssertTrue(([objects containsObject:object]), @"");
}

- (void)testObjectDeletion
{
    NSArray *objects;
    NSManagedObject *object = [coreData insertEntity:@"SimpleEntity"];
    [object setValue:@"Hello World" forKey:@"string"];
    [object setValue:[NSDate date] forKey:@"date"];
    
    [coreData save];
    [coreData removeObject:object];
    [coreData save];
    
    objects = [controller selectedObjects];
    STAssertTrue(([objects count] == 0), @"");
}

- (void)testFetchPredicate
{
    NSString *string = [JUArray(@"Hello World", @"Lorem Ipsum") objectAtIndex:arc4random_uniform(2)];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"string == %@", string];
    NSManagedObject *object1 = [coreData insertEntity:@"SimpleEntity"];
    NSManagedObject *object2 = [coreData insertEntity:@"SimpleEntity"];
    
    [object1 setValue:@"Hello World" forKey:@"string"];
    [object1 setValue:[NSDate date] forKey:@"date"];
    
    [object2 setValue:@"Lorem Ipsum" forKey:@"string"];
    [object2 setValue:[NSDate date] forKey:@"date"];
    
    [controller setFetchPredicate:predicate];
    [coreData save];
    
    // Test the result
    NSArray *objects = [controller selectedObjects];
    STAssertTrue(([objects count] == 1), @"");
    STAssertEqualObjects([[objects objectAtIndex:0] valueForKey:@"string"], string, @"");
}

- (void)testCanAdd
{
    [controller setCanAdd:NO];
    [controller add:self];
    
    STAssertTrue(([[controller selectedObjects] count] == 0), @"");
    
    [controller setCanAdd:YES];
    [controller add:self];
    
    STAssertTrue(([[controller selectedObjects] count] == 1), @"");
}

- (void)testCanRemove
{
    [controller add:self];
    STAssertTrue(([[controller selectedObjects] count] == 1), @"");
    
    [controller setCanRemove:NO];
    [controller remove:self];

    STAssertTrue(([[controller selectedObjects] count] == 1), @"");
    
    [controller setCanRemove:YES];
    [controller remove:self];
    
    STAssertTrue(([[controller selectedObjects] count] == 0), @"");
}

- (void)testCanEdit
{
    [controller add:self];
    [controller setEditable:NO];
    [controller remove:self];
    
    STAssertTrue(([[controller selectedObjects] count] == 1), @"");
    
    
    [controller setEditable:YES];
    [controller remove:self];
    [controller setEditable:NO];
    [controller add:self];
    
    STAssertTrue(([[controller selectedObjects] count] == 0), @"");
    
    
    [controller setEditable:YES];
    [controller add:self];
    
    STAssertTrue(([[controller selectedObjects] count] == 1), @"");
}

@end
