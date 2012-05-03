/*
 * AppController.j
 * test_work
 *
 * Created by You on April 26, 2012.
 * Copyright 2012, Your Company All rights reserved.
 */

@import <Foundation/CPObject.j>
@import "LoginController.j"

@implementation AppController : CPObject
{
    CPWindow theWindow;
    var contentView;
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
    var theWindow = [[CPWindow alloc] initWithContentRect:CGRectMakeZero() styleMask:CPBorderlessBridgeWindowMask],
        contentView = [theWindow contentView];

    var open_login = [[CPButton alloc] initWithFrame:CGRectMake(10, 10, 100, 24)];
    [open_login setAutoresizingMask:CPViewMinXMargin |
                            CPViewMaxXMargin |
                            CPViewMinYMargin |
                            CPViewMaxYMargin];
    [open_login setTitle:@"Login"];
    [open_login setAction:@selector(showLogin:)];
    [open_login setTarget:self];
    [contentView addSubview:open_login];

    [theWindow orderFront:self];

}
-(void)showLogin:(id)sender
{
    [[LoginController sharedLoginController] toggleLoginWindow:sender];
}
@end
