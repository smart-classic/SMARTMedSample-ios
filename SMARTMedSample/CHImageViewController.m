//
//  CHImageViewController.m
//  Charts
//
//  Created by Pascal Pfiffner on 1/21/13.
//  Copyright (c) 2013 Boston Children's Hospital. All rights reserved.
//

#import "CHImageViewController.h"


@interface CHImageViewController ()

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIImageView *imageView;

@end


@implementation CHImageViewController

- (id)init
{
	return [super initWithNibName:nil bundle:nil];
}

- (void)loadView
{
	// create our views
	CGRect fullFrame = CGRectMake(0.f, 0.f, 500.f, 500.f);
	UIView *v = [[UIView alloc] initWithFrame:fullFrame];
	v.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
	v.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.view = v;
	
	UIScrollView *sv = [[UIScrollView alloc] initWithFrame:fullFrame];
	//sv.backgroundColor = ;
	sv.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[v addSubview: sv];
	self.scrollView = sv;
	
	UIImageView *iv = [[UIImageView alloc] initWithFrame:fullFrame];
	iv.autoresizingMask = UIViewAutoresizingNone;
	[sv addSubview:iv];
	self.imageView = iv;
	
	// a done button
	if (self.navigationController) {
		self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismiss:)];
	}
	
	// show an image?
	CGSize popSize = CGSizeMake(500.f, 500.f);
	if (_image) {
		_imageView.image = _image;
		//popSize.width = fminf(500.f, _image.size.width);
		//popSize.height = fminf(500.f, _image.size.height);
	}
	
	self.contentSizeForViewInPopover = popSize;
}

- (void)viewDidLayoutSubviews
{
	if (_image) {
		CGRect myFrame = self.view.frame;
		CGSize mySize = myFrame.size;
		CGSize imgSize = _image.size;
		
		CGFloat ratio = fminf(imgSize.width / mySize.width, imgSize.height / mySize.height);		// change to max to fit the whole image
		CGFloat width = roundf(imgSize.width / ratio);
		CGFloat height = roundf(imgSize.height / ratio);
		
		_imageView.frame = CGRectMake(0.f, 0.f, width, height);
		_scrollView.contentOffset = CGPointMake((width - mySize.width) / 2, (height - mySize.height) / 2);
		_scrollView.contentSize = CGSizeMake(width, height);
	}
}

- (void)setImage:(UIImage *)image
{
	if (image != _image) {
		_image = image;
		
		if ([self isViewLoaded]) {
			_imageView.image = _image;
		}
	}
}


- (void)dismiss:(id)sender
{
	[self.presentingViewController dismissViewControllerAnimated:(nil != sender) completion:NULL];
}


@end
