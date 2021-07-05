#import "UIColor+Hex.h"
#import "YSCWaterWaveView.h"
#include <Cephei/HBPreferences.h>

// Wave animation
// https://github.com/xiaochaofeiyu/YSCAnimation

// This site is great for UIColors
// https://www.uicolor.io

@interface SBRootFolderController : UIViewController
@property (nonatomic, retain) UIView* waterView;
@property (nonatomic, retain) YSCWaterWaveView *waterWave;
@end

@interface CSCoverSheetViewController : UIViewController
@property (nonatomic, retain) UIView* waterView;
@property (nonatomic, retain) YSCWaterWaveView *waterWave;
@end

HBPreferences *preferences;
UIDevice *myDevice;
UIDevice *myDeviceTwo;
BOOL enabled;
NSString *firstWaveColorString;
NSString *secondWaveColorString;
CGFloat firstWaveAlpha;
CGFloat secondWaveAlpha;
CGFloat waveAmplitude;
NSInteger waveLocation;

%group CurrentWaveLock

%hook CSCoverSheetViewController

%property (nonatomic, retain) UIView* waterView;
%property (nonatomic, retain) YSCWaterWaveView *waterWave;

-(void)viewDidAppear:(BOOL)animated {
	%orig;
	if (!self.waterView) {
		myDeviceTwo = [UIDevice currentDevice];
		[myDeviceTwo setBatteryMonitoringEnabled:YES];
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkForCharging:) name:UIDeviceBatteryStateDidChangeNotification object:[UIDevice currentDevice]];	
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateWavePercent) name:UIDeviceBatteryLevelDidChangeNotification object:nil];

		self.waterView = [[UIView alloc] initWithFrame:[[self view] bounds]];
		[self.waterView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
		self.waterView.backgroundColor = UIColor.clearColor;
		[[self view] insertSubview:self.waterView atIndex:0];

		self.waterWave = [[%c(YSCWaterWaveView) alloc] initWithFrame:[[self view] bounds] waveSpeed:0.127f startupSpeed:2.0 waveAmplitudeMultiplier:waveAmplitude];
		[self.waterWave setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
		[self.waterWave setPercent:[myDeviceTwo batteryLevel]];
		self.waterWave.firstWaveColor = [UIColor pf_colorWithHexString:firstWaveColorString alpha:firstWaveAlpha/10];
		self.waterWave.secondWaveColor = [UIColor pf_colorWithHexString:secondWaveColorString alpha:secondWaveAlpha/10];
		[self.waterView addSubview:self.waterWave];
		[self.waterWave startWave];

		[preferences registerPreferenceChangeBlock:^{
			if ([preferences boolForKey:@"showWhileCharging"] && !([[UIDevice currentDevice] batteryState] == UIDeviceBatteryStateCharging)) {
				self.waterView.alpha = 0.0;
			} else if (![preferences boolForKey:@"showWhileCharging"]) {
				self.waterView.alpha = 1.0;
			}
		}];

	}
}

%new
-(void)updateWavePercent {
	if (self.waterWave) {
		self.waterWave.percent = [myDeviceTwo batteryLevel];
	}
}

%new
-(void)checkForCharging:(long long)state {
	if (!self.waterView) return;
	if (![preferences boolForKey:@"showWhileCharging"]) return;
	if ([myDeviceTwo batteryState] == UIDeviceBatteryStateCharging) {
		[UIView animateWithDuration:0.7
				animations:^{
					self.waterView.alpha = 1.0;
				}];
	} else {
		[UIView animateWithDuration:0.6
				animations:^{
					self.waterView.alpha = 0.0;
				}];
	}
}

%end

%end

%group CurrentWaveHome

%hook SBRootFolderController

%property (nonatomic, retain) UIView* waterView;
%property (nonatomic, retain) YSCWaterWaveView *waterWave;

-(void)viewDidAppear:(BOOL)animated {
	%orig;
	if (!self.waterView) {		
		myDevice = [UIDevice currentDevice];
		[myDevice setBatteryMonitoringEnabled:YES];

		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkForCharging:) name:UIDeviceBatteryStateDidChangeNotification object:[UIDevice currentDevice]];	
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateWavePercent) name:UIDeviceBatteryLevelDidChangeNotification object:nil];

		self.waterView = [[UIView alloc] initWithFrame:[[self view] bounds]];
		[self.waterView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
		self.waterView.backgroundColor = UIColor.clearColor;
		[[self view] insertSubview:self.waterView atIndex:0];

		self.waterWave = [[%c(YSCWaterWaveView) alloc] initWithFrame:[[self view] bounds] waveSpeed:0.127f startupSpeed:2.0 waveAmplitudeMultiplier:waveAmplitude];
		[self.waterWave setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
		self.waterWave.percent = [myDevice batteryLevel];
		self.waterWave.firstWaveColor = [UIColor pf_colorWithHexString:firstWaveColorString alpha:firstWaveAlpha/10];
		self.waterWave.secondWaveColor = [UIColor pf_colorWithHexString:secondWaveColorString alpha:secondWaveAlpha/10];
		[self.waterView addSubview:self.waterWave];
		[self.waterWave startWave];

		[preferences registerPreferenceChangeBlock:^{
			if ([preferences boolForKey:@"showWhileCharging"] && !([[UIDevice currentDevice] batteryState] == UIDeviceBatteryStateCharging)) {
				self.waterView.alpha = 0.0;
			} else if (![preferences boolForKey:@"showWhileCharging"]) {
				self.waterView.alpha = 1.0;
			}
		}];

	}
}

%new
-(void)updateWavePercent {
	if (self.waterWave) {
		self.waterWave.percent = [myDevice batteryLevel];
	}
}

%new
-(void)checkForCharging:(long long)state {
	if (!self.waterView) return;
	if (![preferences boolForKey:@"showWhileCharging"]) return;
	if ([myDeviceTwo batteryState] == UIDeviceBatteryStateCharging) {
		[UIView animateWithDuration:0.7
				animations:^{
					self.waterView.alpha = 1.0;
				}];
	} else {
		[UIView animateWithDuration:0.6
				animations:^{
					self.waterView.alpha = 0.0;
				}];
	}
}

%end

%end

%ctor {
	preferences = [[HBPreferences alloc] initWithIdentifier:@"com.chr1s.currentprefs"];
	[preferences registerBool:&enabled default:YES forKey:@"enabled"];
	[preferences registerObject:&firstWaveColorString default:@"#36ADEC" forKey:@"firstWaveColor"];
	[preferences registerObject:&secondWaveColorString default:@"#36DBEC" forKey:@"secondWaveColor"];
	[preferences registerFloat:&firstWaveAlpha default:3 forKey:@"firstWaveAlpha"];
	[preferences registerFloat:&secondWaveAlpha default:4 forKey:@"secondWaveAlpha"];
	[preferences registerFloat:&waveAmplitude default:8 forKey:@"waveAmplitude"];
	[preferences registerInteger:&waveLocation default:2 forKey:@"waveLocation"];

	if (enabled) {
		if (waveLocation == 0 || waveLocation == 1)
			%init(CurrentWaveHome);
		if (waveLocation == 0 || waveLocation == 2)
			%init(CurrentWaveLock);
	}
}
