//
//  QDIMMessageTextModel.h
//  QDIM
//
//  Created by Yuanys on 2018/3/13.
//

#import "QDIMBaseMessageModel.h"

@interface QDIMMessageTextModel : QDIMBaseMessageModel

//消息文本内容
@property (nonatomic, copy) NSString *text;

@end
