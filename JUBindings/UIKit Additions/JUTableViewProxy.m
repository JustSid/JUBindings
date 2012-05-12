//
//  JUTableViewProxy.m
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

#import "JUTableViewProxy.h"

@implementation JUTableViewProxy
@synthesize content, dataSource;

- (void)setContent:(NSArray *)tcontent
{
    [content autorelease];
    content = [tcontent retain];
    
    [tableView reloadData];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [content count];
}

- (UITableViewCell *)tableView:(UITableView *)ttableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    assert(dataSource);
    
    UITableViewCell *cell = [dataSource tableView:tableView cellForRowAtIndexPath:indexPath];
    [cell setValue:[content objectAtIndex:indexPath.row] forKey:@"object"];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)ttableView titleForHeaderInSection:(NSInteger)section
{
    if([dataSource respondsToSelector:@selector(tableView:titleForHeaderInSection:)])
        return [dataSource tableView:ttableView titleForHeaderInSection:section];
    
    return nil;
}

- (NSString *)tableView:(UITableView *)ttableView titleForFooterInSection:(NSInteger)section
{
    if([dataSource respondsToSelector:@selector(tableView:titleForFooterInSection:)])
        return [dataSource tableView:ttableView titleForFooterInSection:section];
    
    return nil;
}

- (BOOL)tableView:(UITableView *)ttableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([dataSource respondsToSelector:@selector(tableView:canEditRowAtIndexPath:)])
        return [dataSource tableView:ttableView canEditRowAtIndexPath:indexPath];
    
    return NO;
}

- (BOOL)tableView:(UITableView *)ttableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([dataSource respondsToSelector:@selector(tableView:canMoveRowAtIndexPath:)])
        return [dataSource tableView:ttableView canMoveRowAtIndexPath:indexPath];
    
    return NO;
}

- (void)tableView:(UITableView *)ttableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([dataSource respondsToSelector:@selector(tableView:commitEditingStyle:forRowAtIndexPath:)])
        [dataSource tableView:ttableView commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)ttableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    if([dataSource respondsToSelector:@selector(tableView:moveRowAtIndexPath:forRowAtIndexPath:)])
        [dataSource tableView:ttableView moveRowAtIndexPath:sourceIndexPath toIndexPath:destinationIndexPath];
}





- (id)initWithTableView:(UITableView *)ttableView
{
    if((self = [super init]))
    {
        tableView = ttableView;
        
        [tableView setDataSource:self];
    }
    
    return self;
}

- (void)dealloc
{
    [content release];
    [tableView setDataSource:nil];
    
    [super dealloc];
}

@end
