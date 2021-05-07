#import <Preferences/PSListController.h>
#import <Preferences/PSListItemsController.h>
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSTableCell.h>

#import <CepheiPrefs/HBRootListController.h>
#import <Cephei/HBRespringController.h>

@interface CBIRootListController : PSListController
@property (nonatomic, retain) UIBarButtonItem *respringButton;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UIView *headerView;
@property (nonatomic, retain) UILabel *headerLabel;
-(void)discord;
-(void)paypal;
-(void)sourceCode;
@end
