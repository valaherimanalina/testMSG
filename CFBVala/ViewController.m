//
//  ViewController.m
//  emlReader
//
//  Created by Chauster Kung on 2013/11/12.
//  Copyright (c) 2013年 Chauster Kung. All rights reserved.
//

#import "ViewController.h"
#import "CFBReader/CFBFile.h"

@interface ViewController ()
{
    CFBFile *cfb;
}
@end

@implementation ViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    self.array = [NSMutableArray array];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, self.view.bounds.size.height)  style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    [NSThread detachNewThreadSelector:@selector(loadingData) toTarget:self withObject:nil];
}

- (void)loadingData
{
    // Unless they have been downloaded, there are no documents in the app. As a test case, we load a single document
    // from the embedded resources in the application.
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"MailDemo/test" ofType:@"msg"];

    [self.array addObject:path];
    /*
    NSString *path = [NSString stringWithFormat:@"%@/Documents/MailDemo/",NSHomeDirectory()];
    NSMutableArray *sourceFiles = [NSMutableArray arrayWithArray:[[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil]];
    
    for (NSString *str in sourceFiles)
    {
        if (![str hasPrefix:@"."])
        {
            [self.array addObject:str];
        }
    }
    */
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) 
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    cell.textLabel.text = [self.array objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *name = [self.array objectAtIndex:indexPath.row];
    // The name is the path, no need to construct something else
    NSString *path = name;
    //NSString *path = [NSString stringWithFormat:@"%@/Documents/MailDemo/%@",NSHomeDirectory(),name];
    

    
    ContentViewController *contentViewController = [[ContentViewController alloc] init];
    //contentViewController.content = [NSMutableArray arrayWithObjects:item.from,item.to,item.cc,item.date,item.subject, nil ];
    
    
    //NSLog(@"------------------------content---------------------");
    
    //[contentViewController.webView loadHTMLString:[contentViewController.content lastObject] baseURL:nil];
    
    //for (int i = 0; i<contentViewController.content.count; i++)
    //{
        //NSLog(@"view content -- %d= %@", (i+1), [contentViewController.content objectAtIndex:i]);
        //[contentViewController.webView loadHTMLString:[[[contentViewController.content objectAtIndex:i] stringByReplacingOccurrencesOfString:@"\n" withString:@"<br/>"] stringByAppendingString:@"<br/>"] baseURL:nil];
        //[contentViewController.webView loadHTMLString:@"TEST" baseURL:nil];
    //}
    
    [self testCompoundFileForReadingDoc:path];
    
    [self.navigationController pushViewController:contentViewController animated:YES];
}

-(void) writeToFileWithData:(NSData*)fileData fileName:(NSString*)fileName{
    //get the documents directory:
    NSString *path = [NSString stringWithFormat:@"%@/Documents/Data/",NSHomeDirectory()];
    
    //make a file name to write the data to using the documents directory:
    
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", path,fileName];
    
    //save content to the documents directory
    [fileData writeToFile:filePath atomically:YES];
}

-(void) writeToFileWithString:(NSString*)fileData fileName:(NSString*)fileName{
    
    //get the documents directory:
    NSString *path = [NSString stringWithFormat:@"%@/Documents/Data/",NSHomeDirectory()];

    //make a file name to write the data to using the documents directory:
    
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", path,fileName];
    
    //save content to the documents directory
    
    [fileData writeToFile:filePath
     
              atomically:NO 
     
                encoding:NSStringEncodingConversionAllowLossy 
     
                   error:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)testCompoundFileForReadingDoc:(NSString*)filePath
{
    if ( filePath )
    {
        NSLog( @"read : %@", filePath);
        
        NSError      *error      = nil;
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:filePath];
        NSData       *fileData   = [fileHandle readDataToEndOfFile];
        
        //NSLog(@"filedata : %@", fileData);
        
        [fileHandle closeFile];
        
        CFBFile    *file       = nil;
        
        file = [CFBFile compoundFileForReadingAtPath:filePath];
        
        NSAssert(file != nil, @"Failed to load file: %@", filePath, error.localizedDescription );
        
        file = [CFBFile compoundFileForReadingWithData:fileData];
        
        NSAssert(file != nil, @"Failed to load data: %@", filePath, error.localizedDescription );
    }
}

@end
