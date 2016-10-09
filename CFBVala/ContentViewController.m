//
//  ContentViewController.m
//  emlReader
//
//  Created by Chauster Kung on 2013/11/13.
//  Copyright (c) 2013年 Chauster Kung. All rights reserved.
//

#import "ContentViewController.h"

@interface ContentViewController ()

@end

@implementation ContentViewController
@synthesize webView, tableView, content;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.title = @"Video Player";
        webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        
        [webView setDelegate:self];
        
        [[self view] addSubview:webView];
        
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /*self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, self.view.bounds.size.height)  style:UITableViewStylePlain];
     self.tableView.delegate = self;
     self.tableView.dataSource = self;
     [self.view addSubview:self.webView];*/
    
    
}


- (void)didReceiveMemoryWarning
{
    //[super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return content.count;
}

- (UIFont *)fontForCell
{
    return [UIFont boldSystemFontOfSize:18.0];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellText = [self.content objectAtIndex:indexPath.row];
    UIFont *cellFont = [self fontForCell];
    CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
    CGRect textRect = [cellText boundingRectWithSize:constraintSize
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{NSFontAttributeName:cellFont}
                                             context:nil];
    
    CGSize labelSize = textRect.size;
    //CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
    
    return labelSize.height + 20;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [self fontForCell];
    cell.textLabel.text = [self.content objectAtIndex:indexPath.row];
    return cell;
}



@end
