
#import <Foundation/Foundation.h>

@interface TabSquareRemoteActivation : NSObject {
    
    UIView   *popupSuperView;
    UIButton *menuButton;
}



+(TabSquareRemoteActivation *)remoteActivation;
-(void)setEditModeData;
-(void)switchToEditMode;
-(void)switchToViewMode;
-(void)tablesUpdated;
-(void)registerRemoteNotification:(id)obj;
-(void)setPopupSuperView:(UIView *)_view;
-(void)setMainMenuButton:(UIButton *)btn;


@end
