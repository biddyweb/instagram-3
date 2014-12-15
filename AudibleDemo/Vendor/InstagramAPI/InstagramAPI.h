
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"
#import "InstagramAPI.h"

extern NSString * const kInstagramBaseURLString;
extern NSString * const kClientId;
extern NSString * const kRedirectUrl;

// Endpoints
extern NSString * const kAuthenticationEndpoint;
extern NSString * const kSwiftEndpoint;

@interface InstagramAPI : AFHTTPClient

+ (InstagramAPI *)sharedClient;
- (id)initWithBaseURL:(NSURL *)url;

@end
