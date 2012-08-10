/*
 MedListViewController.h
 SMART Medications Sample

 Created by Pascal Pfiffner on 8/10/12.
 Copyright (c) 2012 CHIP, Boston Children's Hospital. All rights reserved.
 
 This library is free software; you can redistribute it and/or
 modify it under the terms of the GNU Lesser General Public
 License as published by the Free Software Foundation; either
 version 2.1 of the License, or (at your option) any later version.
 
 This library is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 Lesser General Public License for more details.
 
 You should have received a copy of the GNU Lesser General Public
 License along with this library; if not, write to the Free Software
 Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
 */

#import "MedListViewController.h"
#import "SMAppDelegate.h"
#import "MedViewController.h"
#import "SMServer.h"
#import "SMRecord.h"
#import "SMARTDocuments.h"


@interface MedListViewController ()

- (void)selectRecord:(id)sender;
- (void)cancelSelection:(id)sender;
- (void)setRecordButtonTitle:(NSString *)aTitle;
- (void)showMedication:(SMMedication *)aMedication animated:(BOOL)animated;

@end


@implementation MedListViewController

@synthesize activeRecord, meds;


#pragma mark - View Handling
- (void)viewDidLoad
{
	self.title = @"Medications";
    [super viewDidLoad];
	
	// add our connect button to the left
	[self setRecordButtonTitle:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIDeviceOrientationIsPortrait(interfaceOrientation);
}




#pragma mark - Record Handling
/**
 *	Called when the user logged out
 */
- (void)unloadData
{
	self.navigationItem.rightBarButtonItem.enabled = NO;
	self.activeRecord = nil;
	self.meds = nil;
	[self.tableView reloadData];
	[self setRecordButtonTitle:nil];
}

/**
 *	Connecting to the server retrieves the records of your users account
 */
- (void)selectRecord:(id)sender
{
	// create an activity indicator to show that something is happening
	UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	UIBarButtonItem *activityButton = [[UIBarButtonItem alloc] initWithCustomView:activityView];
	[activityButton setTarget:self];
	[activityButton setAction:@selector(cancelSelection:)];
	self.navigationItem.leftBarButtonItem = activityButton;
	[activityView startAnimating];
	
	// select record
	[APP_DELEGATE.smart selectRecord:^(BOOL userDidCancel, NSString *errorMessage) {
		
		// there was an error selecting the record
		if (errorMessage) {
//			[self setRecordButtonTitle:[activeRecord label]];
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed to connect"
															message:errorMessage
														   delegate:nil
												  cancelButtonTitle:@"OK"
												  otherButtonTitles:nil];
			[alert show];
		}
		
		// successfully selected record, fetch medications
		else if (!userDidCancel) {
			self.activeRecord = [APP_DELEGATE.smart activeRecord];
//			[self setRecordButtonTitle:[activeRecord label]];
			self.navigationItem.rightBarButtonItem.enabled = (nil != self.activeRecord);
			
			/// @todo Fetch medications here
		}
		
		// cancelled
		else {
			[self setRecordButtonTitle:nil];
		}
	}];
}

/**
 *	Cancels current connection attempt
 */
- (void)cancelSelection:(id)sender
{
	/// @todo cancel if still in progress
	[self setRecordButtonTitle:nil];
}

/**
 *	Reverts the navigation bar "connect" button
 */
- (void)setRecordButtonTitle:(NSString *)aTitle
{
	NSString *title = ([aTitle length] > 0) ? aTitle : @"Connect";
	UIBarButtonItem *connectButton = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStyleBordered target:self action:@selector(selectRecord:)];
	self.navigationItem.leftBarButtonItem = connectButton;
}



#pragma mark - Medication Handling
/**
 *	Called when the user taps a medication row, shows the details for the selected medication
 */
- (void)showMedication:(SMMedication *)aMedication animated:(BOOL)animated
{
	if (aMedication) {
		MedViewController *viewController = [MedViewController new];
		viewController.medication = aMedication;
		[self.navigationController pushViewController:viewController animated:animated];
	}
}



#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (0 == section) {
		return [meds count];
	}
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
	if (0 == indexPath.section && [meds count] > indexPath.row) {
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		}
		
		// display the name
		SMMedication *med = [meds objectAtIndex:indexPath.row];
		cell.textLabel.text = [med description];
		return cell;
	}
	return nil;
}



#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (0 != indexPath.section || indexPath.row >= [meds count]) {
		return;
	}
	
	SMMedication *selected = [meds objectAtIndex:indexPath.row];
    [self showMedication:selected animated:YES];
}

@end
