
#import "InstagramAPI.h"
#import "AFJSONRequestOperation.h"

NSString * const kInstagramBaseURLString = @"https://api.instagram.com/v1/";
#warning Include your client id from instagr.am
NSString * const kClientId = @"clientID";

#warning Include your redirect uri
NSString * const kRedirectUrl = @"URL;


// Endpoints
NSString * const kSwiftEndpoint = @"tags/%@/media/recent";
NSString * const kAuthenticationEndpoint =
    @"https://instagram.com/oauth/authorize/?client_id=%@&redirect_uri=%@&response_type=token";

@implementation InstagramAPI

- (id)initWithBaseURL:(NSURL *)url 
{
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [self setDefaultHeader:@"Accept" value:@"application/json"];
    
    return self;
}

+ (InstagramAPI *)sharedClient 
{
    static InstagramAPI * _sharedClient = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:kInstagramBaseURLString]];
    });
    
    return _sharedClient;
}

@end
