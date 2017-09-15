
#import "ViewController.h"
#import "Backendless.h"
#import "Person.h"

#define APPLICATION_ID @"0D07720F-390F-B9A2-FF00-94FA651A3600"
#define API_KEY @"A466FD8B-4F1B-54E8-FF83-81209FF28700"
#define SERVER_URL @"http://api.backendless.com"

@interface ViewController() {
    NSArray<Person *> *personArray;
    NSArray<NSDictionary *> *addressArray;
    id<IDataStore>personStore;
    id<IDataStore>addressStore;
}
@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [backendless setHostUrl:SERVER_URL];
    [backendless initApp:APPLICATION_ID APIKey:API_KEY];
    
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

// ***** SYNC *****

- (IBAction)findSync:(id)sender {
    printf("*** PERSON ***\n");
    personArray = [personStore find];
    for (Person *person in personArray) {
        printf("%s: %i\n", [person.name UTF8String], person.age);
        NSLog(@"p created: %@", ((BackendlessEntity *)person).created);
    }

    
    printf("*** ADDRESS ***\n");
    addressArray = [addressStore find];
    for (NSDictionary *address in addressArray) {
        NSString *city = [address valueForKey:@"city"];
        NSString *country = [address valueForKey:@"country"];
        printf("%s: %s\n", [city UTF8String], [country UTF8String]);
    }
}

- (IBAction)findQuerySync:(id)sender {
    printf("*** PERSON WHERE AGE > 10 ***\n");
    DataQueryBuilder *queryBuilder = [DataQueryBuilder new];
    [queryBuilder setWhereClause:@"age > 10"];
    personArray = [personStore find:queryBuilder];
    for (Person *person in personArray) {
        printf("%s: %i\n", [person.name UTF8String], person.age);
    }
    
    printf("*** ADDRESS WHERE country = US ***\n");
    [queryBuilder setWhereClause:@"country = 'US'"];
    addressArray = [addressStore find:queryBuilder];
    for (NSDictionary *address in addressArray) {
        NSString *city = [address valueForKey:@"city"];
        NSString *country = [address valueForKey:@"country"];
        printf("%s: %s\n", [city UTF8String], [country UTF8String]);
    }
}

- (IBAction)addNewPersonSync:(id)sender {
    Person *newPerson = [Person new];
    newPerson.name = @"Bob";
    newPerson.age = 33;
    [personStore save:newPerson];
    printf("New person saved\n");
}

- (IBAction)addNewAddressSync:(id)sender {
    NSDictionary *newAddress = @{@"city":@"London", @"country":@"UK"};
    [addressStore save:newAddress];
    printf("New address saved\n");
}

- (IBAction)updateFirstPersonSync:(id)sender {
    personArray = [personStore find];
    if ([personArray count] > 0) {
        Person *first = [personArray firstObject];
        if ([first.name isEqualToString:@"Bob"]) {
            first.name = @"Ashley";
        }
        else {
            first.name = @"Bob";
        }
        [personStore save:first];
        printf("First person updated\n");
    }
    else {
        printf("No person can be updated\n");
    }
}

- (IBAction)updateFirstAddressSync:(id)sender {
    addressArray = [addressStore find];
    if ([addressArray count] > 0) {
        NSDictionary *first = [addressArray firstObject];
        if ([[first valueForKey:@"country"] isEqualToString:@"UK"]) {
            [first setValue:@"United Kingdom" forKey:@"country"];
        }
        else if ([[first valueForKey:@"country"] isEqualToString:@"United Kingdom"]) {
            [first setValue:@"UK" forKey:@"country"];
        }
        else if ([[first valueForKey:@"country"] isEqualToString:@"US"]) {
            [first setValue:@"United States" forKey:@"country"];
        }
        else if ([[first valueForKey:@"country"] isEqualToString:@"United States"]) {
            [first setValue:@"US" forKey:@"country"];
        }
        [addressStore save:first];
        printf("First address updated\n");
    }
    else {
        printf("No address can be updated\n");
    }
}

