
#import "MediaGrid.h"
#import "InstagramSwift.h"
#import "ImageView.h"

const NSInteger klocationThumbnailWidth = 150;
const NSInteger klocationThumbnailHeight = 150;
const NSInteger klocationImagesPerRow = 2;
const NSInteger kGridSpacingPerRow = 5;

@interface MediaGrid (private)
- (void)loadImages;
@end

@implementation MediaGrid

@synthesize gridScrollView = _gridScrollView;
@synthesize images = _images;
@synthesize thumbnails = _thumbnails;
@synthesize locationId = _locationId;
@synthesize pageControl = _pageControl;
@synthesize allImages = _allImages;

- (id)initWithLocationId:(NSString *)locationId
{
    if (self) {
        // Custom initialization
        self.locationId = locationId;
    }
    return self;
}

#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    [super loadView];

    CGRect bounds = self.view.bounds;
    float statusBar = [UIApplication sharedApplication].statusBarFrame.size.height;
    float navBar = bounds.size.height-self.navigationController.navigationBar.frame.size.height;
    float tabBar = self.tabBarController.tabBar.frame.size.height;

    self.thumbnails = [[NSMutableArray alloc] init];
    self.gridScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                                         0,
                                                                         bounds.size.width,
                                                                         navBar-tabBar-statusBar)];
    self.gridScrollView.contentSize = CGSizeMake(bounds.size.width,
                                                 navBar-tabBar-statusBar);
    self.gridScrollView.scrollEnabled = TRUE;
    self.gridScrollView.pagingEnabled = FALSE;
    [self.view addSubview:self.gridScrollView];
    
    UIBarButtonItem *refresh = [[UIBarButtonItem alloc] initWithTitle:@"Refresh"
                                                                    style:UIBarButtonItemStyleBordered target:self action:@selector(refreshPhotos)];
    refresh.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = refresh;
    
    self.allImages = [[NSMutableArray alloc] init];
    [self refreshPhotos];
    
    self.title = @"photos";
}

- (void)refreshPhotos{
    self.navigationItem.rightBarButtonItem.enabled = NO;
    CGRect bounds = self.view.bounds;
    // divide the pixels on a grid of 64 parts
    int parts = bounds.size.width/64;
    int bigX = 29*parts;
    int bigY = 29*parts;
    int smallX = 14*parts;
    int smallY = 14*parts;
    
    NSLog(@"Count subviews: %i",[[self.gridScrollView subviews] count]);
    
    for (UIView *subview in self.gridScrollView.subviews){
        //[subview removeFromSuperview];
    }

    // select tag name
    [InstagramSwift getUserMediaWithId:@"selfie" block:^(NSArray *records) {
        
        for (NSDictionary* image in records) {
            [self.allImages insertObject:image atIndex:0];
        }
        
        while ([self.allImages count] > 100) {
            [self.allImages removeLastObject];
        }
        

        self.gridScrollView.contentSize = CGSizeMake(bounds.size.width,([self.allImages count]/5) * (bigX+kGridSpacingPerRow));
        
        int photo = 0, item = 0, row = 0, col = 0, ySpacing = 0, xSpacing = (1*parts), spacingSwitch = 2;
        int smallSwitch = 2, bigSwitch = 0;
        for (NSDictionary* image in self.allImages) {
            
            UIButton* button = [[UIButton alloc] init];
            
            if (item == 0){
                button = [[UIButton alloc] initWithFrame:CGRectMake(bigSwitch * bigX + (xSpacing * spacingSwitch) + (bigSwitch * 4 * xSpacing),
                                                                    row*bigY +kGridSpacingPerRow+(row*kGridSpacingPerRow),
                                                                    bigX,
                                                                    bigY)];
            } else if (item == 1){
                button = [[UIButton alloc] initWithFrame:CGRectMake((smallSwitch)*smallX + (xSpacing * spacingSwitch) +(2*xSpacing) + (smallSwitch/2*xSpacing),
                                                                    ySpacing * smallY + kGridSpacingPerRow+(kGridSpacingPerRow*(ySpacing)),
                                                                    smallX,
                                                                    smallY)];
            } else if (item == 2){
                button = [[UIButton alloc] initWithFrame:CGRectMake((smallSwitch+1)*smallX + (xSpacing * spacingSwitch) +(3*xSpacing) + (smallSwitch/2*xSpacing),
                                                                    (ySpacing) * smallY + kGridSpacingPerRow+(kGridSpacingPerRow*(ySpacing)),
                                                                    70,
                                                                    smallY)];
            } else if (item == 3){
                button = [[UIButton alloc] initWithFrame:CGRectMake(smallSwitch*smallX + (xSpacing * spacingSwitch) +(2*xSpacing) + (smallSwitch/2*xSpacing),
                                                                    (ySpacing+1) * smallY + kGridSpacingPerRow+(kGridSpacingPerRow*(ySpacing+1)),
                                                                    70,
                                                                    smallY)];
            } else if (item == 4){
                button = [[UIButton alloc] initWithFrame:CGRectMake((smallSwitch+1)*smallX + (xSpacing * spacingSwitch) +(3*xSpacing) + (smallSwitch/2*xSpacing),
                                                                    (ySpacing+1) * smallY + kGridSpacingPerRow+(kGridSpacingPerRow*(ySpacing+1)),
                                                                    smallX,
                                                                    smallY)];
                item = -1;
                row++;
                ySpacing = ySpacing + 2;
                if (smallSwitch == 2){
                    smallSwitch = 0;
                    bigSwitch = 1;
                    spacingSwitch = 0;
                } else {
                    smallSwitch = 2;
                    bigSwitch = 0;
                    spacingSwitch = 2;
                }
            }
            
            // set button and photo
            button.tag = photo;
            button.backgroundColor = [UIColor blackColor];
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            
            dispatch_group_t group = dispatch_group_create();

            dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^ {
                InstagramSwift* media = [self.allImages objectAtIndex:[self.allImages indexOfObject:image]];
                NSString* thumbnailUrl = media.thumbnailUrl;
                
                NSData* data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:thumbnailUrl]];
                UIImage* image = [UIImage imageWithData:data];

                dispatch_async(dispatch_get_main_queue(), ^ {
                    [self.gridScrollView addSubview:button];
                    [self.thumbnails addObject:button];
                    [button setBackgroundImage:image forState:UIControlStateNormal];
                });
            });
            
            dispatch_group_notify(group, dispatch_get_main_queue(), ^ {
                self.navigationItem.rightBarButtonItem.enabled = YES;
            });

            dispatch_release(group);

            ++col;++photo;item++;
            if (col >= klocationImagesPerRow) {
                col = 0;
            }
        }
    }];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - button actions

- (void)buttonAction:(id)sender
{
    UIButton* button = sender;
    ImageView* img = [[ImageView alloc] initWithMedia:[self.allImages objectAtIndex:button.tag]];
    [self.navigationController pushViewController:img animated:YES];
}


@end
