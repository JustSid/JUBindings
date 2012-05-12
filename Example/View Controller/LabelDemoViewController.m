//
//  LabelDemoViewController.m
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

#import "LabelDemoViewController.h"

@implementation LabelDemoViewController
@synthesize color;

- (IBAction)randomizeColorAction:(id)sender
{
    float r = (float)arc4random_uniform(255);
    float g = (float)arc4random_uniform(255);
    float b = (float)arc4random_uniform(255);
    
    self.color = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.000];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSMutableDictionary *options = [NSMutableDictionary dictionary];
    [options setObject:[UIColor blueColor] forKey:NSNullPlaceholderBindingOption];
    
    [valueLabel bind:@"text" toObject:slider withKeyPath:@"value" options:nil];
    [valueLabel bind:@"textColor" toObject:self withKeyPath:@"color" options:options];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [valueLabel unbind:@"text"];
    [valueLabel unbind:@"textColor"];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
