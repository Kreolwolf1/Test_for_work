@import "Messages.j"

var   UserMailInput = false;
var   messages  = [[CPArray alloc] init];
var   data = {};
var   fl_connect = true;

@implementation InputController : CPWindowController
{
    CPTableView tableView;
    var 		contentInputView;

}

- (id)init:(CPString)inputStr
{

	UserMailInput = inputStr;
	[self outTable];
	[self inputForm];

}


- (id)inputForm{
    var window = [[CPWindow alloc] initWithContentRect:CGRectMake(1060, 70, 250, 70) styleMask:CPTitledWindowMask|CPClosableWindowMask],

    contentView = [window contentView],
    textField = [[CPTextField alloc] initWithFrame:CGRectMake(25, 20, 200, 30)];
    [textField setEditable:YES];
    [textField setBezeled:YES];
    [textField setTarget:self];
    [textField setAction:@selector(didSubmitTextField:)];
    [contentView addSubview:textField];


    [window makeFirstResponder:textField];

    [window setTitle:"Add value in Table"];
    [window orderFront:self];

}


- (id)outTable{
    var WindowInput = [[CPWindow alloc] initWithContentRect:CGRectMakeZero() styleMask:CPBorderlessBridgeWindowMask],
        contentInputView = [WindowInput contentView];

    var scrollView = [[CPScrollView alloc] initWithFrame:CGRectMake(0.0, 50.0, 1060.0, 250.0)];
    [scrollView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];

    tableView = [[CPTableView alloc] initWithFrame:[scrollView bounds]];
    [tableView setDataSource:self];
    [tableView setUsesAlternatingRowBackgroundColors:YES];

    // define the header color
    var headerColor = [CPColor colorWithPatternImage:[[CPImage alloc] initWithContentsOfFile:[[CPBundle mainBundle] pathForResource:@"button-bezel-center.png"]]];

    [[tableView cornerView] setBackgroundColor:headerColor];


    // add the first column
    var column = [[CPTableColumn alloc] initWithIdentifier:@"Mail"];
    [[column headerView] setStringValue:"Mail"];
    [[column headerView] setBackgroundColor:headerColor];
    [column setWidth:125.0];
    [tableView addTableColumn:column];

    // add the second column
    var column = [[CPTableColumn alloc] initWithIdentifier:@"Text"];
    [[column headerView] setStringValue:"Text"];
    [[column headerView] setBackgroundColor:headerColor];
    [column setWidth:825.0];
    [tableView addTableColumn:column];

    // add the third column
    var column = [[CPTableColumn alloc] initWithIdentifier:@"Date"];
    [[column headerView] setStringValue:"Date"];
    [[column headerView] setBackgroundColor:headerColor];
    [column setWidth:100.0];
    [tableView addTableColumn:column];

    [scrollView setDocumentView:tableView];

    [contentInputView addSubview:scrollView];
    [WindowInput orderFront:self];

}

- (void)didSubmitTextField:(CPTextField)textField
{
	data  = {};
	data.request = {}
	data.request.mail = UserMailInput;
	data.request.text = [textField stringValue];
	data.url = @"http://test_work/message/save";
	var request = [self createRequestWithIdentifier: data];
	postConnection = [CPURLConnection connectionWithRequest:request delegate:self];
}


-(CPURLRequest)createRequestWithIdentifier:(JSObject)data
{
	var content = [CPString JSONFromObject:data.request];
	//var content = [CPString JSONFromObject:{"mail":"Peter@mail.com","pass":"123123123"}];

	var contentLength = [[CPString alloc] initWithFormat:@"%d", [content length]];
	var request = [[CPURLRequest alloc] initWithURL:data.url];
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody:content];
	[request setValue:"text/plain;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
	return request;
}

-(void)connection:(CPURLConnection)connection didFailWithError:(id)error
{
	//debugger;
	[LoginController displayAlertWithMessage:error];
}


-(void)connection:(CPURLConnection)connection didReceiveResponse:(CPHTTPURLResponse)response
{
	//debugger;
	var statusCode = [response statusCode];
	console.log(statusCode);
	if (statusCode != '200')
	{
		data.request._id  = nil;
		data.request.date = [CPDate date];
		request = [data.request];
		console.log(request);
		[messages addObjectsFromArray:[Messages initWithJSONObjects:request]];

	    [tableView reloadData];
	}
}

-(void)connection:(CPURLConnection)connection didReceiveData:(CPString)data
{
	if (data)
	{
		data = CPJSObjectCreateWithJSON(data);
		[messages addObjectsFromArray:[Messages initWithJSONObjects:data.response]];
	    if (!fl_connect)
	    {
	    	alert("123");
	    	fl_connect = true;
			var request = [self createRequestWithIdentifier: [self DataRequest]];
			postConnection = [CPURLConnection connectionWithRequest:request delegate:self];

	    }
	    [tableView reloadData];
	}

}

-(JSObject)DataRequest()
{
	CPLog.trace([messages description]);
	var request = []
	for (var i in messages)
	{
	  if (i!="isa")
	  {
	   if ([messages[parseInt(i)] _id])
	   {
	   	  var data = {}
	   	  data.mail = [messages[parseInt(i)] mail];
	   	  data.text = [messages[parseInt(i)] text];

	   	  console.log(data);
	   	  request.push(data);
	   	  delete messages[parseInt(i)];
	   }
	  }
	}
	console.log(request);
}

- (int)numberOfRowsInTableView:(CPTableView)tableView
{
//    [self DataRequest]
    return [messages count];
}

- (id)tableView:(CPTableView)tableView objectValueForTableColumn:(CPTableColumn)tableColumn row:(int)row
{
	switch ([tableColumn identifier])
	{
		case "Mail":
				return [messages[row] mail]
					break;
		case "Text":
				return [messages[row] text]
					break;
		case "Date":
				return [messages[row] date]
					break;
	}

}



@end
