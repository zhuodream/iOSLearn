//
//  KVCTableViewCell.m
//  ZYXMyKVO
//
//  Created by 7road on 15/12/21.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import "KVCTableViewCell.h"

@implementation KVCTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (BOOL)isReady
{
    return (self.object && [self.property length] > 0);
}

- (void)update
{
    self.textLabel.text = self.isReady ? [[self.object valueForKeyPath:self.property]  description] : @"";
}

- (id)initWithReuseIdentifier:(NSString *)identifier
{
    return [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
}

- (void)removeObservation
{
    if (self.isReady)
    {
        [self.object removeObserver:self forKeyPath:self.property];
    }
}

- (void)addObservation
{
    if (self.isReady)
    {
        [self.object addObserver:self forKeyPath:self.property options:0 context:(void*)self];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ((__bridge id)context == self)
    {
        [self update];
    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)setObject:(id)object
{
    [self removeObservation];
    _object = object;
    [self addObservation];
    [self update];
}

- (void)setProperty:(NSString *)property
{
    [self removeObservation];
    _property = property;
    [self addObservation];
    [self update];
}
@end
