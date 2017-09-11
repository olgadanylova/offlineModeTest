
#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

- (IBAction)findSync:(id)sender;
- (IBAction)findQuerySync:(id)sender;
- (IBAction)addNewPersonSync:(id)sender;
- (IBAction)addNewAddressSync:(id)sender;
- (IBAction)updateFirstPersonSync:(id)sender;
- (IBAction)updateFirstAddressSync:(id)sender;

- (IBAction)findAsync:(id)sender;
- (IBAction)findQueryAsync:(id)sender;
- (IBAction)addNewPersonAsync:(id)sender;
- (IBAction)addNewAddressAsync:(id)sender;
- (IBAction)updateFirstPersonAsync:(id)sender;
- (IBAction)updateFirstAddressAsync:(id)sender;

@end
