
#import "ImageView.h"
#import <QuartzCore/QuartzCore.h>

@implementation ImageView

@synthesize media = _media;
@synthesize imageView = _imageView;

- (id)initWithMedia:(InstagramSwift *)media
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        self.media = media;
    }
    return self;
}

#pragma mark - View lifecycle

- (void)loadView
{
    [super loadView];

    
    CGRect bounds = self.view.bounds;
    float statusBar = [UIApplication sharedApplication].statusBarFrame.size.height;
    float navBar = bounds.size.height-self.navigationController.navigationBar.frame.size.height;
    float tabBar = self.tabBarController.tabBar.frame.size.height;
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                   0,
                                                                   bounds.size.width,
                                                                   navBar-tabBar-statusBar)];
    self.imageView.backgroundColor = [UIColor blackColor];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.imageView];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^ {
        NSString* imageUrl = self.media.standardUrl;
        NSData* data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:imageUrl]];
        UIImage* image = [UIImage imageWithData:data];
        
        dispatch_async(dispatch_get_main_queue(), ^ {
            self.imageView.image = image;
            
            // Add some 'likes' meta data to the photo view
            NSUInteger likes = self.media.likes;
            NSString* text = [NSString stringWithFormat: @"%d LIKES", likes];
            CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:10.0]];
            CGRect bounds = self.view.bounds;
            UILabel* likesLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,
                                                                            10,
                                                                            100,
                                                                            50)];
            likesLabel.text = text;
            likesLabel.backgroundColor = [UIColor darkGrayColor];
            likesLabel.textColor = [UIColor whiteColor];
            likesLabel.font = [UIFont systemFontOfSize:10.0];
            likesLabel.layer.cornerRadius = 5.0;
            likesLabel.textAlignment = UITextAlignmentCenter;
            likesLabel.alpha = 0.0;
            [self.view addSubview:likesLabel];
            
            [UIView animateWithDuration:1.0 animations:^{
                likesLabel.alpha = 1.0;
            }];
            
        });
    });
    
    self.navigationController.wantsFullScreenLayout = YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
