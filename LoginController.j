@import "InputController.j"

var loginControllerSharedInstance = nil;
var	UserMail = false;

@implementation LoginController : CPWindowController
{
}

+ (LoginController)sharedLoginController
{
	// debugger;

    if (loginControllerSharedInstance == nil)
    {
        loginControllerSharedInstance = [[LoginController alloc] init];
    }

    return loginControllerSharedInstance;
}

-(void)toggleLoginWindow:(id)sender
{
	// debugger;
    var sharedLoginController = [LoginController sharedLoginController];
    var loginWindow = [sharedLoginController window];

  	if ([loginWindow isVisible] == YES) {
    	[loginWindow orderOut:sender];
  	}
  	else {
    	[sharedLoginController showWindow:sender];
  	}
}


-(void)showLoginWindow:(id)sender
{
    var sharedLoginController = [LoginController sharedLoginController];
    [sharedLoginController showWindow:sender];
}

-(void)hideLoginWindow:(id)sender
{
    var sharedLoginController = [LoginController sharedLoginController];
    [[sharedLoginController window] orderOut:sender];
}

- (id)init
{
	// Create the login window
    var theWindow = [[CPWindow alloc] initWithContentRect:CGRectMake(100,100,340,200) styleMask:CPClosableWindowMask | CPTitledWindowMask],
    	contentView = [theWindow contentView],
    self = [super initWithWindow:theWindow];
    if (self)
    {
	    [theWindow center];
    	[theWindow setTitle:"Login"];

		var textField = [[CPTextField alloc] initWithFrame:CGRectMake(10, 10, 340, 24)];
		[textField setObjectValue:@"Enter your email and password to login"];
		[textField setFont:[CPFont systemFontOfSize:12]];
		[textField setAlignment:CPCenterTextAlignment];
		[contentView addSubview:textField];

		textField = [[CPTextField alloc] initWithFrame:CGRectMake(27, 50, 50, 24)];
		[textField setObjectValue:@"Email"];
		[textField setFont:[CPFont systemFontOfSize:12]];
		[textField setAlignment:CPCenterTextAlignment];
		[contentView addSubview:textField];

		textField = [[CPTextField alloc] initWithFrame:CGRectMake(20, 80, 50, 24)];
		[textField setObjectValue:@"Password"];
		[textField setFont:[CPFont systemFontOfSize:12]];
		[textField setAlignment:CPCenterTextAlignment];
		[contentView addSubview:textField];

	    mailTextField = [[CPTextField alloc] initWithFrame:CGRectMake(80, 45, 200, 30)];
	    [mailTextField setPlaceholderString:@"Enter your mail"];
	    [mailTextField setEditable:YES];
	    [mailTextField setBezeled:YES];
	    [mailTextField setTarget:self];
	    [mailTextField setAction:@selector(didSubmitTextField:)];
	    [contentView addSubview:mailTextField];

	    passTextField = [[CPSecureTextField alloc] initWithFrame:CGRectMake(80, 75, 200, 30)];
	    [passTextField setPlaceholderString:@"Enter your password"];
	    [passTextField setEditable:YES];
	    [passTextField setBezeled:YES];
	    [passTextField setTarget:self];
	    [passTextField setAction:@selector(didSubmitTextField:)];
	    [contentView addSubview:passTextField];

	    okButton = [[CPButton alloc] initWithFrame:CGRectMake(220, 120, 80, 24)];
		[okButton setTitle:"Login"];
	    [okButton setAction:@selector(login:)];
	    [okButton setTarget:self];
		[contentView addSubview:okButton];

		cancelButton = [[CPButton alloc] initWithFrame:CGRectMake(130, 120, 80, 24)];
	    [cancelButton setAction:@selector(cancel:)];
	    [cancelButton setTarget:self];
		[cancelButton setTitle:"Cancel"];
		[contentView addSubview:cancelButton];




	}

	return self;
}

-(void)cancel:(id)sender
{
	[self hideLoginWindow:sender];
}

-(void)login:(id)sender
{
	console.log([self checkPasswordLength:6]);
	console.log([self checkEmail]);

	if (([self checkPasswordLength:6]) & ([self checkEmail]))
	{
		var request = [self createRequestWithIdentifier:YES];
		postConnection = [CPURLConnection connectionWithRequest:request delegate:self];
	}
	else
	{
		[self displayAlertWithMessage:@"Check your form"];
	}
}

-(CPURLRequest)createRequestWithIdentifier:(BOOL)useIndentifier
{
	var mail = [mailTextField stringValue]
	var pass = [passTextField stringValue]
	var myFirstJSONObject = { "mail" : mail, "pass" : pass};
	UserMail = mail;
	var content = [CPString JSONFromObject:myFirstJSONObject];
	var contentLength = [[CPString alloc] initWithFormat:@"%d", [content length]];

	var request = [[CPURLRequest alloc] initWithURL:@"http://test_work/login/"];
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody:content];
	[request setValue:"text/plain;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
	return request;
}


-(void)connection:(CPURLConnection)connection didFailWithError:(id)error
{
	//debugger;
	[self displayAlertWithMessage:error];
	receivedJsonData = nil;
	UserMail = false;
}


-(void)connection:(CPURLConnection)connection didReceiveResponse:(CPHTTPURLResponse)response
{
	//debugger;
	var statusCode = [response statusCode];
	console.log(statusCode);
}

-(void)connection:(CPURLConnection)connection didReceiveData:(CPString)data
{
	// Create a javascript object from the JSON content
	//receivedJsonData = [data objectFromJSON];
	data = CPJSObjectCreateWithJSON(data);
	if (data.response)
	{
		[self toggleLoginWindow:data]
		[[InputController alloc] init: UserMail]
	}
	else
	{
		UserMail = false
		[self displayAlertWithMessage:@"Please, try again))"];
	}
}

-(BOOL)checkEmail
{
	var email = [[mailTextField stringValue] lowercaseString];

	var re_email = new RegExp("^[_a-z0-9-]+(\.[_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*$");

	return re_email.test(email);
}


-(BOOL)checkPasswordLength:(int)length
{
	var password = [passTextField stringValue];

	return ([password length] >= length);
}

-(void)displayAlertWithMessage:(CPString)message
{
	var alert = [[CPAlert alloc] init];
	[alert setMessageText:message];
	[alert setAlertStyle:CPWarningAlertStyle];
	[alert addButtonWithTitle:@"OK"]
	[alert runModal];
}

@end
