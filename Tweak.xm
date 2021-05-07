#import "UIColor+Hex.h"
#import "YSCWaterWaveView.h"
#include <Cephei/HBPreferences.h>

// Wave animation
// https://github.com/xiaochaofeiyu/YSCAnimation

// This site is great for UIColor
// https://www.uicolor.io

@interface SBRootFolderController : UIViewController
@end

HBPreferences *preferences;
UIView *waterView;
YSCWaterWaveView *waterWave;
UIDevice *myDevice;
BOOL enabled;
BOOL waveFillUpAnimation;
NSString *firstWaveColorString;
NSString *secondWaveColorString;
CGFloat firstWaveAlpha;
CGFloat secondWaveAlpha;
CGFloat waveAmplitude;

%group CurrentWave

%hook SBRootFolderController

-(void)viewDidAppear:(BOOL)animated {
	%orig;
	if (!waterView) {		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateWavePercent) name:@"UIDeviceBatteryLevelDidChangeNotification" object:nil];

		waterView = [[UIView alloc] initWithFrame:[[self view] bounds]];
		waterView.backgroundColor = UIColor.clearColor;
		[[self view] insertSubview:waterView atIndex:0];

		myDevice = [UIDevice currentDevice];
		[myDevice setBatteryMonitoringEnabled:YES];

		waterWave = [[%c(YSCWaterWaveView) alloc] initWithFrame:[[self view] bounds] waveSpeed:0.127f startupSpeed:2.0 waveAmplitudeMultiplier:waveAmplitude];
		// if (!waveFillUpAnimation) {
		// 	[waterWave setCurrentWavePointY:];
		// }
		waterWave.percent = [myDevice batteryLevel];
		waterWave.firstWaveColor = [UIColor pf_colorWithHexString:firstWaveColorString alpha:firstWaveAlpha/10];
		waterWave.secondWaveColor = [UIColor pf_colorWithHexString:secondWaveColorString alpha:secondWaveAlpha/10];
		[waterView addSubview:waterWave];
		[waterWave startWave];
	}
}

%new
-(void)updateWavePercent {
	if (waterWave) {
		waterWave.percent = [myDevice batteryLevel];
	}
}

%end

%end

%ctor {
	preferences = [[HBPreferences alloc] initWithIdentifier:@"com.chr1s.currentprefs"];
	[preferences registerBool:&enabled default:YES forKey:@"enabled"];
	[preferences registerBool:&waveFillUpAnimation default:YES forKey:@"waveFillUpAnimation"];
	[preferences registerObject:&firstWaveColorString default:@"#36ADEC" forKey:@"firstWaveColor"];
	[preferences registerObject:&secondWaveColorString default:@"#36DBEC" forKey:@"secondWaveColor"];
	[preferences registerFloat:&firstWaveAlpha default:4 forKey:@"firstWaveAlpha"];
	[preferences registerFloat:&secondWaveAlpha default:5 forKey:@"secondWaveAlpha"];
	[preferences registerFloat:&waveAmplitude default:8 forKey:@"waveAmplitude"];
	if (enabled) {
		%init(CurrentWave);
	}
}