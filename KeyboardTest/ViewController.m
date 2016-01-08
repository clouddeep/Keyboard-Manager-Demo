//
//  ViewController.m
//  KeyboardTest
//
//  Created by Shou Cheng Tuan on 2016/1/6.
//  Copyright © 2016年 Shou Cheng Tuan. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textField;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardNotification:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWhenDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
}



- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)recordViewState
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    BOOL isFirstResponder = self.textField.isFirstResponder;
    [userDefault setObject:@(isFirstResponder)
                    forKey:@"TextFieldState"];
}

- (void)restoreViewState
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    BOOL isFirstResponder = NO;
    NSNumber *v = [userDefault objectForKey:@"TextFieldState"];
    isFirstResponder = v.boolValue;
    
    if (isFirstResponder) {
        [self.textField becomeFirstResponder];
    }
}

- (void)handleKeyboardNotification:(NSNotification *)notification
{
    UIApplication *app = [UIApplication sharedApplication];
    if (app.applicationState != UIApplicationStateActive) {
        return;
    }
    
    if (notification.name == UIKeyboardWillShowNotification) {
        [self viewMoveUp:YES withInfo:[notification userInfo]];
    }else {
        [self viewMoveUp:NO withInfo:[notification userInfo]];
    }
}

- (void)handleKeyboardWhenDidEnterBackground:(NSNotification *)notification
{
    [self.textField resignFirstResponder];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    [self viewMoveUp:YES withInfo:[notification userInfo]];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    [self viewMoveUp:NO withInfo:[notification userInfo]];
}

- (void)viewMoveUp:(BOOL)isMoveUp withInfo:(NSDictionary *)userInfo
{
    UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    double timeInterval = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect frame = self.view.frame;
    frame.origin.y = 0;
    self.view.frame = frame;
    
    CGRect keyRect = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGPoint textFieldOrigin = CGPointZero;
    
    UITextField *textField = self.textField;
    textFieldOrigin = textField.frame.origin;
    
    CGFloat yOffset = textFieldOrigin.y - keyRect.origin.y;
    BOOL isCovered = yOffset>0;
    
    if (isMoveUp) {
        CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
        CGFloat textFieldHeight = textField.frame.size.height;
        frame.origin.y -= (isCovered) ? (yOffset-statusBarHeight+ textFieldHeight+30) : 0;
    }else {
        frame.origin.y = 0;
    }
    
    [UIView animateWithDuration:timeInterval delay:0 options:(curve<<16) animations:^{
        self.view.frame = frame;
    }completion:nil];
    
}

- (CGFloat)normalViewOffset
{
    BOOL isHiddenStatusBar = [UIApplication sharedApplication].isStatusBarHidden;
    BOOL isHiddenNaviBar = self.navigationController.navigationBar.hidden;
    
    CGFloat offset = 0;
    if (!isHiddenStatusBar && !isHiddenNaviBar) {
        offset += [UIApplication sharedApplication].statusBarFrame.size.height
        + self.navigationController.navigationBar.frame.size.height;
    }
    return offset;
}

@end
