//
//  ComplexObjectSpec.m
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

SPEC_BEGIN(ComplexObjectSpec)

context(@"Simple object", ^{
    __block ComplexObject *object;
    __block ComplexObjectWithoutValueClass *objectWithoutValueClass;
    __block TestObject *testObject;
    
    beforeEach(^{
        object = [[ComplexObject alloc] init];
        objectWithoutValueClass = [[ComplexObjectWithoutValueClass alloc] init];
        
        testObject = [[TestObject alloc] init];
        
        
        [object bind:@"object"      toObject:testObject withKeyPath:@"source"        options:nil];
        [object bind:@"string"      toObject:testObject withKeyPath:@"string"        options:nil];
        [object bind:@"data"        toObject:testObject withKeyPath:@"data"          options:nil];
        [object bind:@"dictionary"  toObject:testObject withKeyPath:@"dictionary"    options:nil];
        
        [objectWithoutValueClass bind:@"object"      toObject:testObject withKeyPath:@"source"        options:nil];
        [objectWithoutValueClass bind:@"string"      toObject:testObject withKeyPath:@"string"        options:nil];
        [objectWithoutValueClass bind:@"data"        toObject:testObject withKeyPath:@"data"          options:nil];
        [objectWithoutValueClass bind:@"dictionary"  toObject:testObject withKeyPath:@"dictionary"    options:nil];
        
        
        // Change the values
        testObject.character = (char)arc4random_uniform(256);
        testObject.integer = arc4random_uniform(NSIntegerMax);
        testObject.floating = (float)testObject.character / 255.0f;
        
        testObject.source = [[SimpleObject alloc] init];
        [testObject.source bind:@"character" toObject:testObject withKeyPath:@"character" options:nil];
        [testObject.source bind:@"integer"   toObject:testObject withKeyPath:@"integer"   options:nil];
        [testObject.source bind:@"floating"  toObject:testObject withKeyPath:@"floating"  options:nil];
        
        testObject.string      = [[NSString alloc] initWithFormat:@"Hello %@", @"world"];
        testObject.data        = [testObject.string dataUsingEncoding:NSUTF8StringEncoding];
        testObject.dictionary  = [NSDictionary dictionaryWithObjects:JUArray(testObject.string, testObject.data) forKeys:JUArray(@"string", @"data")];
    });
    
    afterEach(^{
        [object release];
        [objectWithoutValueClass release];
        
        [testObject release];
    });
    
    
    
    it(@"should change the bound values", ^{
        [[[object valueForKey:@"string"] should] equal:[testObject string]];
        [[[object valueForKey:@"data"] should] equal:[testObject data]];
        [[[object valueForKey:@"dictionary"] should] equal:[testObject dictionary]];
        
        [[[objectWithoutValueClass valueForKey:@"string"] should] equal:[testObject string]];
        [[[objectWithoutValueClass valueForKey:@"data"] should] equal:[testObject data]];
        [[[objectWithoutValueClass valueForKey:@"dictionary"] should] equal:[testObject dictionary]];
    });
    
    it(@"should get valueForClassForBinding: right", ^{
        [[theValue([[object valueClassForBinding:@"object"] isSubclassOfClass:[SimpleObject class]]) should] beTrue];
        [[theValue([[object valueClassForBinding:@"string"] isSubclassOfClass:[NSString class]]) should] beTrue];
        [[theValue([[object valueClassForBinding:@"data"] isSubclassOfClass:[NSData class]]) should] beTrue];
        [[theValue([[object valueClassForBinding:@"dictionary"] isSubclassOfClass:[NSDictionary class]]) should] beTrue];
        
        [[theValue([[objectWithoutValueClass valueClassForBinding:@"object"] isSubclassOfClass:[SimpleObject class]]) should] beTrue];
        [[theValue([[objectWithoutValueClass valueClassForBinding:@"string"] isSubclassOfClass:[NSString class]]) should] beTrue];
        [[theValue([[objectWithoutValueClass valueClassForBinding:@"data"] isSubclassOfClass:[NSData class]]) should] beTrue];
        [[theValue([[objectWithoutValueClass valueClassForBinding:@"dictionary"] isSubclassOfClass:[NSDictionary class]]) should] beTrue];
    });
});

SPEC_END
