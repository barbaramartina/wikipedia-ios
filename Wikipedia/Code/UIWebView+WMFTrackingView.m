//  Created by Monte Hurd on 2/16/15.
//  Copyright (c) 2015 Wikimedia Foundation. Provided under MIT-style license; please copy and modify!

#import "UIWebView+WMFTrackingView.h"
#import "UIView+WMFSearchSubviews.h"

@implementation UIWebView (TrackingView)

- (UIView*)wmf_browserView {
    return [self.scrollView wmf_firstSubviewOfClass:NSClassFromString(@"UIWebBrowserView")];
}

@end
