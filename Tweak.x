#import <UIKit/UIKit.h>

@interface SBFHomeGrabberSettings : NSObject
@end

@interface SBHomeGrabberView : UIView
@end

@interface CSHomeAffordanceView : UIView
@end

@interface SBDashBoardHomeAffordanceView : UIView
@end

@interface MTLumaDodgePillView : UIView
@end

@interface MTStaticColorPillView : UIView
@end

%hook SBFHomeGrabberSettings

- (BOOL)isEnabled {
	return NO;
}

- (void)setEnabled:(BOOL)enabled {
	%orig(NO);
}

%end

%hook SBHomeGrabberView

- (void)didMoveToWindow {
	%orig;
	self.hidden = YES;
	self.alpha = 0.0;
}

- (void)layoutSubviews {
	%orig;
	self.hidden = YES;
	self.alpha = 0.0;
}

- (void)setHidden:(BOOL)hidden {
	%orig(YES);
}

- (void)setAlpha:(CGFloat)alpha {
	%orig(0.0);
}

%end

%hook CSHomeAffordanceView

- (void)didMoveToWindow {
	%orig;
	self.hidden = YES;
	self.alpha = 0.0;
}

- (void)layoutSubviews {
	%orig;
	self.hidden = YES;
	self.alpha = 0.0;
}

- (void)setHidden:(BOOL)hidden {
	%orig(YES);
}

- (void)setAlpha:(CGFloat)alpha {
	%orig(0.0);
}

%end

%hook SBDashBoardHomeAffordanceView

- (void)didMoveToWindow {
	%orig;
	self.hidden = YES;
	self.alpha = 0.0;
}

- (void)layoutSubviews {
	%orig;
	self.hidden = YES;
	self.alpha = 0.0;
}

- (void)setHidden:(BOOL)hidden {
	%orig(YES);
}

- (void)setAlpha:(CGFloat)alpha {
	%orig(0.0);
}

%end

%hook MTLumaDodgePillView

- (void)didMoveToWindow {
	%orig;
	self.hidden = YES;
	self.alpha = 0.0;
}

- (void)layoutSubviews {
	%orig;
	self.hidden = YES;
	self.alpha = 0.0;
}

- (void)setHidden:(BOOL)hidden {
	%orig(YES);
}

- (void)setAlpha:(CGFloat)alpha {
	%orig(0.0);
}

%end

%hook MTStaticColorPillView

- (void)didMoveToWindow {
	%orig;
	self.hidden = YES;
	self.alpha = 0.0;
}

- (void)layoutSubviews {
	%orig;
	self.hidden = YES;
	self.alpha = 0.0;
}

- (void)setHidden:(BOOL)hidden {
	%orig(YES);
}

- (void)setAlpha:(CGFloat)alpha {
	%orig(0.0);
}

%end
