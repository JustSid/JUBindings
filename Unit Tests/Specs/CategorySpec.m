//
//  CategorySpec.m
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

SPEC_BEGIN(CategorySpec)

describe(@"Categories", ^{
    context(@"Mass comparison", ^{
        __block NSArray *array1 = nil;
        __block NSArray *array2 = nil;
        
        beforeAll(^{
            array1 = [JUArray(@"Fusce", @"dapibus", @"tellus", @"ac", @"cursus", @"commodo", @"tortor", @"mauris", @"condimentum", @"nibh", @"ut", @"fermentum", @"massa", @"justo", @"sit", @"amet", @"risus") retain];
            array2 = [JUArray(@"Fusce", @"dapibus", @"tellus", @"ac") retain];
        });
        
        afterAll(^{
            [array1 release];
            [array2 release];
        });
        
        
        
        
        it(@"should have the right count", ^{
            [[array1 should] haveCountOf:17];
            [[array2 should] haveCountOf:4];
        });
        
        it(@"should support NSSet comparison", ^{
            [[theValue([@"mauris" ju_isEqualToAnyStringInArray:array1]) should] beTrue];
            [[theValue([@"tellus" ju_isEqualToAnyStringInArray:array1]) should] beTrue];
            
            [[theValue([@"hello" ju_isEqualToAnyStringInArray:array1]) should] beFalse];
            [[theValue([@"world" ju_isEqualToAnyStringInArray:array2]) should] beFalse];
        });
        
        it(@"should support iteration comparison", ^{
            [[theValue([@"Fusce"  ju_isEqualToAnyStringInArray:array2]) should] beTrue];
            [[theValue([@"tellus" ju_isEqualToAnyStringInArray:array2]) should] beTrue];
            
            [[theValue([@"hello" ju_isEqualToAnyStringInArray:array2]) should] beFalse];
            [[theValue([@"world" ju_isEqualToAnyStringInArray:array2]) should] beFalse];
        });
    });

    context(@"Associated sets", ^{
        __block NSDate   *date = nil;
        __block NSString *string = nil;
        
        beforeEach(^{
            date   = [NSDate date];
            string = [NSString stringWithFormat:@"Hello %@", @"world"];
            
            [self ju_addObject:date intoSetWithKey:@"test1"];
            [self ju_addObject:string intoSetWithKey:@"test1"];
            
            [self ju_addObject:date intoSetWithKey:@"test2"];
            [self ju_addObject:string intoSetWithKey:@"test2"];
        });
        
        afterEach(^{
            [self ju_removeAllObjectsFromSetWithKey:@"test1"];
            [self ju_removeAllObjectsFromSetWithKey:@"test2"];
        });
        
        
        
        
        it(@"should contain all objects", ^{
            NSArray *array1 = [self ju_objectsInSetWithKey:@"test1"];
            NSArray *array2 = [self ju_objectsInSetWithKey:@"test2"];
            
            [array1 shouldNotBeNil];
            [array2 shouldNotBeNil];
            
            [[array1 should] haveCountOf:2];
            [[array2 should] haveCountOf:2];
            
            [[array1 should] containObjects:date, string, nil];
            [[array2 should] containObjects:date, string, nil];
        });
        
        it(@"should remove objects correctly", ^{
            [self ju_removeObject:date   fromSetWithKey:@"test1"];
            [self ju_removeObject:string fromSetWithKey:@"test2"];
            
            NSArray *array1 = [self ju_objectsInSetWithKey:@"test1"];
            NSArray *array2 = [self ju_objectsInSetWithKey:@"test2"];
            
            [array1 shouldNotBeNil];
            [array2 shouldNotBeNil];
            
            [[array1 should] haveCountOf:1];
            [[array2 should] haveCountOf:1];
            
            [[array1 should] contain:string];
            [[array2 should] contain:date];
        });
    });
});

SPEC_END
