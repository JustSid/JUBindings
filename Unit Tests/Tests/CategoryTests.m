//
//  CategoryTests.m
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

#import "CategoryTests.h"

@implementation CategoryTests

- (void)testMassComparison
{
    NSArray *array1 = JUArray(@"Fusce", @"dapibus", @"tellus", @"ac", @"cursus", @"commodo", @"tortor", @"mauris", @"condimentum", @"nibh", @"ut", @"fermentum", @"massa", @"justo", @"sit", @"amet", @"risus");
    NSArray *array2 = JUArray(@"Fusce", @"dapibus", @"tellus", @"ac");
    
    STAssertTrue(([array1 count] == 17), @"Array count should be 17!");
    STAssertTrue(([array2 count] == 4),  @"Array count should be 4!");
    
    // Test the first array which has enough objects in it to u
    STAssertTrue([@"mauris" ju_isEqualToAnyStringInArray:array1], @"");
    STAssertTrue([@"tellus" ju_isEqualToAnyStringInArray:array1], @"");
    
    STAssertFalse([@"hello" ju_isEqualToAnyStringInArray:array1], @"");
    STAssertFalse([@"world" ju_isEqualToAnyStringInArray:array1], @"");
    
    // Test the second array which uses array iteration for comparison
    STAssertTrue([@"Fusce"  ju_isEqualToAnyStringInArray:array2], @"");
    STAssertTrue([@"tellus" ju_isEqualToAnyStringInArray:array2], @"");
    
    STAssertFalse([@"hello" ju_isEqualToAnyStringInArray:array2], @"");
    STAssertFalse([@"world" ju_isEqualToAnyStringInArray:array2], @"");
}

// Test to check wether the JUAssociatedSet additions work as expected
- (void)testAssociatedSets
{
    NSDate *date = [NSDate date];
    NSString *string = [NSString stringWithFormat:@"Hello %@", @"world"];
    
    // Create two sets and add the two objects to them
    [self ju_addObject:date intoSetWithKey:@"test1"];
    [self ju_addObject:string intoSetWithKey:@"test1"];
    
    [self ju_addObject:date intoSetWithKey:@"test2"];
    [self ju_addObject:string intoSetWithKey:@"test2"];
    
    // Get the objects back
    NSArray *array1 = [self ju_objectsInSetWithKey:@"test1"];
    NSArray *array2 = [self ju_objectsInSetWithKey:@"test2"];
    
    // Check the integrety of the data
    STAssertNotNil(array1, @"Returned array shouldn't be nil!");
    STAssertNotNil(array2, @"Returned array shouldn't be nil!");
    
    STAssertTrue(([array1 count] == 2), @"Expected two objects in the associated set!");
    STAssertTrue(([array2 count] == 2), @"Expected two objects in the associated set!");
    
    STAssertTrue([array1 containsObject:date], @"Returned array should contain the date");
    STAssertTrue([array2 containsObject:date], @"Returned array should contain the date");
    
    STAssertTrue([array1 containsObject:string], @"Returned array should contain the string");
    STAssertTrue([array2 containsObject:string], @"Returned array should contain the string");
    
    // Remove one object from each set
    [self ju_removeObject:date   fromSetWithKey:@"test1"];
    [self ju_removeObject:string fromSetWithKey:@"test2"];
    
    
    // Get the objects back
    array1 = [self ju_objectsInSetWithKey:@"test1"];
    array2 = [self ju_objectsInSetWithKey:@"test2"];
    
    // Check the integrety of the data
    STAssertNotNil(array1, @"Returned array shouldn't be nil!");
    STAssertNotNil(array2, @"Returned array shouldn't be nil!");
    
    STAssertTrue(([array1 count] == 1), @"Expected one objects in the associated set!");
    STAssertTrue(([array2 count] == 1), @"Expected one objects in the associated set!");
    
    STAssertFalse([array1 containsObject:date], @"Returned array shouldn't contain the date");
    STAssertTrue([array2 containsObject:date], @"Returned array should contain the date");
    
    STAssertTrue([array1 containsObject:string], @"Returned array should contain the string");
    STAssertFalse([array2 containsObject:string], @"Returned array shouldn't contain the string");
}

@end
