//
//  JUObjectController.m
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

#import "JUObjectController.h"
#import "JUBindings.h"

@interface JUObjectController ()
{
    id content;
}

@end

@implementation JUObjectController
@synthesize content;

+ (void)initializeBindings
{
    [self exposeBinding:@"content"];
}

- (Class)valueClassForBinding:(NSString *)binding
{
    if([binding isEqualToString:@"content"])
        return [NSObject class];
    
    return [super valueClassForBinding:binding];
}



- (id)selection
{
    return content;
}

- (NSArray *)selectedObjects
{
    return [NSArray arrayWithObject:content];
}



- (id)initWithContent:(id)tcontent
{
    if((self = [super init]))
    {
        self.content = tcontent;
    }
    
    return self;
}

- (void)dealloc
{
    [content release];
    [super dealloc];
}

@end

__attribute__((constructor)) void _JUObjectControllerInitBindings()
{
    [JUObjectController initializeBindings];
}
