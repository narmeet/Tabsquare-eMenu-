

#import <UIKit/UIKit.h>

@interface PaymentModeView : UIView <UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate> {
    
    NSString        *totalAmount;
    NSArray         *paymentModes;
    NSMutableArray  *paymentName;
    NSMutableArray  *paymentAmount;
    
    int             currentBtn;
    
    UIPickerView    *paymentPicker;
    UITableView     *paymentTable;

}


-(id)initWithFrame:(CGRect)frame totalAmount:(NSString *)total;
-(void)addPaymentComponents;
-(void)addTable:(CGRect)below_frame;
-(void)addButtonClicked:(id)sender;
-(void)deletePayment:(id)sender;
-(void)updateValues;
-(BOOL)isValidAmount;
-(NSMutableArray *)paymentNames;
-(NSMutableArray *)paymentAmounts;
-(void)dismissPicker;

@end
