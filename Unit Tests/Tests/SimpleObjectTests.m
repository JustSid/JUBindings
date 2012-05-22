//
//  SimpleObjectTests.m
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

#import "SimpleObjectTests.h"
#import "TestHelper.h"

@implementation SimpleObjectTests
@synthesize character, integer, floating;

- (void)setUpBindingsForObject:(id)tobject
{
    [tobject bind:@"character" toObject:self withKeyPath:@"character" options:nil];
    [tobject bind:@"integer"   toObject:self withKeyPath:@"integer"   options:nil];
    [tobject bind:@"floating"  toObject:self withKeyPath:@"floating"  options:nil];
}

- (void)setUp
{
    [super setUp];
    
    object = [[SimpleObject alloc] init];
    chained = [[SimpleObject alloc] init];
    objectWithoutValueClass = [[SimpleObjectWithoutValueClass alloc] init];
    
    [self setUpBindingsForObject:object];
    [self setUpBindingsForObject:objectWithoutValueClass];
    
    [chained bind:@"character" toObject:self withKeyPath:@"object.character" options:nil];
    [chained bind:@"integer"   toObject:self withKeyPath:@"object.integer"   options:nil];
    [chained bind:@"floating"  toObject:self withKeyPath:@"object.floating"  options:nil];
    
    
    // Changet the values
    self.character = (char)arc4random_uniform(256);
    self.integer = arc4random_uniform(NSIntegerMax);
    self.floating = (float)character / 255.0f;
}

- (void)tearDown
{
    [chained release];
    [object release];
    [objectWithoutValueClass release];
    
    [super tearDown];
}


#pragma mark -
#pragma mark Tests

// Test if changing the values also changes the bound values in object and objectWithoutValueClass
- (void)testValueChanges
{
    STAssertEquals(character, [[object valueForKey:@"character"] charValue],  @"SimpleObjects \"character\" value doesn't match!");
    STAssertEquals(integer,   [[object valueForKey:@"integer"] integerValue], @"SimpleObjects \"integer\" value doesn't match!");
    STAssertEquals(floating,  [[object valueForKey:@"floating"] floatValue],  @"SimpleObjects \"floating\" value doesn't match!");
    
    STAssertEquals(character, [[objectWithoutValueClass valueForKey:@"character"] charValue],  @"SimpleObjectWithoutValueClass's \"character\" value doesn't match!");
    STAssertEquals(integer,   [[objectWithoutValueClass valueForKey:@"integer"] integerValue], @"SimpleObjectWithoutValueClass's \"integer\" value doesn't match!");
    STAssertEquals(floating,  [[objectWithoutValueClass valueForKey:@"floating"] floatValue],  @"SimpleObjectWithoutValueClass's \"floating\" value doesn't match!");
}

// Test if key pathes work correctly
- (void)testKeyPathes
{
    STAssertEquals(character, [[chained valueForKey:@"character"] charValue],  @"Chained objects \"character\" value doesn't match!");
    STAssertEquals(integer,   [[chained valueForKey:@"integer"] integerValue], @"Chained objects \"integer\" value doesn't match!");
    STAssertEquals(floating,  [[chained valueForKey:@"floating"] floatValue],  @"Chained objects \"floating\" value doesn't match!");
}

// Test wether the value classes are returned correctly, for both the automatic guessing and the custom implementations
- (void)testValueClass
{
    JUAssertValueClass(object, @"character", NSNumber);
    JUAssertValueClass(object, @"integer", NSNumber);
    JUAssertValueClass(object, @"floating", NSNumber);
    
    JUAssertValueClass(objectWithoutValueClass, @"character", NSNumber);
    JUAssertValueClass(objectWithoutValueClass, @"integer", NSNumber);
    JUAssertValueClass(objectWithoutValueClass, @"floating", NSNumber);
}

@end
