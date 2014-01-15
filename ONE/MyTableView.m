//
//  MyTableView.m
//  ONE
//
//  Created by Liang Wei on 5/10/13.
//  Copyright (c) 2013 dianji. All rights reserved.
//

#import "MyTableView.h"

@implementation MyTableView

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if (self.dragging) {
        [super touchesBegan:touches withEvent:event];
    }else
    {
        [[self nextResponder] touchesBegan:touches withEvent:event];
    }
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.dragging) {
        [super touchesEnded:touches withEvent:event];
    }else{
        [[self nextResponder] touchesEnded:touches withEvent:event];
    }
}

@end
