
#import "ViewController2.h"
#import "Backendless.h"
#import "Person.h"

@interface ViewController2() {
    NSArray<Person *> *personArray;
    NSArray<NSDictionary *> *addressArray;
    id<IDataStore>personStore;
    id<IDataStore>addressStore;
}
@end

@implementation ViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    
    personArray = [NSArray<Person *>new];
    addressArray = [NSArray<NSDictionary *> new];
    
    personStore = [backendless.data of:[Person class]];
    [personStore enableOffline:^() {
        printf("Table 'Person' sync compete\n");
    } error:^(Fault *fault) {
        printf("%s\n", [fault.message UTF8String]);
    }];
    
    addressStore = [backendless.data ofTable:@"Address"];
    [addressStore enableOffline:^() {
        printf("Table 'Address' sync compete\n");
    } error:^(Fault *fault) {
        printf("%s\n", [fault.message UTF8String]);
    }];
    
}

- (IBAction)findByIdSync:(id)sender {
    NSString *personId = @"8F40161F-9DCA-77AA-FF97-66762BCC9000";
    printf("*** PERSON WITH ID = %s ***\n", [personId UTF8String]);
    Person *person = [personStore findById:personId];
    printf("%s: %i\n", [person.name UTF8String], person.age);
    
    NSString *addressId = @"39BF94B3-9E2A-5460-FF82-D700E621EF00";
    printf("*** ADDRESS WITH ID = %s ***\n", [addressId UTF8String]);
    NSDictionary *address = [addressStore findById:addressId];
    NSString *city = [address valueForKey:@"city"];
    NSString *country = [address valueForKey:@"country"];
    printf("%s: %s\n", [city UTF8String], [country UTF8String]);
}

- (IBAction)findByIdAsync:(id)sender {
    NSString *personId = @"8F40161F-9DCA-77AA-FF97-66762BCC9000";
    [personStore findById:personId
                 response:^(Person *person) {
                     printf("*** PERSON WITH ID = %s ***\n", [personId UTF8String]);
                     printf("%s: %i\n", [person.name UTF8String], person.age);
                 }
                    error:^(Fault *fault) {
                        printf("Fault: %s", [fault.message UTF8String]);
                    }];
    
    NSString *addressId = @"39BF94B3-9E2A-5460-FF82-D700E621EF00";
    [addressStore findById:addressId
                  response:^(NSDictionary *address) {
                      printf("*** ADDRESS WITH ID = %s ***\n", [addressId UTF8String]);
                      NSString *city = [address valueForKey:@"city"];
                      NSString *country = [address valueForKey:@"country"];
                      printf("%s: %s\n", [city UTF8String], [country UTF8String]);
                  }
                     error:^(Fault *fault) {
                         printf("Fault: %s", [fault.message UTF8String]);
                     }];
    
}

- (IBAction)findByIdQuerySync:(id)sender {
    NSString *personId = @"8F40161F-9DCA-77AA-FF97-66762BCC9000";
    printf("*** PERSON WITH ID = %s ***\n", [personId UTF8String]);
    Person *person = [personStore findById:personId];
    printf("%s: %i\n", [person.name UTF8String], person.age);
    
    NSString *addressId = @"39BF94B3-9E2A-5460-FF82-D700E621EF00";
    printf("*** ADDRESS WITH ID = %s ***\n", [addressId UTF8String]);
    NSDictionary *address = [addressStore findById:addressId];
    NSString *city = [address valueForKey:@"city"];
    NSString *country = [address valueForKey:@"country"];
    printf("%s: %s\n", [city UTF8String], [country UTF8String]);
}

- (IBAction)findByIdQueryAsync:(id)sender {
    printf("TODO");
}

- (IBAction)getObjectCountSync:(id)sender {
    printf("*** PERSON COUNT = %s ***\n", [[[personStore getObjectCount] stringValue] UTF8String]);
    printf("*** ADDRESS COUNT = %s ***\n", [[[addressStore getObjectCount] stringValue] UTF8String]);
}

- (IBAction)getObjectCountAsync:(id)sender {
    [personStore getObjectCount:^(NSNumber *count) {
        printf("*** PERSON COUNT = %s ***\n", [[count stringValue] UTF8String]);
    } error:^(Fault *fault) {
        printf("Fault: %s", [fault.message UTF8String]);
    }];
    
    [addressStore getObjectCount:^(NSNumber *count) {
        printf("*** ADDRESS COUNT = %s ***\n", [[count stringValue] UTF8String]);
    } error:^(Fault *fault) {
        printf("Fault: %s", [fault.message UTF8String]);
    }];
}

- (IBAction)getObjectCoutQuerySync:(id)sender {
    DataQueryBuilder *queryBuilder = [DataQueryBuilder new];
    [queryBuilder setWhereClause:@"age > 10"];
    printf("*** PERSON WHERE AGE > 10 COUNT = %s ***\n", [[[personStore getObjectCount:queryBuilder] stringValue] UTF8String]);
    [queryBuilder setWhereClause:@"country = 'US'"];
    printf("*** ADDRESS WHERE COUNTRY = US COUNT = %s ***\n", [[[addressStore getObjectCount:queryBuilder] stringValue] UTF8String]);
}

- (IBAction)getObjectCountQueryAsync:(id)sender {
    DataQueryBuilder *queryBuilder = [DataQueryBuilder new];
    [queryBuilder setWhereClause:@"age > 10"];
    [personStore getObjectCount:[[DataQueryBuilder new] setWhereClause:@"age > 10"]
                       response:^(NSNumber *count) {
                           printf("*** PERSON WHERE AGE > 10 COUNT = %s ***\n", [[count stringValue] UTF8String]);
                       } error:^(Fault *fault) {
                           printf("Fault: %s", [fault.message UTF8String]);
                       }];
    
    [addressStore getObjectCount:[[DataQueryBuilder new] setWhereClause:@"country = 'US'"]
                        response:^(NSNumber *count) {
                            printf("*** ADDRESS WHERE COUNTRY = US = %s ***\n", [[count stringValue] UTF8String]);
                        }
                           error:^(Fault *fault) {
                               printf("Fault: %s", [fault.message UTF8String]);
                           }];

    
    
    //printf("*** PERSON WHERE AGE > 10 COUNT = %s ***\n", [[[personStore getObjectCount:queryBuilder] stringValue] UTF8String]);
    [queryBuilder setWhereClause:@"country = 'US'"];
    //printf("*** ADDRESS WHERE COUNTRY = US COUNT = %s ***\n", [[[addressStore getObjectCount:queryBuilder] stringValue] UTF8String]);
}

@end
