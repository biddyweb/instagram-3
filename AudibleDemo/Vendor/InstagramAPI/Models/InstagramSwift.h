
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "InstagramAPI.h"

@interface InstagramSwift : NSObject

@property (nonatomic, strong) NSString* thumbnailUrl;
@property (nonatomic, strong) NSString* standardUrl;
@property (nonatomic, assign) NSUInteger likes;

+ (void)getUserMediaWithId:(NSString*)userID block:(void (^)(NSArray *records))block;

@end