- (IBAction)removePersonSync:(id)sender {
    personArray = [personStore find];
    if ([personArray count] > 0) {
        Person *first = [personArray firstObject];
        [personStore remove:first];
        printf("First person removed\n");
    }
    else {
        printf("No person can be removed\n");
    }
}

- (IBAction)removeAddressSync:(id)sender {
    addressArray = [addressStore find];
    if ([addressArray count] > 0) {
        NSDictionary *first = [addressArray firstObject];
        [addressStore remove: first];
        printf("First address removed\n");
    }
    else {
        printf("No address can be removed\n");
    }
}

- (IBAction)removePersonByIdSync:(id)sender {
    personArray = [personStore find];
    if ([personArray count] > 0) {
        Person *first = [personArray firstObject];
        NSString *objectId = ((BackendlessEntity *)first).objectId;
        [personStore removeById:objectId];
        printf("Person removed: %s\n", [objectId UTF8String]);
    }
    else {
        printf("No person can be removed\n");
    }
}

- (IBAction)removeAddressByIdSync:(id)sender {
    addressArray = [addressStore find];
    if ([addressArray count] > 0) {
        NSDictionary *first = [addressArray firstObject];
        NSString *objectId = [first valueForKey:@"objectId"];
        [addressStore removeById:objectId];
        printf("Address removed: %s\n", [objectId UTF8String]);
    }
    else {
        printf("No address can be removed\n");
    }
}

// ***** ASYNC *****

- (IBAction)findAsync:(id)sender {
    [personStore find:^(NSArray<Person *> *retrievedPersonArray) {
        printf("*** PERSON ***\n");
        personArray = retrievedPersonArray;
        for (Person *person in personArray) {
            printf("%s: %i\n", [person.name UTF8String], person.age);
        }
    } error:^(Fault *fault) {
        printf("Fault: %s\n", [fault.message UTF8String]);
    }];
    
    [addressStore find:^(NSArray<NSDictionary *> *retrievedAddressArray) {
        printf("*** ADDRESS ***\n");
        addressArray = retrievedAddressArray;
        for (NSDictionary *address in addressArray) {
            NSString *city = [address valueForKey:@"city"];
            NSString *country = [address valueForKey:@"country"];
            printf("%s: %s\n", [city UTF8String], [country UTF8String]);
        }
    } error:^(Fault *fault) {
        printf("Fault: %s\n ", [fault.message UTF8String]);
    }];
}

- (IBAction)findQueryAsync:(id)sender {
    DataQueryBuilder *queryBuilder = [DataQueryBuilder new];
    [queryBuilder setWhereClause:@"age > 10"];
    [personStore find:queryBuilder
             response:^(NSArray<Person *> *retrievedPersonArray) {
                 printf("*** PERSON WHERE AGE > 10 ***\n");
                 personArray = retrievedPersonArray;
                 for (Person *person in personArray) {
                     printf("%s: %i\n", [person.name UTF8String], person.age);
                 }
             } error:^(Fault *fault) {
                 printf("Fault: %s", [fault.message UTF8String]);
             }];
    
    [queryBuilder setWhereClause:@"country = 'US'"];
    [addressStore find:queryBuilder
              response:^(NSArray<NSDictionary *> *retrievedAddressArray) {
                  printf("*** ADDRESS WHERE country = US ***\n");
                  addressArray = retrievedAddressArray;
                  for (NSDictionary *address in addressArray) {
                      NSString *city = [address valueForKey:@"city"];
                      NSString *country = [address valueForKey:@"country"];
                      printf("%s: %s\n", [city UTF8String], [country UTF8String]);
                  }
              } error:^(Fault *fault) {
                  printf("Fault: %s", [fault.message UTF8String]);
              }];
}

- (IBAction)addNewPersonAsync:(id)sender {
    Person *newPerson = [Person new];
    newPerson.name = @"Bob";
    newPerson.age = 33;
    [personStore save:newPerson
             response:^(Person *savedPerson) {
                 printf("New person saved\n");
             }
                error:^(Fault *fault) {
                    printf("Fault: %s", [fault.message UTF8String]);
                }];
}

