#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import <mach-o/dyld.h>
#import <substrate.h>
#include <stdatomic.h>
#include <stdlib.h>
#include <string.h>

typedef void (*HBSetAlphaIMP)(id, SEL, CGFloat);
typedef void (*HBDidMoveIMP)(id, SEL);

typedef struct {
	const char *className;
	HBSetAlphaIMP original;
} HBAlphaSlot;

typedef struct {
	const char *className;
	HBDidMoveIMP original;
} HBDidMoveSlot;

static HBAlphaSlot HBAlphaSlots[] = {
	{ "MTLumaDodgePillView", NULL },
	{ "MTStaticColorPillView", NULL },
	{ "CSAlwaysOnHomeAffordancePillView", NULL },
	{ "SBFHomeAffordanceView", NULL }
};

static HBDidMoveSlot HBDidMoveSlots[] = {
	{ "MTLumaDodgePillView", NULL },
	{ "MTStaticColorPillView", NULL },
	{ "CSAlwaysOnHomeAffordancePillView", NULL },
	{ "SBFHomeAffordanceView", NULL }
};

static BOOL HBMethodMatches(Method method, unsigned int argCount, const char *retType, const char *arg2Type) {
	if (!method || method_getNumberOfArguments(method) != argCount) {
		return NO;
	}

	char *ret = method_copyReturnType(method);
	BOOL ok = (ret != NULL && strcmp(ret, retType) == 0);
	free(ret);
	if (!ok) {
		return NO;
	}

	char *t0 = method_copyArgumentType(method, 0);
	char *t1 = method_copyArgumentType(method, 1);
	ok = (t0 != NULL && t1 != NULL && strcmp(t0, "@") == 0 && strcmp(t1, ":") == 0);
	free(t0);
	free(t1);
	if (!ok) {
		return NO;
	}

	if (arg2Type != NULL) {
		char *t2 = method_copyArgumentType(method, 2);
		ok = (t2 != NULL && strcmp(t2, arg2Type) == 0);
		free(t2);
	}

	return ok;
}

static void HBSetAlpha(id view, SEL cmd, CGFloat alpha, unsigned int slot) {
	(void)alpha;
	if (HBAlphaSlots[slot].original) {
		HBAlphaSlots[slot].original(view, cmd, 0.0);
	}
}

#define HB_ALPHA_HOOK(N) \
	static void HBAlphaHook##N(id view, SEL cmd, CGFloat alpha) { \
		HBSetAlpha(view, cmd, alpha, N); \
	}

HB_ALPHA_HOOK(0)
HB_ALPHA_HOOK(1)
HB_ALPHA_HOOK(2)
HB_ALPHA_HOOK(3)

static IMP const HBAlphaHooks[] = {
	(IMP)HBAlphaHook0,
	(IMP)HBAlphaHook1,
	(IMP)HBAlphaHook2,
	(IMP)HBAlphaHook3
};

static void HBDidMove(id view, SEL cmd, unsigned int slot) {
	if (HBDidMoveSlots[slot].original) {
		HBDidMoveSlots[slot].original(view, cmd);
	}
	if ([NSThread isMainThread] && [view isKindOfClass:[UIView class]]) {
		[(UIView *)view setAlpha:0.0];
	}
}

#define HB_DIDMOVE_HOOK(N) \
	static void HBDidMoveHook##N(id view, SEL cmd) { \
		HBDidMove(view, cmd, N); \
	}

HB_DIDMOVE_HOOK(0)
HB_DIDMOVE_HOOK(1)
HB_DIDMOVE_HOOK(2)
HB_DIDMOVE_HOOK(3)

static IMP const HBDidMoveHooks[] = {
	(IMP)HBDidMoveHook0,
	(IMP)HBDidMoveHook1,
	(IMP)HBDidMoveHook2,
	(IMP)HBDidMoveHook3
};

static void HBInstallHooks(void) {
	Class uiViewClass = [UIView class];

	for (unsigned int i = 0; i < sizeof(HBAlphaSlots) / sizeof(HBAlphaSlots[0]); i++) {
		if (HBAlphaSlots[i].original != NULL) {
			continue;
		}
		Class cls = objc_getClass(HBAlphaSlots[i].className);
		if (!cls || ![cls isSubclassOfClass:uiViewClass]) {
			continue;
		}
		Method method = class_getInstanceMethod(cls, @selector(setAlpha:));
		if (!HBMethodMatches(method, 3, "v", "d")) {
			continue;
		}
		MSHookMessageEx(cls, @selector(setAlpha:), HBAlphaHooks[i], (IMP *)&HBAlphaSlots[i].original);
	}

	for (unsigned int i = 0; i < sizeof(HBDidMoveSlots) / sizeof(HBDidMoveSlots[0]); i++) {
		if (HBDidMoveSlots[i].original != NULL) {
			continue;
		}
		Class cls = objc_getClass(HBDidMoveSlots[i].className);
		if (!cls || ![cls isSubclassOfClass:uiViewClass]) {
			continue;
		}
		Method method = class_getInstanceMethod(cls, @selector(didMoveToWindow));
		if (!HBMethodMatches(method, 2, "v", NULL)) {
			continue;
		}
		MSHookMessageEx(cls, @selector(didMoveToWindow), HBDidMoveHooks[i], (IMP *)&HBDidMoveSlots[i].original);
	}
}

static void HBImageLoaded(const struct mach_header *header, intptr_t slide) {
	(void)header;
	(void)slide;
	static atomic_bool pending = false;
	if (atomic_exchange(&pending, true)) {
		return;
	}
	dispatch_async(dispatch_get_main_queue(), ^{
		atomic_store(&pending, false);
		HBInstallHooks();
	});
}

__attribute__((constructor)) static void HBInitialize(void) {
	@autoreleasepool {
		NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];
		if (![bundleID isEqualToString:@"com.apple.springboard"]) {
			return;
		}
		HBInstallHooks();
		_dyld_register_func_for_add_image(HBImageLoaded);
	}
}
