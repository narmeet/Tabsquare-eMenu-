
#import "TabSquarePrintViewController.h"
#import "ShareableData.h"

@interface TabSquarePrintViewController ()

@end

@implementation TabSquarePrintViewController

@synthesize printView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)loadView
{
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(20, 101,728, 883)];
    webView.tag = 121;
    NSURL *targetURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/webs/printable/2", [ShareableData serverURL]]];
    NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
    [webView  loadRequest:request];
    [self.view addSubview:webView];
}


- (void)viewDidLoad
{
    //[self loadView];
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

-(IBAction)backClicked:(id)sender
{
    //[self dismissModalViewControllerAnimated:YES];
     [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}







@end