- (IBAction)addNewAddressAsync:(id)sender {
    NSDictionary *newAddress = @{@"city":@"London", @"country":@"UK"};
    [addressStore save:newAddress
              response:^(NSDictionary *savedAddress) {
                  printf("New address saved\n");
              }
                 error:^(Fault *fault) {
                     printf("Fault: %s", [fault.message UTF8String]);
                 }];
}

- (IBAction)updateFirstPersonAsync:(id)sender {
    personArray = [personStore find];
    if ([personArray count] > 0) {
        Person *first = [personArray firstObject];
        if ([first.name isEqualToString:@"Bob"]) {
            first.name = @"Ashley";
        }
        else {
            first.name = @"Bob";
        }
        [personStore save:first
                 response:^(Person *updatedPerson) {
                     printf("First person updated\n");
                 }
                    error:^(Fault *fault) {
                        printf("Fault: %s", [fault.message UTF8String]);
                    }];
    }
    else {
        printf("No person can be updated\n");
    }
}

- (IBAction)updateFirstAddressAsync:(id)sender {
    addressArray = [addressStore find];
    if ([addressArray count] > 0) {
        NSDictionary *first = [addressArray firstObject];
        if ([[first valueForKey:@"country"] isEqualToString:@"UK"]) {
            [first setValue:@"United Kingdom" forKey:@"country"];
        }
        else if ([[first valueForKey:@"country"] isEqualToString:@"United Kingdom"]) {
            [first setValue:@"UK" forKey:@"country"];
        }
        else if ([[first valueForKey:@"country"] isEqualToString:@"US"]) {
            [first setValue:@"United States" forKey:@"country"];
        }
        else if ([[first valueForKey:@"country"] isEqualToString:@"United States"]) {
            [first setValue:@"US" forKey:@"country"];
        }
        [addressStore save:first
                  response:^(NSDictionary *updatedAddress) {
                      printf("First address updated\n");
                  }
                     error:^(Fault *fault) {
                         printf("Fault: %s", [fault.message UTF8String]);
                     }];
    }
    else {
        printf("No address can be updated\n");
    }
}

- (IBAction)removePersonAsync:(id)sender {
    personArray = [personStore find];
    if ([personArray count] > 0) {
        Person *first = [personArray firstObject];
        [personStore remove:first
                   response:^(NSNumber *result) {
                       printf("First person removed\n");
                   }
                      error:^(Fault *fault) {
                          printf("Fault: %s", [fault.message UTF8String]);
                      }];
    }
    else {
        printf("No person can be removed\n");
    }
}

- (IBAction)removeAddressAsync:(id)sender {
    addressArray = [addressStore find];
    if ([addressArray count] > 0) {
        NSDictionary *first = [addressArray firstObject];
        [addressStore remove:first
                    response:^(NSNumber *result) {
                        printf("First address removed\n");
                    }
                       error:^(Fault *fault) {
                           printf("Fault: %s", [fault.message UTF8String]);
                       }];
    }
    else {
        printf("No address can be removed\n");
    }
}

- (IBAction)removePersonByIdAsync:(id)sender {
    personArray = [personStore find];
    if ([personArray count] > 0) {
        Person *first = [personArray firstObject];
        NSString *objectId = ((BackendlessEntity *)first).objectId;
        [personStore removeById:objectId
                       response:^(NSNumber *result) {
                           printf("Person removed: %s\n", [objectId UTF8String]);
                       }
                          error:^(Fault *fault) {
                              printf("Fault: %s", [fault.message UTF8String]);
                          }];
    }
    else {
        printf("No person can be removed\n");
    }
}

- (IBAction)removeAddressByIdAsync:(id)sender {
    addressArray = [addressStore find];
    if ([addressArray count] > 0) {
        NSDictionary *first = [addressArray firstObject];
        NSString *objectId = [first valueForKey:@"objectId"];
        [addressStore removeById:objectId
                        response:^(NSNumber *result) {
                            printf("Address removed: %s\n", [objectId UTF8String]);
                        }
                           error:^(Fault *fault) {
                               printf("Fault: %s", [fault.message UTF8String]);
                           }];
    }
    else {
        printf("No address can be removed\n");
    }
}

@end

