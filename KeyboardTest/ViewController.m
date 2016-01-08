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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardNotification:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)handleKeyboardNotification:(NSNotification *)notification
{
    /* Check app state */
//    UIApplication *app = [UIApplication sharedApplication];
//    if (app.applicationState != UIApplicationStateActive) {
//        return;
//    }
    
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
    
    /* Start: Reset the self.view frame */
    
    /* If this method is excuted unexpectedly, it can prevent from the view will be shifted too much. */
    /* You can out another UIView in self.view to embed text field for shifting to avoid the black rect while app become active again. */
    CGRect frame = self.view.frame;
    frame.origin.y = 0;
    self.view.frame = frame;
    /* End */
    
    CGRect keyRect = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGPoint textFieldOrigin = CGPointZero;
    
    UITextField *textField = self.textField;
    textFieldOrigin = textField.frame.origin;
    
    /* WARNING: if your text field is embedded in different subview, you might get wrong textFieldOrigin and yOffset would be wrong. */
    /* You might need to convert coordinate of the origin of textField in case. */
    CGFloat yOffset = textFieldOrigin.y - keyRect.origin.y;
    BOOL isCovered = CGRectContainsPoint(keyRect, textFieldOrigin);
    
    if (isMoveUp) {
        CGFloat textFieldHeight = textField.frame.size.height;
        frame.origin.y -= (isCovered) ? (yOffset+ textFieldHeight) : 0;
    }else {
        frame.origin.y = 0;
    }
    
    [UIView animateWithDuration:timeInterval delay:0 options:(curve<<16) animations:^{
        self.view.frame = frame;
    }completion:nil];
}

@end
