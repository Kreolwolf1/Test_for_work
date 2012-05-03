@import <Foundation/CPObject.j>


@implementation Messages : CPObject
{
    CPString mail   @accessors;
    CPString text   @accessors;
    CPString date   @accessors;
    JSObject _id    @accessors;
}

- (id)initWithJSONObject:(JSObject)anObject
{
    self = [super init] ;

    if (self)
    {
        _id     = anObject._id;
        mail    = anObject.mail;
        text    = anObject.text;
        date    = anObject.date;
    }

    return self;
}

+ (CPArray)initWithJSONObjects:(CPArray)someJSONObjects
{
    var messages   = [[CPArray alloc] init];
    for (var i=0; i < someJSONObjects.length; i++) {
        var message = [[Messages alloc] initWithJSONObject:someJSONObjects[i]] ;
        [messages addObject:message] ;
    };
    return messages;
}



@end
