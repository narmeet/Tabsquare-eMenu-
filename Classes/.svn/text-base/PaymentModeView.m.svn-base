
#import "PaymentModeView.h"

#define PAYMENT_TAG 151
#define AMOUNT_TAG  152

#define DEFAULT @"VISA"

@implementation PaymentModeView

-(id)initWithFrame:(CGRect)frame totalAmount:(NSString *)total
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        totalAmount = [NSString stringWithFormat:@"%@", total];
        paymentName   = [[NSMutableArray alloc] init];
        paymentAmount = [[NSMutableArray alloc] init];
        [paymentName addObject:@"VISA"];
        [paymentAmount addObject:totalAmount];
        
        [self addPaymentComponents];
    }
    
    return self;
}

-(void)dismissPicker{
    
    [paymentPicker setHidden:YES];
}
/*============================Update in Payment Method Layout============================*/

-(void)addPaymentComponents
{
    paymentModes = [[NSArray alloc] initWithObjects:@"Cash", @"VISA", @"MasterCard", @"Amex", @"NETS", @"SG Dine", @"JCB", @"Diners Club", @"Cheque", @"Voucher", @"HungryGoWhere", @"Cuisine Express", @"Room Service", @"FOC", @"ENT", nil];
    
    CGRect pay_frm = CGRectMake(5, 5, 180, 30);
    UITextField *payment_name = [[UITextField alloc] initWithFrame:pay_frm];
   /* [payment_name setTag:PAYMENT_TAG];
    [payment_name setText:DEFAULT];
    [payment_name setFont:[UIFont boldSystemFontOfSize:17.0]];
    [payment_name setEnabled:FALSE];
    [payment_name setBorderStyle:UITextBorderStyleRoundedRect];
    [payment_name setKeyboardType:UIKeyboardTypeNumberPad];
    [payment_name setDelegate:self];
    [self addSubview:payment_name];
    
    UITextField *amount = [[UITextField alloc] initWithFrame:CGRectMake(pay_frm.origin.x+pay_frm.size.width+5, pay_frm.origin.y, 140, 30)];
    [amount setTag:AMOUNT_TAG];
    [amount setText:totalAmount];
    [amount setFont:[UIFont boldSystemFontOfSize:17.0]];
    [amount setBorderStyle:UITextBorderStyleRoundedRect];
    [amount setKeyboardType:UIKeyboardTypeNumberPad];
    [amount setDelegate:self];
    [self addSubview:amount];*/
    
    
  /*  UIButton *open_close_picker = [UIButton buttonWithType:UIButtonTypeCustom];
    [open_close_picker setFrame:payment_name.bounds];
    [open_close_picker setTag:PAYMENT_TAG];
    [open_close_picker addTarget:self action:@selector(pickerButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:open_close_picker];*/
    
    CGRect frm1 = payment_name.frame;
    CGRect pick_frm = CGRectMake(frm1.origin.x, frm1.origin.y + frm1.size.height, frm1.size.width, 150);
    
    paymentPicker = [[UIPickerView alloc] initWithFrame:pick_frm];
    [paymentPicker setDelegate:self];
    [paymentPicker setDataSource:self];
    [paymentPicker setShowsSelectionIndicator:TRUE];
    [self addSubview:paymentPicker];
    
    [paymentPicker selectRow:1 inComponent:0 animated:YES];
    [paymentPicker reloadComponent:0];
    
    [paymentPicker setHidden:TRUE];
    
    
    UIButton *add_button = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [add_button  setFrame:CGRectMake(330+15.0, pay_frm.origin.y+15, 30, 30)];
    [add_button addTarget:self action:@selector(addButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:add_button];
    
    CGRect tbl_frm = CGRectMake(payment_name.frame.origin.x, 47, add_button.frame.size.width +add_button.frame.origin.x , 192.0);
    [self addTable:tbl_frm];
    
    UIButton *reset_btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [reset_btn setTitle:@"Reset" forState:UIControlStateNormal];
    [reset_btn setFrame:CGRectMake(payment_name.frame.origin.x, paymentTable.frame.origin.y + paymentTable.frame.size.height + 8.0, 80, 33)];
    [reset_btn addTarget:self action:@selector(resetPressed) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:reset_btn];
    
}

-(void)resetPressed
{
    [paymentName removeAllObjects];
    [paymentAmount removeAllObjects];
    
    
   // UITextField *payment_name = (UITextField *)[self.superview viewWithTag:PAYMENT_TAG];
   // [payment_name setText:DEFAULT];
    
   // UITextField *amount = (UITextField *)[self.superview viewWithTag:AMOUNT_TAG];
   // [amount setText:totalAmount];
    [paymentName addObject:@"VISA"];
    [paymentAmount addObject:totalAmount];
    [paymentPicker selectRow:1 inComponent:0 animated:YES];
    [paymentPicker reloadComponent:0];
    [paymentTable reloadData];

}

/*Open Close Picker*/
-(void)pickerButton:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    currentBtn = [btn tag];
    
    if(currentBtn == PAYMENT_TAG)
    {
        CGRect frm1 = btn.frame;
        CGRect pick_frm = CGRectMake(frm1.origin.x+4, frm1.origin.y + frm1.size.height+3, frm1.size.width, 150);
        [paymentPicker setFrame:pick_frm];

    }
    else
    {
        CGPoint pnt = CGPointMake(btn.frame.origin.x, btn.frame.origin.y);
        
        pnt = [self convertPoint:pnt fromView:[btn superview]];
        
        CGRect frm1 = btn.frame;
        CGRect pick_frm = CGRectMake(pnt.x, pnt.y + frm1.size.height, frm1.size.width, 150);
        [paymentPicker setFrame:pick_frm];
    }

    BOOL status = (paymentPicker.isHidden ?FALSE:TRUE);
    [paymentPicker setHidden:status];
    [self bringSubviewToFront:paymentPicker];

}


