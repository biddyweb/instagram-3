
#import <UIKit/UIKit.h>
#import "InstagramSwift.h"
#import "InstagramAPI.h"

@class InstagramSwift;

@interface ImageView : UIViewController

@property (nonatomic, strong) UIImageView* imageView;
@property (nonatomic, strong) InstagramSwift* media;

- (id)initWithMedia:(InstagramSwift*)media;

@end
