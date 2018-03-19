//
//  QDIMMessageViewFactory.m
//  QDIM
//
//  Created by Yuanys on 2018/3/12.
//

#import "QDIMMessageViewFactory.h"

// Model
#import "QDIMBaseMessageModel.h"
#import "QDIMMessageTextModel.h"
#import "QDIMMessageImgModel.h"
#import "QDIMMessageLocationModel.h"
#import "QDIMMessageVideoModel.h"
#import "QDIMMessageVoiceModel.h"
#import "QDIMMessageSysTipModel.h"

// View
#import "QDIMBaseMessageView.h"
#import "QDIMMessageTextView.h"
#import "QDIMMessageImgView.h"

//viewModel
#import "QDIMMessageTextModel.h"
#import "QDIMMessageImgModel.h"


@implementation QDIMMessageViewFactory

+ (nonnull QDIMBaseMessageView *)createMessageView:(nonnull QDIMBaseMessageModel *)messageModel
{
    QDIMBaseMessageView *messageView = nil;
    switch (messageModel.messageType) {
        case QDIMCellMessageType_Text:
        {
            messageView = [self produceTextView:(QDIMMessageTextModel *)messageModel];
        }
            break;
        case QDIMCellMessageType_Img:
        {
            messageView = [self produceImgView:(QDIMMessageImgModel *)messageModel];
        }
            break;
        case QDIMCellMessageType_Location:
        {
            messageView = [self produceLocationView:(QDIMMessageLocationModel *)messageModel];
        }
            break;
        case QDIMCellMessageType_Video:
        {
            messageView = [self produceVideoView:(QDIMMessageVideoModel *)messageModel];
        }
            break;
        case QDIMCellMessageType_Voice:
        {
            messageView = [self produceVoiceView:(QDIMMessageVoiceModel *)messageModel];
        }
            break;
        case QDIMCellMessageType_SysTip:
        {
            messageView = [self produceSysTipView:(QDIMMessageSysTipModel *)messageModel];
        }
            break;
        default:
        {
            messageView = [[QDIMBaseMessageView alloc] init];
        }
            break;
    }
    return messageView;
}

#pragma mark - Private
// MARK: 生成不同的View
// 文本View
+ (nonnull QDIMBaseMessageView *)produceTextView:(QDIMMessageTextModel *)textModel
{
    QDIMMessageTextViewModel *vm = [[QDIMMessageTextViewModel alloc]initWithTextModel:textModel];
    return [[QDIMMessageTextView alloc]initWithTextViewModel:vm];
}
// 图片View
+ (nonnull QDIMBaseMessageView *)produceImgView:(QDIMMessageImgModel *)imgModel
{
    QDIMMessageImgViewModel *vm = [[QDIMMessageImgViewModel alloc]initWithImgModel:imgModel];
    return [[QDIMMessageImgView alloc]initWithImgViewModel:vm];
}
// 地理位置View
+ (nonnull QDIMBaseMessageView *)produceLocationView:(QDIMMessageLocationModel *)locationModel
{
    return nil;
}
// 视频View
+ (nonnull QDIMBaseMessageView *)produceVideoView:(QDIMMessageVideoModel *)videoModel
{
    return nil;
}
// 声音View
+ (nonnull QDIMBaseMessageView *)produceVoiceView:(QDIMMessageVoiceModel *)voiceModel
{
    return nil;
}
// 提示View
+ (nonnull QDIMBaseMessageView *)produceSysTipView:(QDIMMessageSysTipModel *)sysTipModel
{
    return nil;
}

@end
