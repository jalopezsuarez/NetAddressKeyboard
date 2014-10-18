//
//  INNetAddressKeyboard.h
//
//  Created by Jose Antonio Lopez on 18/10/14.
//  Copyright (c) 2014 Insenia. All rights reserved.
//

@interface INNetAddressKeyboard : UIView <UITextFieldDelegate>

extern NSString *const INNetAddressKeyboardIPv4;
extern NSString *const INNetAddressKeyboardIPv6;

- (INNetAddressKeyboard *)initWithTextField:(UITextField *)textField keyboardLayout:(NSString*)keyboardLayout;

@end
