
#import "LanguageSelectionView.h"
#import "ShareableData.h"
#import "LanguageControler.h"
#import <QuartzCore/QuartzCore.h>

@implementation LanguageSelectionView


/*==============Initializing the language selection scroller================*/

-(id)initWithFrame:(CGRect)frame sender:(UIButton *)btn
{
    self = [super initWithFrame:frame];
    
    
    senderButton = btn;
    
    if (self)
    {
        [self setBackgroundColor:[UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.4f]];
        
        [self addTarget:self action:@selector(removeView) forControlEvents:UIControlEventTouchUpInside];
        
        
        flags  = [ShareableData activeLanguages];
        
        rowHeight = 48;
        
        /*==============Setting Current Language as default================*/
        NSString *current_language = [NSString stringWithFormat:@"%@_flag.png", [ShareableData sharedInstance].currentLanguage];
        
        int index = [flags indexOfObject:current_language];
        
        if(index != 0) {
            [flags exchangeObjectAtIndex:index withObjectAtIndex:0];
        }
        /*=================================================================*/
        
        [self loadTableView];
    }
    
    return self;
}


-(void)removeView
{
    [self removeFromSuperview];
}

/*Create language selection scroller*/
-(void)loadTableView
{
	flagTableView			 = [[UITableView alloc] initWithFrame:CGRectMake(631.0, 760.0, 72.0, (rowHeight * [flags count]))];
    
    float new_y = senderButton.frame.origin.y - flagTableView.frame.size.height - 20;
        
    [flagTableView setFrame:CGRectMake(flagTableView.frame.origin.x, new_y, flagTableView.frame.size.width, flagTableView.frame.size.height)];
    
	flagTableView.delegate	 = self;
	flagTableView.dataSource = self;
	
	flagTableView.backgroundColor = [UIColor clearColor];
	flagTableView.showsVerticalScrollIndicator = NO;
	[flagTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [flagTableView setScrollEnabled:NO];
    
	[self addSubview:flagTableView];
    [flagTableView reloadData];
    [self performSelector:@selector(loadAnimation)];
}

-(void)loadAnimation
{
    [flagTableView beginUpdates];
    [flagTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationTop];
    [flagTableView endUpdates];
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [flags count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	return 48.0;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString* CellIdentifier = @"MessageCellIdentifier";
	
	UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:nil];
	if(cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}
	
	/*==================================================================*/
	
	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	[cell setTag:indexPath.row];
    
    UIButton *flag_btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 72.0, 48.0)];
    NSString *flag_name = [NSString stringWithFormat:@"%@", [flags objectAtIndex:indexPath.row]];
    [flag_btn setBackgroundImage:[UIImage imageNamed:flag_name] forState:UIControlStateNormal];
    [flag_btn setTag:indexPath.row];
    [flag_btn addTarget:self action:@selector(flagClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    if([flag_name isEqualToString:@"english_flag.png"]) {
        englishFlag = flag_btn;
    }
    
    [cell.contentView addSubview:flag_btn];
	
	return cell;
	
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	
}


-(void)flagClicked:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    
    int indx = btn.tag;
    
    [senderButton setBackgroundImage:[UIImage imageNamed:flags[indx]] forState:UIControlStateNormal];
    NSString *prev_lang = [NSString stringWithFormat:@"%@", [ShareableData sharedInstance].currentLanguage];
    NSString *flag = flags[indx];
    NSArray *arr = [flag componentsSeparatedByString:@"_"];
    [ShareableData sharedInstance].currentLanguage = [NSString stringWithFormat:@"%@", arr[0]];
    
    
    if(![prev_lang isEqualToString:arr[0]])
        [[LanguageControler languageController] UpdateCategoryData:senderButton.superview];
    
    [self removeView];
}


-(void)setFlag
{
    int indx = englishFlag.tag;
    
    [senderButton setBackgroundImage:[UIImage imageNamed:flags[indx]] forState:UIControlStateNormal];
    NSString *prev_lang = [NSString stringWithFormat:@"%@", [ShareableData sharedInstance].currentLanguage];
    NSString *flag = flags[indx];
    NSArray *arr = [flag componentsSeparatedByString:@"_"];
    [ShareableData sharedInstance].currentLanguage = [NSString stringWithFormat:@"%@", arr[0]];

    if(![prev_lang isEqualToString:arr[0]]) {
        [[LanguageControler languageController] changeLanguageInBackground];
    }
    

}

@end
