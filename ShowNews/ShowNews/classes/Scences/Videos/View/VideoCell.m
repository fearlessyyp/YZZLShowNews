//
//  NewTableViewCell.m
//  WXAVPlayer
//
//  Created by lanou3g on 16/6/17.
//  Copyright © 2016年 wxerters. All rights reserved.
//

#import "VideoCell.h"
#import "UIImageView+WebCache.h"
#import <UMSocial.h>
#import <AVOSCloud/AVOSCloud.h>
#import <MBProgressHUD.h>
#import "DataBaseHandle.h"
@interface VideoCell ()

@property (nonatomic, assign)BOOL isPlaying;

/// 是否被收藏
@property (nonatomic, assign) BOOL isCollect;
/// 数据库中存储的id
@property (nonatomic, strong) NSString *objectId;


@end

@implementation VideoCell

+ (instancetype)cellWithTableView: (UITableView *)tableView{
    static NSString *identifier = @"tg";
    VideoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"VideoCell" owner:nil options:nil]firstObject];
    }
    return cell;
}

- (void)setModel:(VideoModel *)model{
    if (model != _model) {
        _model = nil;
        _model = model;
        [self.topicImgImageView sd_setImageWithURL:[NSURL URLWithString:model.topicImg]];
        self.titleLable.text = model.title;
        [self.backImageView sd_setImageWithURL:[NSURL URLWithString:model.cover]];
        self.topicNameLable.text = model.topicName;
    }
    
}

// 分享友盟的button
- (IBAction)shareButtonAction:(id)sender {

    // 回调block
    if (self.Block) {
        self.Block(self.model);
    }
}

// 收藏
- (IBAction)collectionButtonAction:(id)sender {
    if (self.isCollect) {
        // 删除逻辑
        NSString *cql = @"delete from VideoModel where objectId = ?";
        NSArray *pvalues =  @[self.objectId];
        [AVQuery doCloudQueryInBackgroundWithCQL:cql pvalues:pvalues callback:^(AVCloudQueryResult *result, NSError *error) {
            // 如果 error 为空，说明保存成功
            if (!error) {
                // 删除成功
               // sender.image = [[UIImage imageNamed:@"newscollect"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                [sender setImage:[UIImage imageNamed:@"action_love@2x"] forState:UIControlStateNormal];
                self.isCollect = NO;
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[self getCurrentVC].view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"取消收藏成功";
                hud.margin = 10.f;
                hud.yOffset = 0.f;
                hud.removeFromSuperViewOnHide = YES;
                [hud hide:YES afterDelay:1];
            } else {
                NSLog(@"~~~~~~error = %@", error);
            }
        }];
        
    } else {
        // 存储逻辑
        AVObject *object = [[DataBaseHandle sharedDataBaseHandle] videoToAVObject:self.model];
        [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                // 从表中获取数据->objectID
                [self selectFromNewsTable:sender];
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[self getCurrentVC].view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"收藏成功";
                hud.margin = 10.f;
                hud.yOffset = 0.f;
                hud.removeFromSuperViewOnHide = YES;
                [hud hide:YES afterDelay:1];
            } else {
                NSLog(@"!!!error = %@", error);
            }
        }];
    }
}

- (void)selectFromNewsTable:(UIButton *)collectItem {
    NSString *cql = [NSString stringWithFormat:@"select * from %@ where username = ? and mp4_url = ?", @"VideoModel"];
    NSLog(@"+++++++++%@", self.model);
    NSArray *pvalues =  @[@1, self.model.mp4_url];
    [AVQuery doCloudQueryInBackgroundWithCQL:cql pvalues:pvalues callback:^(AVCloudQueryResult *result, NSError *error) {
        if (!error) {
            // 操作成功
            if (result.results.count > 0) {
                AVObject *obj = result.results[0];
                self.objectId = obj.objectId;
//                collectItem.image = [[UIImage imageNamed:@"newscollected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                [collectItem setImage:[UIImage imageNamed:@"action_love_selected@2x"] forState:UIControlStateNormal];
                self.isCollect = YES;
            }
        } else {
            NSLog(@"%@", error);
        }
    }];
}

//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}


- (void)addMovie: (UIView *)view{
    [self.backImageView addSubview:view];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
