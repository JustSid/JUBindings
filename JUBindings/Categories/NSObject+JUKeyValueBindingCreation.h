//
//  NSObject+JUKeyValueBindingCreation.h
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

#import <Foundation/Foundation.h>
#import "JUExplicitBinding.h"

@interface NSObject (JUKeyValueBindingCreation)

+ (void)exposeBinding:(NSString *)binding;
- (NSArray *)exposedBindings;


- (void)bind:(NSString *)binding toObject:(id)observableController withKeyPath:(NSString *)keyPath options:(NSDictionary *)options;
- (void)unbind:(NSString *)binding;


- (Class)valueClassForBinding:(NSString *)binding;
- (NSDictionary *)infoForBinding:(NSString *)binding;
- (NSArray *)optionDescriptionsForBinding:(NSString *)binding;


// Non standard stuff, only used for classes which don't provide enough KVC/KVO capabilities to work out of the box
- (void)createCustomBindingWithExplicitBinding:(JUExplicitBinding *)binding;
- (void)unbindCustomBinding:(JUExplicitBinding *)binding;
- (BOOL)wantsCustomBindingForBinding:(NSString *)binding;
- (BOOL)wantsKVOBindingForBinding:(NSString *)binding;

@end

extern NSString *NSValueTransformerBindingOption;
extern NSString *NSNullPlaceholderBindingOption;

extern NSString *NSObservedObjectKey;
extern NSString *NSObservedKeyPathKey;
extern NSString *NSOptionsKey;
