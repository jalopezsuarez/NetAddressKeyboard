//
//  CSNetAddressKeyboard.h
//
//  Created by Jose Antonio Lopez on 18/10/14.
//  Copyright (c) 2014 Insenia. All rights reserved.
//

@interface CSNetAddressKeyboard : UIView <UITextFieldDelegate>

extern NSString *const CSNetAddressKeyboardIPv4;
extern NSString *const CSNetAddressKeyboardIPv6;

- (CSNetAddressKeyboard *)initWithTextField:(UITextField *)textField keyboardLayout:(NSString*)keyboardLayout;

@end
