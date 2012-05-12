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
#import "JUTableViewProxy.h"

static NSString *JUTableViewProxyKey = @"JUTableViewProxyKey";


@implementation UITableView (JUBindingAddition)

+ (void)initializeBindings
{
    [self exposeBinding:@"content"];
}


- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if([key isEqualToString:@"content"])
    {
        JUTableViewProxy *proxy = objc_getAssociatedObject(self, JUTableViewProxyKey);
        [proxy setContent:value];
        
        return;
    }
    
    [super setValue:value forUndefinedKey:key];
}



- (void)setJUDataSource:(id<JUTableViewDataSource>)dataSource
{
    JUTableViewProxy *proxy = objc_getAssociatedObject(self, JUTableViewProxyKey);
    [proxy setDataSource:dataSource];
}


- (BOOL)wantsCustomBindingForBinding:(NSString *)binding
{
    if([binding isEqualToString:@"content"])
    {
        return YES;
    }
    
    return [super wantsCustomBindingForBinding:binding];
}

- (void)createCustomBindingWithExplicitBinding:(JUExplicitBinding *)binding
{
    if([[binding binding] isEqualToString:@"content"])
    {
        JUTableViewProxy *proxy = [[[JUTableViewProxy alloc] initWithTableView:self] autorelease];
        objc_setAssociatedObject(self, JUTableViewProxyKey, proxy, OBJC_ASSOCIATION_RETAIN);
    }
    
    [super createCustomBindingWithExplicitBinding:binding];
}

- (void)unbindCustomBinding:(JUExplicitBinding *)binding
{
    if([[binding binding] isEqualToString:@"content"])
    {
        objc_setAssociatedObject(self, JUTableViewProxyKey, nil, OBJC_ASSOCIATION_RETAIN);
    }
    
    [super unbindCustomBinding:binding];
}



- (Class)valueClassForBinding:(NSString *)bindingKey
{
    if([bindingKey isEqualToString:@"content"])
        return [NSArray class];
    
    return [super valueClassForBinding:bindingKey];
}

@end

__attribute__((constructor)) void _UITableViewInitBindings()
{
    [UITableView initializeBindings];
}