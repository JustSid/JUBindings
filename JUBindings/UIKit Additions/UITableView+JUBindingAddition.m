//
//  UITableView+JUBindingAddition.m
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

#import <objc/runtime.h>
#import "UITableView+JUBindingAddition.h"
#import "NSString+JUMassComparison.h"
#import "JUBindings.h"
#import "JUTableViewProxy.h"

static NSString *JUTableViewProxyKey = @"JUTableViewProxyKey";


@implementation UITableView (JUBindingAddition)

+ (void)initializeBindings
{
    [self exposeBinding:@"content"];
    [self exposeBinding:@"rowHeight"];
    [self exposeBinding:@"seperatorStyle"];
    [self exposeBinding:@"seperatorColor"];
    [self exposeBinding:@"backgroundView"];
    [self exposeBinding:@"tableHeaderView"];
    [self exposeBinding:@"tableFooterView"];
    [self exposeBinding:@"sectionHeaderHeight"];
    [self exposeBinding:@"sectionFooterHeight"];
    [self exposeBinding:@"sectionIndexMinimumDisplayRowCount"];
    [self exposeBinding:@"allowsSelection"];
    [self exposeBinding:@"allowsMultipleSelection"];
    [self exposeBinding:@"allowsSelectionDuringEditing"];
    [self exposeBinding:@"allowsMultipleSelectionDuringEditing"];
    [self exposeBinding:@"editing"];
}

- (Class)valueClassForBinding:(NSString *)binding
{
    if([binding isEqualToString:@"content"])
        return [NSArray class];
    
    if([binding ju_isEqualToAnyStringInArray:JUArray(@"rowHeight", @"seperatorStyle", @"sectionHeaderHeight", @"sectionFooterHeight", @"sectionFooterHeight", @"sectionIndexMinimumDisplayRowCount")])
        return [NSNumber class];
    
    if([binding ju_isEqualToAnyStringInArray:JUArray(@"allowsSelection", @"allowsMultipleSelection", @"allowsSelectionDuringEditing", @"allowsMultipleSelectionDuringEditing", @"editing")])
        return [NSNumber class];
    
    if([binding ju_isEqualToAnyStringInArray:JUArray(@"backgroundView", @"tableHeaderView", @"tableFooterView")])
        return [UIView class];
    
    if([binding isEqualToString:@"seperatorColor"])
        return [UIColor class];
    
    return [super valueClassForBinding:binding];
}




- (JUTableViewProxy *)jutableProxy
{
    JUTableViewProxy *proxy = objc_getAssociatedObject(self, JUTableViewProxyKey);
    if(!proxy)
    {
        proxy = [[[JUTableViewProxy alloc] initWithTableView:self] autorelease];
        objc_setAssociatedObject(self, JUTableViewProxyKey, proxy, OBJC_ASSOCIATION_RETAIN);
    }
    
    return proxy;
}


- (void)setContent:(NSArray *)content
{
    JUTableViewProxy *proxy = [self jutableProxy];
    [proxy setContent:content];
}

- (void)setJUDataSource:(id<JUTableViewDataSource>)dataSource
{
    JUTableViewProxy *proxy = [self jutableProxy];
    [proxy setDataSource:dataSource];
}




@end

__attribute__((constructor)) void _UITableViewInitBindings()
{
    [UITableView initializeBindings];
}
