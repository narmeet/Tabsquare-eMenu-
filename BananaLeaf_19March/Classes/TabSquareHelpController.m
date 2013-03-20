//
//  TabSquareHelpController.m
//  TabSquareMenu
//
//  Created by Nikhil Kumar on 8/21/12.
//  Copyright (c) 2012 Trendsetterz. All rights reserved.
//

#import "TabSquareHelpController.h"


@implementation TabSquareHelpController

@synthesize helpOverlay;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)removeClicked:(id)sender
{
    [self.view removeFromSuperview];
}

@end
