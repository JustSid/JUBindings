//
//  BindingOptionsSpec.m
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

SPEC_BEGIN(BindingOptions)

describe(@"Binding options", ^{
    __block SimpleObject    *simpleObject  = nil;
    __block ComplexObject   *complexObject = nil;
    __block TestObject      *testObject = nil;
    
    beforeEach(^{
        testObject = [[TestObject alloc] init];
        complexObject = [[ComplexObject alloc] init];
        simpleObject = [[SimpleObject alloc] init];
    });
    
    afterEach(^{
        [simpleObject release];
        [complexObject release];
        [testObject release];
        
        simpleObject = nil;
        complexObject = nil;
        testObject = nil;
    });
    
    
    
    context(@"Value transformer", ^{
        beforeEach(^{
            JUValueTransformerTransform block = ^id(id object) {
                char character = (char)[object characterAtIndex:0];
                return [NSNumber numberWithChar:character];
            };
            
            JUValueTransformer *transformer = [[JUValueTransformer alloc] initWithTransformBlock:block];
            NSDictionary *options = [NSDictionary dictionaryWithObject:[transformer autorelease] forKey:NSValueTransformerBindingOption];
            
            [simpleObject bind:@"character" toObject:testObject withKeyPath:@"characterString" options:options];
        });
        
        
        
        it(@"should transform correctly", ^{
            [testObject setCharacterString:@"Hello World"];
            [[theValue([simpleObject character]) should] equal:theValue((char)'H')];
            
            [testObject setCharacterString:@"dlroW olleH"];
            [[theValue([simpleObject character]) should] equal:theValue((char)'d')];
        });
    });
    
    
    context(@"Null placeholder", ^{
        __block NSString *placeholder;
        
        beforeEach(^{
            placeholder = [[NSString alloc] initWithFormat:@"Hello %@", @"world"];
            
            NSDictionary *options = [NSDictionary dictionaryWithObject:[placeholder autorelease] forKey:NSNullPlaceholderBindingOption];
            [complexObject bind:@"string" toObject:testObject withKeyPath:@"nilString" options:options];
        });
        
        
        it(@"should replace NULL", ^{
            [testObject setNilString:nil];
            [[[complexObject string] should] equal:placeholder];
            
            [testObject setNilString:@"Good bye"];
            [testObject setNilString:nil];
            
            [[[complexObject string] should] equal:placeholder];
        });
        
        it(@"should not replace non NULL", ^{
            [testObject setNilString:@"Good bye"];
            [[[complexObject string] should] equal:[testObject nilString]];
        });
    });
    
    context(@"Allows NULL argument", ^{
        beforeEach(^{
            NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:NSAllowsNullArgumentBindingOption];
            [complexObject bind:@"string" toObject:testObject withKeyPath:@"nilString" options:options];
        });
        
        
        it(@"should not change the string", ^{
            NSString *string = @"Hello World";
            
            [testObject setNilString:string];
            [testObject setNilString:nil];
            
            [[[complexObject string] should] equal:string];
        });
    });
});



SPEC_END
