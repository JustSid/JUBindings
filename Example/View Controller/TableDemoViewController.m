//
//  TableDemoViewController.m
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

#import "TableDemoViewController.h"

@implementation TableDemoViewController

#pragma mark -
#pragma mark Search bar

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSPredicate *predicate = ([searchText length] > 0 ) ? [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@", searchText] : nil;
    [tableController setFilterPredicate:predicate];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)tsearchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)tsearchBar
{
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)tsearchBar
{
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)tsearchBar
{
    [tableController setFilterPredicate:nil];
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar setText:@""];
    [searchBar resignFirstResponder];
}

#pragma mark -
#pragma mark Table View

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"] autorelease];
        
        [cell.textLabel bind:@"text" toObject:cell withKeyPath:@"object" options:nil];
    }
    
    return cell;
}

#pragma mark -
#pragma mark Misc

- (NSDictionary *)sectionWithHeader:(NSString *)header andEntries:(NSInteger)numEntries atIndex:(NSInteger)index 
{
    NSMutableArray *entries = [NSMutableArray arrayWithCapacity:numEntries];
    for(NSInteger i=0; i<numEntries; i++)
    {
        NSString *entry = [NSString stringWithFormat:@"Cell %i", i];
        
        [entries addObject:entry];
    }
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:header forKey:@"header"];
    [dictionary setObject:[NSString stringWithFormat:@"%i entries", numEntries] forKey:@"footer"];
    [dictionary setObject:[NSString stringWithFormat:@"%i", index]  forKey:@"title"];
    [dictionary setObject:entries forKey:@"entries"];
    
    return dictionary;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [contentTable setContentOffset:CGPointMake(0.0f, [searchBar frame].size.height)]; // Hide the search bar initially
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    tableController = [[JUTableController alloc] initWithContent:content];
    [tableController setSectionHeaderKey:@"header"];
    [tableController setSectionFooterKey:@"footer"];
    [tableController setSectionTitleKey:@"title"];
    [tableController setChildrenKey:@"entries"];
    
    [tableController bind:@"contentArray" toObject:self withKeyPath:@"content" options:nil];
    
    [contentTable setJUDataSource:self];
    [contentTable setDelegate:self];
    [contentTable setSectionIndexMinimumDisplayRowCount:5];
    [contentTable bind:@"content" toObject:tableController withKeyPath:@"arrangedObjects" options:nil];
    
    [self willChangeValueForKey:@"content"];
    
    // Create all sections
    NSMutableArray *array = [NSMutableArray array];
    NSInteger sections = arc4random_uniform(32) + 4;
    
    for(NSInteger i=0; i<sections; i++)
    {
        NSInteger entries = arc4random_uniform(10) + 2;
        NSDictionary *section = [self sectionWithHeader:[NSString stringWithFormat:@"Section %i", i] andEntries:entries atIndex:i];
        
        [array addObject:section];
    }
    
    content = [array retain];
    [self didChangeValueForKey:@"content"];
	
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [content release];
    content = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
