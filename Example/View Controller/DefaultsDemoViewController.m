//
//  DefaultsDemoViewController.m
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

#import "DefaultsDemoViewController.h"

@implementation DefaultsDemoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    defaultsController = [JUUserDefaultsController sharedDefaultsController];
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO], NSNullPlaceholderBindingOption, nil];
	
    [onSwitch bind:@"on" toObject:defaultsController withKeyPath:@"DemoSwitchState" options:options];
    [textField bind:@"text" toObject:defaultsController withKeyPath:@"DemoTextField" options:nil];
    
    [defaultsController bind:@"DemoSwitchState" toObject:onSwitch withKeyPath:@"on" options:nil];
    [defaultsController bind:@"DemoTextField" toObject:textField withKeyPath:@"text" options:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [onSwitch unbind:@"on"];
    [textField unbind:@"text"];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
