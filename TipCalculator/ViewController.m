//
//  ViewController.m
//  TipCalculator
//
//  Created by Dayson Dong on 2019-05-10.
//  Copyright © 2019 Dayson Dong. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField * billAmountTextField;
@property (weak, nonatomic) IBOutlet UILabel *tipAmountLabel;
@property (weak, nonatomic) IBOutlet UITextField *tipPercentageTextField;
@property (weak, nonatomic) IBOutlet UISlider *tipPercentageSlider;
@property (weak, nonatomic) IBOutlet UITextField *bottonTextField;
@property (weak, nonatomic) NSNotificationCenter* notificationCenter;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@end

@implementation ViewController

- (void)calculateTipWithBillAmount: (NSUInteger)billlAmount andTipPercentage: (NSUInteger) tipPercentage{
    
    NSUInteger tip = 0;
    tip = billlAmount * tipPercentage;
    _tipAmountLabel.text = [NSString stringWithFormat:@"Amount of Tip: %.2f",(float)tip/10000];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.notificationCenter = [NSNotificationCenter defaultCenter];
    
    [self.notificationCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [self.notificationCenter addObserver:self.bottonTextField selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == self.tipPercentageTextField) {
         NSString *text = [self.tipPercentageTextField.text stringByReplacingCharactersInRange:range withString:string];
         NSUInteger tipPercentage = [text intValue];
         NSUInteger billAmount = [_billAmountTextField.text floatValue] * 100;
        [self calculateTipWithBillAmount:billAmount andTipPercentage:tipPercentage];
    }
    
    if (textField == self.billAmountTextField) {
        NSLog(@"?");
        NSString *text = [self.billAmountTextField.text stringByReplacingCharactersInRange:range withString:string];
        NSUInteger billAmount = [text floatValue] * 100;
        NSUInteger tipPercentage = [_tipPercentageTextField.text intValue] ;
        [self calculateTipWithBillAmount:billAmount andTipPercentage:tipPercentage];
    }
    
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.bottonTextField resignFirstResponder];
    [self.billAmountTextField resignFirstResponder];
    [self.tipPercentageTextField resignFirstResponder];
}
- (IBAction)calculateTipButtonTapped:(UIButton *)sender {
    NSUInteger billAmount = [_billAmountTextField.text floatValue] * 100;
    NSUInteger tipPercentage = [_tipPercentageTextField.text intValue];
    [self calculateTipWithBillAmount:billAmount andTipPercentage:tipPercentage];
}

- (IBAction)sliderChanged:(UISlider *)sender {
    NSUInteger billAmount = [[_billAmountTextField.text stringByReplacingOccurrencesOfString:@"." withString:@""] integerValue];
    _tipPercentageTextField.text = [NSString stringWithFormat:@"%.2f",sender.value];
    NSUInteger tipPercentage = (int)(sender.value * 100.00);
    [self calculateTipWithBillAmount:billAmount andTipPercentage:tipPercentage];
    
}

-(void)keyboardWillShow:(NSNotification*) notification {
    
    CGRect keyboardFrame = [notification.userInfo[@"UIKeyboardFrameBeginUserInfoKey"] CGRectValue];
    [UIView animateWithDuration:0.25 animations:^{
        self.bottonTextField.frame = CGRectMake(0, self.bottonTextField.frame.origin.y - keyboardFrame.size.height - 30, self.bottonTextField.bounds.size.width, self.bottonTextField.bounds.size.height);
        CGFloat new = -(keyboardFrame.size.height + 30.0);
        self.bottomConstraint.constant = new;
    }];
    
}

-(void)keyboardWillHide:(NSNotification*) notification {
    
    CGRect keyboardFrame = [notification.userInfo[@"UIKeyboardFrameBeginUserInfoKey"] CGRectValue];
    [UIView animateWithDuration:0.25 animations:^{
                self.bottonTextField.frame = CGRectMake(0, self.bottonTextField.frame.origin.y + keyboardFrame.size.height + 30, self.bottonTextField.bounds.size.width, self.bottonTextField.bounds.size.height);
        self.bottomConstraint.constant = 0;
    }];
}

@end