-(void)addButtonClicked:(id)sender
{
    [paymentName addObject:@"VISA"];
    [paymentAmount addObject:@"0"];
    [self updateValues];
    
    [paymentTable reloadData];
}

-(void)updateValues
{
    UITextField *tf = (UITextField *)[self viewWithTag:AMOUNT_TAG];
    float val = [totalAmount floatValue] / ([paymentName count]);
    float total_amount_new = 0.0;
    NSString *amount = [NSString stringWithFormat:@"%.2f", val];
    [tf setText:amount];
    
    for(int i = 0; i < [paymentAmount count]; i++)
    {
        [paymentAmount replaceObjectAtIndex:i withObject:amount];
        
        
    }
    total_amount_new = [amount floatValue] * ([paymentName count]);
   // if ([paymentAmount count] >1){
    if ([totalAmount floatValue] > total_amount_new){
        
        float buffer = [totalAmount floatValue] - total_amount_new;
        NSString* temp = [NSString stringWithFormat:@"%.2f", val + buffer];
        [paymentAmount replaceObjectAtIndex:[paymentAmount count]-1 withObject: temp];
       // [tf setText:amount];
    }
   // }
    

}

#pragma mark UITextField Delegates

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    NSNumber* candidateNumber;
    
    NSString* candidateString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    range = NSMakeRange(0, [candidateString length]);
    
    [numberFormatter getObjectValue:&candidateNumber forString:candidateString range:&range error:nil];
    
    if (([candidateString length] > 0) && (candidateNumber == nil || range.length < [candidateString length])) {
        
        return NO;
    }
    else
    {
        return YES;
    }
}


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [paymentTable setScrollEnabled:NO];
}


-(void)textFieldDidEndEditing:(UITextField *)textField
{
    int tag_val = [textField tag];
    
   // if(tag_val != AMOUNT_TAG)
        [paymentAmount replaceObjectAtIndex:tag_val withObject:textField.text];
    
    [paymentTable setScrollEnabled:YES];
}


#pragma mark Picker View Delegates

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [paymentModes count];
}


-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}


-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [paymentModes objectAtIndex:row];
}


-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    UIView *payment_view        = pickerView.superview;
    UITextView *payment_name    = (UITextView *)[payment_view viewWithTag:PAYMENT_TAG];
    
  //  if(currentBtn == PAYMENT_TAG)
  //  {
      //  [payment_name setText:[paymentModes objectAtIndex:row]];

 //   }
  //  else
  //  {
        [paymentName replaceObjectAtIndex:currentBtn withObject:[paymentModes objectAtIndex:row]];
        [paymentTable reloadData];
    //}
}


/*=============================Table for additional payment methods==============================*/

