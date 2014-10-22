//
//  CSNetAddressKeyboard.m
//
//  Created by Jose Antonio Lopez on 18/10/14.
//  Copyright (c) 2014 Insenia. All rights reserved.
//

#import "CSNetAddressKeyboard.h"

NSString *const CSNetAddressKeyboardIPv4 = @"CSNetAddressKeyboardIPv4";
NSString *const CSNetAddressKeyboardIPv6 = @"CSNetAddressKeyboardIPv6";

@interface CSNetAddressKeyboard () {
    __weak UITextField *_textField;
    NSString *_keyboardLayout;
    
    UIColor *kBackgroundColor;
    CGFloat kScreenWidth;
    CGFloat kScreenHeight;
    
    CGFloat kKeyHeight;
    CGFloat kNumNows;
    NSString *kDividerChar;
    CGFloat kNumberOfKeys;
    
    CGFloat kKeyboardHeight;
    CGFloat kKeyWidth;
    CGRect kKeyRect;
}

- (void)createButtons;
- (void)makeButtonWithRect:(CGRect)rect num:(CGFloat)num grayBackground:(BOOL)grayBackground;

- (NSString *)buttonTitleForNumber:(NSInteger)num;
- (CGPoint)buttonOriginPointForNumber:(NSInteger)num;

- (void)changeButtonBackgroundColourForHighlight:(UIButton *)button;
- (void)changeTextFieldText:(UIButton *)button;

@end

@implementation CSNetAddressKeyboard

- (CSNetAddressKeyboard *)initWithTextField:(UITextField *)textField keyboardLayout:(NSString*)keyboardLayout
{
    [self defineConstants];
    [self calcSizes:keyboardLayout];
    
    self = [super initWithFrame:CGRectMake(0.0f, 0.0f, kScreenWidth, kKeyboardHeight)];
    
    if (self) {
        _textField = textField;
        _textField.delegate = self;
        _keyboardLayout = keyboardLayout;
        
        self.backgroundColor = kBackgroundColor;
        [self createButtons];
    }
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver: self selector:   @selector(deviceOrientationDidChange:) name:    UIDeviceOrientationDidChangeNotification object: nil];
    
    return self;
}

-(void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
}

- (void)defineConstants
{
    kBackgroundColor = [UIColor colorWithRed:0.729 green:0.741 blue:0.761 alpha:1]; /*#babdc2*/
    kScreenWidth = [[UIScreen mainScreen] bounds].size.width;
    kScreenHeight = [[UIScreen mainScreen] bounds].size.height;
    if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation) && (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1))
    {
        kScreenWidth = [[UIScreen mainScreen] bounds].size.height;
        kScreenHeight = [[UIScreen mainScreen] bounds].size.width;
    }
    //=============================================================
}

- (void)calcSizes: (NSString*)keyboardLayout
{
    if (keyboardLayout != nil && [keyboardLayout respondsToSelector:@selector(length)] && [[keyboardLayout lowercaseString ]compare:[CSNetAddressKeyboardIPv6 lowercaseString]] == NSOrderedSame)
    {
        if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation))
        {
            kKeyHeight = 44;
        }
        else
        {
            kKeyHeight = 44;
        }
        kNumNows = 6.0;
        kDividerChar = @":";
        kNumberOfKeys = 18;
    }
    else
    {
        if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation))
        {
            kKeyHeight = 54;
        }
        else
        {
            kKeyHeight = 54;
        }
        kNumNows = 4.0;
        kDividerChar = @".";
        kNumberOfKeys = 12;
    }
    
    kKeyboardHeight = (kKeyHeight * kNumNows);
    kKeyWidth = kScreenWidth / 3.0;
    kKeyRect = CGRectMake(0.0f, 0.0f, kKeyWidth, kKeyHeight);
}

- (void)createButtons
{
    /* Makes the numerical buttons */
    for (NSInteger num = 1; num <= kNumberOfKeys; num++) {
        kKeyRect.origin = [self buttonOriginPointForNumber:num];
        [self makeButtonWithRect:kKeyRect num:num grayBackground:NO];
    }
}

