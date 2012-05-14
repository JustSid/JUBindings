//
//  RootViewController.m
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

#import "RootViewController.h"
#import "LabelDemoViewController.h"
#import "DefaultsDemoViewController.h"
#import "TableDemoViewController.h"

@implementation RootViewController

#pragma mark -
#pragma mark Sorting

- (IBAction)toggleSortingAction:(UIBarButtonItem *)sender
{
    if([[arrayController sortDescriptors] count] > 0)
    {
        [arrayController setSortDescriptors:nil];
        [sender setStyle:UIBarButtonItemStylePlain];
    }
    else {
        NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
        [arrayController setSortDescriptors:[NSArray arrayWithObject:descriptor]];
        
        [sender setStyle:UIBarButtonItemStyleDone];
    }
}


#pragma mark -
#pragma mark Table View

- (void)tableView:(UITableView *)ttableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [ttableView cellForRowAtIndexPath:indexPath];  
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dictionary = [cell valueForKey:@"object"];
    NSString *nib = [dictionary objectForKey:@"nibName"];
    Class class = [dictionary objectForKey:@"viewController"];
    
    UIViewController *controller = [[class alloc] initWithNibName:nib bundle:nil];
    [controller bind:@"title" toObject:cell withKeyPath:@"object.title" options:nil];
    [controller autorelease];
    
    [[self navigationController] pushViewController:controller animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)ttableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"] autorelease];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        
        [cell.textLabel bind:@"text" toObject:cell withKeyPath:@"object.title" options:nil];
        [cell.detailTextLabel bind:@"text" toObject:cell withKeyPath:@"object.subtitle" options:nil];
    }
    
    return cell;
}


#pragma mark -
#pragma mark View Controller

- (NSDictionary *)dictionaryForEntryWithTitle:(NSString *)title subtitle:(NSString *)subtitle viewController:(Class)vcclass andNibName:(NSString *)nib
{
    return [NSDictionary dictionaryWithObjectsAndKeys:title, @"title", subtitle, @"subtitle", vcclass, @"viewController", nib, @"nibName", nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"JUBindings"];
    
    // Create the array controller
    arrayController = [[JUArrayController alloc] initWithContent:nil];
    [arrayController bind:@"contentArray" toObject:self withKeyPath:@"entries" options:nil];
    
    // Bind the tableview
    [tableView bind:@"content" toObject:arrayController withKeyPath:@"arrangedObjects" options:nil];
    [tableView setJUDataSource:self];
    [tableView setDelegate:self];
    
    
    // Add the entries
    [self willChangeValueForKey:@"entries"];
    
    entries = [[NSMutableArray alloc] init];
    [entries addObject:[self dictionaryForEntryWithTitle:@"Label & Slider" subtitle:@"A label bound to a slider" viewController:[LabelDemoViewController class] andNibName:@"LabelDemoView"]];
    [entries addObject:[self dictionaryForEntryWithTitle:@"User Defaults" subtitle:@"User defaults bound to objects" viewController:[DefaultsDemoViewController class] andNibName:@"DefaultsDemoView"]];
    [entries addObject:[self dictionaryForEntryWithTitle:@"Table View" subtitle:@"Table view with sections and search" viewController:[TableDemoViewController class] andNibName:@"TableDemoView"]];
    
    [self didChangeValueForKey:@"entries"];
    
    // Add the sort button
    UIBarButtonItem *sortItem = [[UIBarButtonItem alloc] initWithTitle:@"Sort" style:UIBarButtonItemStylePlain target:self action:@selector(toggleSortingAction:)];
    [[self navigationItem] setRightBarButtonItem:[sortItem autorelease]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [entries release];
    [arrayController release];
    
    entries = nil;
    arrayController = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
