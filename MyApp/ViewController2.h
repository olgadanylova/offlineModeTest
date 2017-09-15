
#import "ViewController.h"
@class Person;

@interface ViewController2 : ViewController

- (IBAction)findByIdSync:(id)sender;
- (IBAction)findByIdAsync:(id)sender;
- (IBAction)findByIdQuerySync:(id)sender;
- (IBAction)findByIdQueryAsync:(id)sender;
- (IBAction)getObjectCountSync:(id)sender;
- (IBAction)getObjectCountAsync:(id)sender;
- (IBAction)getObjectCoutQuerySync:(id)sender;
- (IBAction)getObjectCountQueryAsync:(id)sender;
- (IBAction)findFirstSync:(id)sender;
- (IBAction)findLastSync:(id)sender;
- (IBAction)findFirstAsync:(id)sender;
- (IBAction)findLastAsync:(id)sender;

@end