-(void)addTable:(CGRect)below_frame
{
	paymentTable			= [[UITableView alloc] initWithFrame:below_frame];
	
	paymentTable.delegate	= self;
	paymentTable.dataSource = self;
	
	paymentTable.backgroundColor = [UIColor clearColor];
	paymentTable.showsVerticalScrollIndicator = NO;
	[paymentTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
	
	[self addSubview:paymentTable];
	
}




#pragma mark -
#pragma mark Table View Data Source Methods


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [paymentName count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 32;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString* CellIdentifier = @"MessageCellIdentifier";
	
	UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:nil];
	if(cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}
    
    
    CGRect pay_frm = CGRectMake(0, 0, 180, 30);
    UITextField *payment_name = [[UITextField alloc] initWithFrame:pay_frm];
    [payment_name setText:[paymentName objectAtIndex:indexPath.row]];
    [payment_name setFont:[UIFont boldSystemFontOfSize:17.0]];
    [payment_name setEnabled:FALSE];
    [payment_name setBorderStyle:UITextBorderStyleRoundedRect];
    [payment_name setKeyboardType:UIKeyboardTypeNumberPad];
    [payment_name setDelegate:self];
    [cell.contentView addSubview:payment_name];
    
    UITextField *amount = [[UITextField alloc] initWithFrame:CGRectMake(pay_frm.origin.x+pay_frm.size.width+5, pay_frm.origin.y, 140, 30)];
    [amount setText:[paymentAmount objectAtIndex:indexPath.row]];
    [amount setTag:indexPath.row];
    [amount setFont:[UIFont boldSystemFontOfSize:17.0]];
    [amount setBorderStyle:UITextBorderStyleRoundedRect];
    [amount setKeyboardType:UIKeyboardTypeNumberPad];
    [amount setDelegate:self];
    [cell.contentView addSubview:amount];

    UIButton *open_close_picker = [UIButton buttonWithType:UIButtonTypeCustom];
    [open_close_picker setFrame:payment_name.bounds];
    [open_close_picker addTarget:self action:@selector(pickerButton:) forControlEvents:UIControlEventTouchUpInside];
    [open_close_picker setTag:indexPath.row];
    [cell.contentView addSubview:open_close_picker];

    if ([paymentName count]>1){
    UIButton *delete_button = [UIButton buttonWithType:UIButtonTypeCustom];
    [delete_button setBackgroundImage:[UIImage imageNamed:@"icon_delete.png"] forState:UIControlStateNormal];
    [delete_button  setFrame:CGRectMake(amount.frame.origin.x+amount.frame.size.width+15.0, pay_frm.origin.y, 30, 30)];
    [delete_button setTag:indexPath.row];
    [delete_button addTarget:self action:@selector(deletePayment:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:delete_button];
    }

	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	
	return cell;
	
}


-(void)deletePayment:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    
    int btn_tag = [btn tag];
    
    [paymentName removeObjectAtIndex:btn_tag];
    [paymentAmount removeObjectAtIndex:btn_tag];
    
    [self updateValues];
    
    [paymentTable reloadData];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


-(BOOL)isValidAmount
{
    BOOL status = FALSE;
    BOOL hasCash = FALSE;
    
    float total_amount = 0.0;
    
    for(int i = 0; i < [paymentAmount count]; i++)
    {
        total_amount += [[paymentAmount objectAtIndex:i] floatValue];
        if ([((NSString*)[paymentName objectAtIndex:i]) isEqualToString:@"Cash"]){
            hasCash = TRUE;
        }
    }
    
 //   UITextField *tf = (UITextField *)[self viewWithTag:PAYMENT_TAG];
    
  //  UITextField *am = (UITextField *)[self viewWithTag:AMOUNT_TAG];
  //  total_amount += [am.text floatValue];
    
    if(total_amount == [totalAmount floatValue])
    {
        status = TRUE;
    }
    else if(total_amount > [totalAmount floatValue] && hasCash)
    {
        status = TRUE;
    }
    else if (total_amount > [totalAmount floatValue] && !hasCash){
        float tempp = total_amount - [totalAmount floatValue];
        NSString* temp = [NSString stringWithFormat:@"%.2f", ((NSString*)[paymentAmount objectAtIndex:[paymentAmount count]-1]).floatValue - tempp];
        [paymentAmount replaceObjectAtIndex:[paymentAmount count]-1 withObject: temp];
        
        status = TRUE;
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Incorrect Amount" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    
        
    
    
    return status;
}



-(NSMutableArray *)paymentNames
{
   // UITextField *tf = (UITextField *)[self viewWithTag:PAYMENT_TAG];
  //  [paymentName insertObject:tf.text atIndex:0];
    
    return paymentName;
}

-(NSMutableArray *)paymentAmounts
{
   // UITextField *am = (UITextField *)[self viewWithTag:AMOUNT_TAG];
  //  [paymentAmount insertObject:am.text atIndex:0];

    return paymentAmount;
}



@end
