
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
    [personStore enableOffline];
    [personStore on:@"sync"
           response:^(BOOL syncComplete) {
               if (syncComplete) {
                   printf("Table 'Person' sync compete\n");
               }
               else {
                   printf("Table 'Person' sync failed\n");
               }
           } error:^(Fault *fault) {
               printf("%s\n", [fault.message UTF8String]);
           }];
    
    addressStore = [backendless.data ofTable:@"Address"];
    [addressStore enableOffline];
    [addressStore on:@"sync"
            response:^(BOOL syncComplete) {
                if (syncComplete) {
                    printf("Table 'Address' sync compete\n");
                }
                else {
                    printf("Table 'Address' sync failed\n");
                }

            } error:^(Fault *fault) {
                printf("%s\n", [fault.message UTF8String]);
            }];    
}

- (IBAction)findByIdSync:(id)sender {
    NSString *personId = @"ED75F3E8-7FDC-9CB5-FF3B-F3B8731B2B00";
    printf("*** PERSON WITH ID = %s ***\n", [personId UTF8String]);
    Person *person = [personStore findById:personId];
    printf("%s: %i\n", [person.name UTF8String], person.age);
    
    NSString *addressId = @"3676FFE0-E2E6-F31D-FF32-A09022F17800";
    printf("*** ADDRESS WITH ID = %s ***\n", [addressId UTF8String]);
    NSDictionary *address = [addressStore findById:addressId];
    NSString *city = [address valueForKey:@"city"];
    NSString *country = [address valueForKey:@"country"];
    printf("%s: %s\n", [city UTF8String], [country UTF8String]);
}

- (IBAction)findByIdAsync:(id)sender {
    NSString *personId = @"ED75F3E8-7FDC-9CB5-FF3B-F3B8731B2B00";
    [personStore findById:personId
                 response:^(Person *person) {
                     printf("*** PERSON WITH ID = %s ***\n", [personId UTF8String]);
                     printf("%s: %i\n", [person.name UTF8String], person.age);
                 }
                    error:^(Fault *fault) {
                        printf("Fault: %s\n", [fault.message UTF8String]);
                    }];
    
    NSString *addressId = @"3676FFE0-E2E6-F31D-FF32-A09022F17800";
    [addressStore findById:addressId
                  response:^(NSDictionary *address) {
                      printf("*** ADDRESS WITH ID = %s ***\n", [addressId UTF8String]);
                      NSString *city = [address valueForKey:@"city"];
                      NSString *country = [address valueForKey:@"country"];
                      printf("%s: %s\n", [city UTF8String], [country UTF8String]);
                  }
                     error:^(Fault *fault) {
                         printf("Fault: %s\n", [fault.message UTF8String]);
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
        printf("Fault: %s\n", [fault.message UTF8String]);
    }];
    
    [addressStore getObjectCount:^(NSNumber *count) {
        printf("*** ADDRESS COUNT = %s ***\n", [[count stringValue] UTF8String]);
    } error:^(Fault *fault) {
        printf("Fault: %s\n", [fault.message UTF8String]);
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
                           printf("Fault: %s\n", [fault.message UTF8String]);
                       }];
    
    [addressStore getObjectCount:[[DataQueryBuilder new] setWhereClause:@"country = 'US'"]
                        response:^(NSNumber *count) {
                            printf("*** ADDRESS WHERE COUNTRY = US = %s ***\n", [[count stringValue] UTF8String]);
                        }
                           error:^(Fault *fault) {
                               printf("Fault: %s\n", [fault.message UTF8String]);
                           }];
}

- (IBAction)findFirstSync:(id)sender {
    Person *firstPerson = [personStore findFirst];
    printf("FIRST PERSON IS %s: %i\n", [firstPerson.name UTF8String], firstPerson.age);
    
    NSDictionary *firstAddress = [addressStore findFirst];
    NSString *city = [firstAddress valueForKey:@"city"];
    NSString *country = [firstAddress valueForKey:@"country"];
    printf("FIRST ADDRESS IS %s: %s\n", [city UTF8String], [country UTF8String]);
}

- (IBAction)findLastSync:(id)sender {
    Person *lastPerson = [personStore findLast];
    printf("LAST PERSON IS %s: %i\n", [lastPerson.name UTF8String], lastPerson.age);
    
    NSDictionary *lastAddress = [addressStore findLast];
    NSString *city = [lastAddress valueForKey:@"city"];
    NSString *country = [lastAddress valueForKey:@"country"];
    printf("LAST ADDRESS IS %s: %s\n", [city UTF8String], [country UTF8String]);
}

- (IBAction)findFirstAsync:(id)sender {
    [personStore findFirst:^(Person *firstPerson) {
        printf("FIRST PERSON IS %s: %i\n", [firstPerson.name UTF8String], firstPerson.age);
    } error:^(Fault *fault) {
        printf("Fault: %s\n", [fault.message UTF8String]);
    }];
    
    [addressStore findFirst:^(NSDictionary *firstAddress) {
        NSString *city = [firstAddress valueForKey:@"city"];
        NSString *country = [firstAddress valueForKey:@"country"];
        printf("FIRST ADDRESS IS %s: %s\n", [city UTF8String], [country UTF8String]);
    } error:^(Fault *fault) {
        printf("Fault: %s\n", [fault.message UTF8String]);
    }];
}

- (IBAction)findLastAsync:(id)sender {
    [personStore findLast:^(Person *lastPerson) {
        printf("LAST PERSON IS %s: %i\n", [lastPerson.name UTF8String], lastPerson.age);
    } error:^(Fault *fault) {
        printf("Fault: %s\n", [fault.message UTF8String]);
    }];
    
    [addressStore findLast:^(NSDictionary *lastAddress) {
        NSString *city = [lastAddress valueForKey:@"city"];
        NSString *country = [lastAddress valueForKey:@"country"];
        printf("LAST ADDRESS IS %s: %s\n", [city UTF8String], [country UTF8String]);
    } error:^(Fault *fault) {
        printf("Fault: %s\n", [fault.message UTF8String]);
    }];
}

@end
