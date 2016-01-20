//
//  ViewController.m
//  JRTAPIModel
//
//  Created by Juan Garcia on 1/19/16.
//  Copyright © 2016 jerti. All rights reserved.
//

#import "ViewController.h"
#import "PostModel.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic, strong)PostModel *model;
@end

@implementation ViewController

- (PostModel *)model
{
    if (!_model)
    {
        _model =  [PostModel new];
    }
    return _model;
}

- (IBAction)requestAction:(UISegmentedControl *)sender
{
    switch (sender.selectedSegmentIndex)
    {
        case 0:
            [self list];
            break;
        case 1:
            [self create];
            break;
        case 2:
            [self read];
            break;
        case 3:
            [self update];
            break;
        case 4:
            [self delete];
            break;
        default:
            break;
    }
    
    
}

- (void)list
{
    [self.activityIndicator startAnimating];
    [self.model GETpostsSuccess:^(id data)
    {
        self.textView.text = [NSString stringWithFormat:@"Data: %@",data];
        [self.activityIndicator stopAnimating];
    }
                        failure:^(NSError *error)
    {
        self.textView.text = [NSString stringWithFormat:@"Error: %@", error];
        [self.activityIndicator stopAnimating];
    }];
}

- (void)create
{
    [self.activityIndicator startAnimating];
    [self.model POSTpostSuccess:^(id data)
     {
         self.textView.text = [NSString stringWithFormat:@"Data: %@",data];
         [self.activityIndicator stopAnimating];
     }
                        failure:^(NSError *error)
     {
         self.textView.text = [NSString stringWithFormat:@"Error: %@", error];
         [self.activityIndicator stopAnimating];
     }];

}

- (void)read
{
    [self.activityIndicator startAnimating];
    [self.model GETpostOneSuccess:^(id data)
     {
         self.textView.text = [NSString stringWithFormat:@"Data: %@",data];
         [self.activityIndicator stopAnimating];
     }
                        failure:^(NSError *error)
     {
         self.textView.text = [NSString stringWithFormat:@"Error: %@", error];
         [self.activityIndicator stopAnimating];
     }];

}

- (void)update
{
    [self.activityIndicator startAnimating];
    [self.model PUTpostOneSuccess:^(id data)
     {
         self.textView.text = [NSString stringWithFormat:@"Data: %@",data];
         [self.activityIndicator stopAnimating];
     }
                        failure:^(NSError *error)
     {
         self.textView.text = [NSString stringWithFormat:@"Error: %@", error];
         [self.activityIndicator stopAnimating];
     }];
}

- (void)delete
{
    [self.activityIndicator startAnimating];
    [self.model DELETEpostOneSuccess:^(id data)
     {
         self.textView.text = [NSString stringWithFormat:@"Data: %@",data];
         [self.activityIndicator stopAnimating];
     }
                        failure:^(NSError *error)
     {
         self.textView.text = [NSString stringWithFormat:@"Error: %@", error];
         [self.activityIndicator stopAnimating];
     }];
}

@end
