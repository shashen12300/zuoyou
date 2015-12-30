//
//  musicViewCell.m
//  zuoyou
//
//  Created by mijibao on 15/11/28.
//  Copyright © 2015年 microe. All rights reserved.
//

#import "musicViewCell.h"

@implementation musicViewCell

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor = RGBCOLOR(55, 48, 36);

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
