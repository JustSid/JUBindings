//
//  SimpleObjectSpec.m
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

SPEC_BEGIN(SimpleObjectSpec)

context(@"Simple object", ^{
    __block SimpleObject *object;
    __block SimpleObjectWithoutValueClass *objectWithoutValueClass;
    __block TestObject *testObject;
    
    beforeEach(^{
        object = [[SimpleObject alloc] init];
        objectWithoutValueClass = [[SimpleObjectWithoutValueClass alloc] init];
        
        testObject = [[TestObject alloc] init];
        
        
        [object bind:@"character" toObject:testObject withKeyPath:@"character" options:nil];
        [object bind:@"integer"   toObject:testObject withKeyPath:@"integer"   options:nil];
        [object bind:@"floating"  toObject:testObject withKeyPath:@"floating"  options:nil];
        
        [objectWithoutValueClass bind:@"character" toObject:testObject withKeyPath:@"character" options:nil];
        [objectWithoutValueClass bind:@"integer"   toObject:testObject withKeyPath:@"integer"   options:nil];
        [objectWithoutValueClass bind:@"floating"  toObject:testObject withKeyPath:@"floating"  options:nil];
        
        // Change the values
        testObject.character = (char)arc4random_uniform(256);
        testObject.integer = arc4random_uniform(NSIntegerMax);
        testObject.floating = (float)testObject.character / 255.0f;
    });
    
    afterEach(^{
        [object release];
        [objectWithoutValueClass release];
        
        [testObject release];
    });
    
    
    
    it(@"should change the bound values", ^{
        KWValue *character = theValue(testObject.character);
        KWValue *integer   = theValue(testObject.integer);
        KWValue *floating  = theValue(testObject.floating);
        
        [[theValue([[object valueForKey:@"character"] charValue]) should] equal:character];
        [[theValue([[object valueForKey:@"integer"] intValue]) should] equal:integer];
        [[theValue([[object valueForKey:@"floating"] floatValue]) should] equal:floating];
        
        [[theValue([[objectWithoutValueClass valueForKey:@"character"] charValue]) should] equal:character];
        [[theValue([[objectWithoutValueClass valueForKey:@"integer"] intValue]) should] equal:integer];
        [[theValue([[objectWithoutValueClass valueForKey:@"floating"] floatValue]) should] equal:floating];
    });
    
    it(@"should get valueForClassForBinding: right", ^{
        [[theValue([[object valueClassForBinding:@"character"] isSubclassOfClass:[NSNumber class]]) should] beTrue];
        [[theValue([[object valueClassForBinding:@"integer"] isSubclassOfClass:[NSNumber class]]) should] beTrue];
        [[theValue([[object valueClassForBinding:@"floating"] isSubclassOfClass:[NSNumber class]]) should] beTrue];
        
        [[theValue([[objectWithoutValueClass valueClassForBinding:@"character"] isSubclassOfClass:[NSNumber class]]) should] beTrue];
        [[theValue([[objectWithoutValueClass valueClassForBinding:@"integer"] isSubclassOfClass:[NSNumber class]]) should] beTrue];
        [[theValue([[objectWithoutValueClass valueClassForBinding:@"floating"] isSubclassOfClass:[NSNumber class]]) should] beTrue];
    });
});

SPEC_END
