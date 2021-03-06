
#import "UIViewController+WMFSearchButton_Testing.h"
#import "WMFSearchViewController.h"
#import <BlocksKit/UIBarButtonItem+BlocksKit.h>
#import "SessionSingleton.h"
#import "UIViewController+WMFArticlePresentation.h"
#import "MWKSite.h"
#import "PiwikTracker+WMFExtensions.h"


NS_ASSUME_NONNULL_BEGIN

@implementation UIViewController (WMFSearchButton)

+ (void)load {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(wmfSearchButton_applicationDidEnterBackgroundWithNotification:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(wmfSearchButton_applicationDidReceiveMemoryWarningWithNotification:)
                                                 name:UIApplicationDidReceiveMemoryWarningNotification
                                               object:nil];
}

+ (void)wmfSearchButton_applicationDidEnterBackgroundWithNotification:(NSNotification*)note {
    [self wmfSearchButton_resetSharedSearchButton];
}

+ (void)wmfSearchButton_applicationDidReceiveMemoryWarningWithNotification:(NSNotification*)note {
    [self wmfSearchButton_resetSharedSearchButton];
}

- (UIBarButtonItem*)wmf_searchBarButtonItemWithDelegate:(UIViewController<WMFSearchPresentationDelegate>*)delegate {
    @weakify(self);
    @weakify(delegate);
    return [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"search"]
                                               style:UIBarButtonItemStylePlain
                                             handler:^(id sender) {
        @strongify(self);
        @strongify(delegate);
        if (!delegate || !self) {
            return;
        }

        [self wmf_showSearchAnimated:YES delegate:delegate];
    }];
}

- (void)wmf_showSearchAnimated:(BOOL)animated delegate:(UIViewController<WMFSearchPresentationDelegate>*)delegate {
    MWKSite* searchSite = [[SessionSingleton sharedInstance] searchSite];

    if (![searchSite isEqual:_sharedSearchViewController.searchSite]) {
        WMFSearchViewController* searchVC =
            [WMFSearchViewController searchViewControllerWithSite:searchSite
                                                        dataStore:[delegate searchDataStore]];
        _sharedSearchViewController = searchVC;
    }
    _sharedSearchViewController.searchResultDelegate = delegate;
    [[PiwikTracker sharedInstance] wmf_logView:_sharedSearchViewController];
    [self presentViewController:_sharedSearchViewController animated:animated completion:nil];
}

@end

NS_ASSUME_NONNULL_END
