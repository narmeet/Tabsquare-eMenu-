
#import <UIKit/UIKit.h>
#import "GNWheelView.h"

@interface LanguageSelectionView : UIControl <UITableViewDelegate, UITableViewDataSource> {
    
    UITableView *flagTableView;
    UIButton    *senderButton;
    UIButton    *englishFlag;
    
    NSMutableArray *flags;
    
    int rowHeight;
}


-(id)initWithFrame:(CGRect)frame sender:(UIButton *)btn;
-(void)loadTableView;
-(void)setFlag;


@end
