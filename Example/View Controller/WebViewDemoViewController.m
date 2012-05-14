//
//  WebViewDemoViewController.m
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

#import "WebViewDemoViewController.h"

@implementation WebViewDemoViewController
@synthesize url;

- (IBAction)appleAction:(id)sender
{
    self.url = [NSURL URLWithString:@"http://apple.com"];
}

- (IBAction)googleAction:(id)sender
{
    self.url = [NSURL URLWithString:@"http://google.com"];
}

- (IBAction)githubAction:(id)sender
{
    self.url = [NSURL URLWithString:@"https://github.com"];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
	urlTransformer = [[JUValueTransformer alloc] initWithTransformBlock:^id(id value) {
        NSURL *theURL = value;
        return [theURL host];
    }];
    
    // Bind the web views URL to our url
    [webView bind:@"URL" toObject:self withKeyPath:@"url" options:nil];
    // Bind the title of this view controller to the url. However, the title must be of type NSString and there is no conversion between NSURL to NSString built in, so we use the value transformer for this.
    [self bind:@"title" toObject:self withKeyPath:@"url" options:[NSDictionary dictionaryWithObject:urlTransformer forKey:NSValueTransformerBindingOption]];
    
    [self appleAction:self];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [urlTransformer release];
    urlTransformer = nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc
{
    [url release];
    [super dealloc];
}

@end
