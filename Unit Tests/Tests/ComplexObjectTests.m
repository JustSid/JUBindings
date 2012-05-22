//
//  ComplexObjectTests.m
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

#import "ComplexObjectTests.h"
#import "TestHelper.h"

@implementation ComplexObjectTests
@synthesize character, integer, floating, source, string, data, dictionary;

- (void)setUpBindingsForObject:(id)tobject
{
    [tobject bind:@"object"      toObject:self withKeyPath:@"source"        options:nil];
    [tobject bind:@"string"      toObject:self withKeyPath:@"string"        options:nil];
    [tobject bind:@"data"        toObject:self withKeyPath:@"data"          options:nil];
    [tobject bind:@"dictionary"  toObject:self withKeyPath:@"dictionary"    options:nil];
}

- (void)setUp
{
    [super setUp];
    
    object = [[ComplexObject alloc] init];
    chained = [[ComplexObject alloc] init];
    objectWithoutValueClass = [[ComplexObjectWithoutValueClass alloc] init];
    
    [self setUpBindingsForObject:object];
    [self setUpBindingsForObject:objectWithoutValueClass];
    
    [chained bind:@"object"     toObject:self withKeyPath:@"object.object"      options:nil];
    [chained bind:@"string"     toObject:self withKeyPath:@"object.string"      options:nil];
    [chained bind:@"data"       toObject:self withKeyPath:@"object.data"        options:nil];
    [chained bind:@"dictionary" toObject:self withKeyPath:@"object.dictionary"  options:nil];
    
    
    // Changet the values and objects
    self.character   = (char)arc4random_uniform(256);
    self.integer     = arc4random_uniform(NSIntegerMax);
    self.floating    = (float)character / 255.0f;
    
    self.source = [[SimpleObject alloc] init];
    [source bind:@"character" toObject:self withKeyPath:@"character" options:nil];
    [source bind:@"integer"   toObject:self withKeyPath:@"integer"   options:nil];
    [source bind:@"floating"  toObject:self withKeyPath:@"floating"  options:nil];
    
    self.string      = [[NSString alloc] initWithFormat:@"Hello %@", @"world"];
    self.data        = [string dataUsingEncoding:NSUTF8StringEncoding];
    self.dictionary  = [NSDictionary dictionaryWithObjects:JUArray(string, data) forKeys:JUArray(@"string", @"data")];
}

- (void)tearDown
{
    [chained release];
    [object release];
    [objectWithoutValueClass release];
    
    self.source = nil;
    self.string = nil;
    self.data = nil;
    self.dictionary = nil;

    [super tearDown];
}

#pragma mark -
#pragma mark Tests

// Test if changing the values also changes the bound values in object and objectWithoutValueClass
- (void)testValueChanges
{
    STAssertEqualObjects(string,        [object valueForKey:@"string"], @"ComplexObjects \"string\" value doesn't match!");
    STAssertEqualObjects(data,          [object valueForKey:@"data"], @"ComplexObjects \"data\" value doesn't match!");
    STAssertEqualObjects(dictionary,    [object valueForKey:@"dictionary"], @"ComplexObjects \"dictionary\" value doesn't match!");
    
    STAssertEqualObjects(string,        [objectWithoutValueClass valueForKey:@"string"], @"ComplexObjectWithoutValueClass's \"string\" value doesn't match!");
    STAssertEqualObjects(data,          [objectWithoutValueClass valueForKey:@"data"], @"ComplexObjectWithoutValueClass's \"data\" value doesn't match!");
    STAssertEqualObjects(dictionary,    [objectWithoutValueClass valueForKey:@"dictionary"], @"ComplexObjectWithoutValueClass's \"dictionary\" value doesn't match!");
    
}

// Test if key pathes work correctly
- (void)testKeyPathes
{
    STAssertEqualObjects(string,        [chained valueForKey:@"string"], @"Chained objects \"string\" value doesn't match!");
    STAssertEqualObjects(data,          [chained valueForKey:@"data"], @"Chained objects \"data\" value doesn't match!");
    STAssertEqualObjects(dictionary,    [chained valueForKey:@"dictionary"], @"Chained objects \"dictionary\" value doesn't match!");
}

// Test wether the value classes are returned correctly, for both the automatic guessing and the custom implementations
- (void)testValueClass
{
    JUAssertValueClass(object, @"object", SimpleObject);
    JUAssertValueClass(object, @"string", NSString);
    JUAssertValueClass(object, @"data", NSData);
    JUAssertValueClass(object, @"dictionary", NSDictionary);
    
    JUAssertValueClass(objectWithoutValueClass, @"object", SimpleObject);
    JUAssertValueClass(objectWithoutValueClass, @"string", NSString);
    JUAssertValueClass(objectWithoutValueClass, @"data", NSData);
    JUAssertValueClass(objectWithoutValueClass, @"dictionary", NSDictionary);
}

@end
