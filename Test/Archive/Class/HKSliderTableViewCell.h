//
//  HKSliderTableViewCell.h
//  NewConcept
//
//  Created by user on 14-7-9.
//  Copyright (c) 2014年 Ice. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HKSliderTableViewCellDelegte <NSObject>

- (void)sliderTableViewCellValueChanged:(id)sender;

@end

@interface HKSliderTableViewCell : UITableViewCell

@property (nonatomic, assign) id<HKSliderTableViewCellDelegte> delegate;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UISlider *slider;

- (IBAction)valueChanged:(id)sender;

@end