- (void)makeButtonWithRect:(CGRect)rect num:(CGFloat)num grayBackground:(BOOL)grayBackground
{
    UIButton *button = [[UIButton alloc] initWithFrame:rect];
    CGFloat fontSize = 25.0f;
    
    button.backgroundColor = (grayBackground) ? kBackgroundColor : [UIColor whiteColor];
    if (num != kNumberOfKeys)
    {
        button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
        [button setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        [button setTitle: [self buttonTitleForNumber:num] forState:UIControlStateNormal];
    }
    else
    {
        [button setImage:[UIImage imageNamed:@"netAddressBackspace"] forState:UIControlStateNormal];
        [button setContentMode:UIViewContentModeCenter];
        [button setAccessibilityLabel:NSLocalizedString(@"delete", nil)];
    }
    
    if (num == kNumberOfKeys || num == (kNumberOfKeys - 2))
    {
        button.backgroundColor = kBackgroundColor;
    }
    
    [button setTag:num];
    [button addTarget:self action:@selector(changeButtonBackgroundColourForHighlight:) forControlEvents:UIControlEventTouchDown];
    [button addTarget:self action:@selector(changeButtonBackgroundColourForHighlight:) forControlEvents:UIControlEventTouchDragEnter];
    [button addTarget:self action:@selector(changeButtonBackgroundColourForHighlight:) forControlEvents:UIControlEventTouchDragExit];
    [button addTarget:self action:@selector(changeTextFieldText:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:button];
}

- (NSString *)buttonTitleForNumber:(NSInteger)num
{
    NSString *str = [NSString stringWithFormat:@"%ld", (long)num];
    
    if (num > 9 && kNumberOfKeys == 18)
    {
        str = @[@"a", @"b", @"c", @"d", @"e", @"f", kDividerChar, @"0", @"del"][num - 10];
    }
    else if (num > 9)
    {
        str = @[kDividerChar, @"0", @"del"][num - 10];
    }
    
    return str;
}

- (CGPoint)buttonOriginPointForNumber:(NSInteger)num
{
    CGPoint point = CGPointMake(0.0f, 0.0f);
    
    if ((num % 3) == 2) { /* 2nd button in the row */
        point.x = ceil(kKeyWidth);
    }
    else if ((num % 3) == 0) { /* 3rd button in the row */
        point.x = ceil((kKeyWidth * 2.0f));
    }
    
    if (num > 3) { /* The row multiplied by row's height */
        point.y = floor((num - 1) / 3.0f) * (kKeyHeight + 0.5f);
    }
    
    return point;
}

- (void)changeButtonBackgroundColourForHighlight:(UIButton *)button
{
    if ([button.backgroundColor isEqual:kBackgroundColor])
    {
        button.backgroundColor = [UIColor whiteColor];
    }
    else
    {
        button.backgroundColor = kBackgroundColor;
    }
}

- (void)changeTextFieldText:(UIButton *)button
{
    NSMutableString *string = [NSMutableString stringWithString:_textField.text];
    
    if (button.tag == kNumberOfKeys)
    {
        NSRange deleteRange = NSMakeRange((string.length - 1), 1);
        [string deleteCharactersInRange:deleteRange];
    }
    else
    {
        if ([_textField.delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)])
        {
            UITextPosition* beginning = _textField.beginningOfDocument;
            UITextRange* selectedTextRange = _textField.selectedTextRange;
            UITextPosition* selectionStart = selectedTextRange.start;
            UITextPosition* selectionEnd = selectedTextRange.end;
            const NSInteger location = [_textField offsetFromPosition:beginning toPosition:selectionStart];
            const NSInteger length = [_textField offsetFromPosition:selectionStart toPosition:selectionEnd];
            NSRange selectedRange = NSMakeRange(location, length);
            
            if ([_textField.delegate textField:_textField shouldChangeCharactersInRange:selectedRange replacementString:button.titleLabel.text])
            {
                [string appendString:button.titleLabel.text];
            }
        }
        else
        {
            [string appendString:button.titleLabel.text];
        }
    }
    
    _textField.text = string;
    
    [self changeButtonBackgroundColourForHighlight:button];
    [_textField sendActionsForControlEvents:UIControlEventEditingChanged];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == _textField)
    {
        if ([string length] == 0)
            return YES;
        
        if (_keyboardLayout != nil && [_keyboardLayout respondsToSelector:@selector(length)] && [[_keyboardLayout lowercaseString ]compare:[CSNetAddressKeyboardIPv6 lowercaseString]] == NSOrderedSame)
        {
            NSString *includeString = @"ABCDEFabcdef0123456789:" ;
            if ([includeString rangeOfString:string].location == NSNotFound) {
                return NO;
            }
        }
        else
        {
            NSString *includeString = @"0123456789." ;
            if ([includeString rangeOfString:string].location == NSNotFound) {
                return NO;
            }
        }
    }
    return YES;
}

- (void)deviceOrientationDidChange:(NSNotification *)notification
{
    NSArray *viewsToRemove = [self subviews];
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
    }
    
    [self defineConstants];
    [self calcSizes:_keyboardLayout];
    self.frame = CGRectMake(0.0f, 0.0f, kScreenWidth, kKeyboardHeight);
    
    [self createButtons];
}

@end
