//
//  BindingOptionTests.m
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

#import "BindingOptionTests.h"
#import "TestHelper.h"
#import "JUValueTransformer.h"

@implementation BindingOptionTests
@synthesize nilString, characterString;

- (void)setUp
{
    [super setUp];
    
    simpleObject = [[SimpleObject alloc] init];
    complexObject = [[ComplexObject alloc] init];
}

- (void)tearDown
{
    [simpleObject release];
    [complexObject release];
    
    self.nilString = nil;
    self.characterString = nil;
    
    [super tearDown];
}



- (void)testValueTransformerBindingOption
{
    JUValueTransformerTransform block = ^id(id object) {
        char character = (char)[object characterAtIndex:0];
        return [NSNumber numberWithChar:character];
    };
    
    JUValueTransformer *transformer = [[JUValueTransformer alloc] initWithTransformBlock:block];
    NSMutableDictionary *options = [NSMutableDictionary dictionary];
    
    [options setObject:transformer forKey:NSValueTransformerBindingOption];
    [simpleObject bind:@"character" toObject:self withKeyPath:@"characterString" options:options];
    
    self.characterString = @"H";
    STAssertTrue(([simpleObject character] == 'H'), @"");
    
    [transformer release];
}

- (void)testNullPlaceholderBindingOption
{
    NSString *placeholder = [NSString stringWithFormat:@"Hello %@", @"world"];
    NSMutableDictionary *options = [NSMutableDictionary dictionary];
    
    [options setObject:placeholder forKey:NSNullPlaceholderBindingOption];
    [complexObject bind:@"string" toObject:self withKeyPath:@"nilString" options:options];
    
    // Test with a nil value
    self.nilString = nil;
    STAssertEqualObjects(placeholder, [complexObject valueForKey:@"string"], @"");
    
    // Test with a non nil value
    self.nilString = [NSString stringWithFormat:@"Hello cruel %@", @"world"];
    STAssertEqualObjects(nilString, [complexObject valueForKey:@"string"], @"");
}

- (void)testAllowsNullArgumentBindingOption
{
    NSMutableDictionary *options = [NSMutableDictionary dictionary];
    [options setObject:[NSNumber numberWithBool:NO] forKey:NSAllowsNullArgumentBindingOption];
    
    [complexObject bind:@"string" toObject:self withKeyPath:@"nilString" options:options];
    
    self.nilString = @"Hello";
    self.nilString = nil;
    
    STAssertEqualObjects([complexObject valueForKey:@"string"], @"Hello", @"");
}

@end
