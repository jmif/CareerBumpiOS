//
//  CBRecruiterTableViewController.m
//  CareerBump
//
//  Created by Joseph Mifsud on 3/20/13.
//  Copyright (c) 2013 Joseph Mifsud. All rights reserved.
//

static const CGFloat kAddResumeHeaderHeight = 50.0;
static const CGFloat kReceiveResumePullThreshold = 65.0;


#import "CBRecruiterTableViewController.h"
#import "CBReceiveResumeViewController.h"

@interface CBRecruiterTableViewController ()

@property (strong, nonatomic) CBReceiveResumeViewController *receiveResumeController;
@property (strong, nonatomic) UIView *addResumeHeaderHolder;

@end

@implementation CBRecruiterTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.addResumeHeaderHolder = [[UIView alloc] initWithFrame:CGRectMake(0, -1 * kAddResumeHeaderHeight - 2, self.view.frame.size.width, kAddResumeHeaderHeight)];
    self.addResumeHeaderHolder.backgroundColor = [UIColor clearColor];
    
    UILabel *receiveResumeLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 0, self.addResumeHeaderHolder.frame.size.width - 45, kAddResumeHeaderHeight)];
    receiveResumeLabel.adjustsFontSizeToFitWidth = YES;
    receiveResumeLabel.text = @"Receive a Resume...";
    
    [self.addResumeHeaderHolder addSubview:receiveResumeLabel];
    
    [self.tableView addSubview:self.addResumeHeaderHolder];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.addResumeHeaderHolder.hidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Scroll view delegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offset = self.tableView.contentOffset.y;
    
    if (offset < 0) {
        self.addResumeHeaderHolder.alpha = (-1 * offset) / kReceiveResumePullThreshold;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.tableView setContentOffset:CGPointZero animated:YES];
    if (self.tableView.contentOffset.y < -1 * kReceiveResumePullThreshold) {
        self.addResumeHeaderHolder.hidden = YES;
        [self performSegueWithIdentifier:@"receiveResumeSegue" sender:self];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
