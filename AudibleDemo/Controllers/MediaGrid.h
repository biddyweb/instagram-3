
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "InstagramAPI.h"

@interface MediaGrid : UIViewController

- (id)initWithLocationId:(NSString*)locationId;

@property (nonatomic, strong) NSString* locationId;
@property (nonatomic, strong) UIScrollView* gridScrollView;
@property (nonatomic, strong) UIPageControl* pageControl;
@property (nonatomic, strong) NSArray* images;
@property (nonatomic, strong) NSMutableArray* thumbnails;
@property (nonatomic, strong) NSMutableArray* allImages;

@end
