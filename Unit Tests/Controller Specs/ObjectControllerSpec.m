//
//  ObjectControllerSpec.m
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

SPEC_BEGIN(ObjectController)

describe(@"Object controller", ^{
   
    context(@"Core Data", ^{
        __block CoreDataAbstraction *coreData;
        __block JUObjectController  *controller;
        
        beforeEach(^{
            coreData = [[CoreDataAbstraction alloc] init];
            controller = [[JUObjectController alloc] initWithContent:nil];
            
            [controller setManagedObjectContext:[coreData managedObjectContext]];
            [controller setEntityName:@"SimpleEntity"];
        });
        
        afterEach(^{
            [coreData release];
            [controller release];
        });
        
        
        it(@"should throw without managed object context", ^{
            [controller setManagedObjectContext:nil];
            
            [[theBlock(^{[controller fetch:nil];}) should] raise];
        });
        
        it(@"should throw without entity name", ^{
            [controller setEntityName:nil];
            
            [[theBlock(^{[controller fetch:nil];}) should] raise];
        });
        
        it(@"should throw without managed object context and entity name", ^{
            [controller setManagedObjectContext:nil];
            [controller setEntityName:nil];
            
            [[theBlock(^{[controller fetch:nil];}) should] raise];
        });
        
        
        
        it(@"should reflect insertion", ^{
            [[controller selectedObjects] shouldBeNil];
            
            NSManagedObject *object = [coreData insertEntity:@"SimpleEntity"];
            [object setValue:@"Hello World" forKey:@"string"];
            [object setValue:[NSDate date] forKey:@"date"];
            
            [coreData save];
            
            [[[controller selectedObjects] should] haveCountOf:1];
            [[[controller selectedObjects] should] contain:object];
        });
        
        it(@"should reflect deletion", ^{
            [[controller selectedObjects] shouldBeNil];
            
            NSManagedObject *object = [coreData insertEntity:@"SimpleEntity"];
            [object setValue:@"Hello World" forKey:@"string"];
            [object setValue:[NSDate date] forKey:@"date"];
            
            [coreData save];
            [coreData removeObject:object];
            [coreData save];
            
            [[controller selectedObjects] shouldBeNil];
        });
        
        it(@"should support fetch predicates", ^{            
            NSManagedObject *object1 = [coreData insertEntity:@"SimpleEntity"];
            [object1 setValue:@"Aenean Ligula" forKey:@"string"];
            [object1 setValue:[NSDate date] forKey:@"date"];
            
            NSManagedObject *object2 = [coreData insertEntity:@"SimpleEntity"];
            [object2 setValue:@"Etiam Ligula" forKey:@"string"];
            [object2 setValue:[NSDate date] forKey:@"date"];
            
            NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"string == %@", [object1 valueForKey:@"string"]];
            NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"string == %@", [object2 valueForKey:@"string"]];
            
            
            
            // Predicate 1
            [controller setFetchPredicate:predicate1];
            [coreData save];
            
            [[[controller selectedObjects] should] haveCountOf:1];
            [[[controller selectedObjects] should] contain:object1];
            
            // Predicate 2
            [controller setFetchPredicate:predicate2];
            [coreData save];
            
            [[[controller selectedObjects] should] haveCountOf:1];
            [[[controller selectedObjects] should] contain:object2];
        });
        
        it(@"should support canAdd:", ^{
            // canAdd:NO
            [controller setCanAdd:NO];
            [controller add:self];
            
            [[controller selectedObjects] shouldBeNil];
            
            // canAdd:YES
            [controller setCanAdd:YES];
            [controller add:self];
            
            [[[controller selectedObjects] should] haveCountOf:1];
        });
        
        it(@"should support canRemove:", ^{
            [controller add:self];
            [[[controller selectedObjects] should] haveCountOf:1];
            
            
            // canRemove:NO
            [controller setCanRemove:NO];
            [controller remove:self];
            
            [[[controller selectedObjects] should] haveCountOf:1];
            
            // canRemove:YES
            [controller setCanRemove:YES];
            [controller remove:self];
            
            [[controller selectedObjects] shouldBeNil];
        });
        
        it(@"should support canEdit:", ^{
            [controller add:self];
            [controller setEditable:NO];
            [controller remove:self];
            
            [[[controller selectedObjects] should] haveCountOf:1];
            
            
            [controller setEditable:YES];
            [controller remove:self];
            [controller setEditable:NO];
            [controller add:self];
            
            [[controller selectedObjects] shouldBeNil];
            
            
            
            [controller setEditable:YES];
            [controller add:self];
            
            [[[controller selectedObjects] should] haveCountOf:1];
        });
    });
    
});

SPEC_END
