//
//  JUBindings.h
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

#import "NSObject+JUAssociatedSet.h"
#import "NSObject+JUKeyValueBindingCreation.h"
#import "NSString+JUMassComparison.h"


#import "JUExplicitBinding.h"
#import "JUBindingProxy.h"
#import "JUValueTransformer.h"

#import "JUObjectController.h"
#import "JUUserDefaultsController.h"
#import "JUArrayController.h"
#import "JUTableController.h"

#import "UITableView+JUBindingAddition.h"

#if defined(DEBUG) || defined(JUBindingEnableChecks)
    #define JUBindingsRuntimeChecks 1 // Adds extra runtime type checks at the cost of CPU load
    #define JUBindingAvailabilityChecks 1 // Adds checks wether a certain binding is available or not, at the cost of some extra CPU load
#endif
