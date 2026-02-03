
// Author: Zac Reeves
// Created: 11-19-25
// Updated: 12-18-25
// Version: 1.1

#import <Foundation/Foundation.h>
#import <readline/readline.h>

@interface Calculator : NSObject
@property (nonatomic, strong) NSNumber *currentTotal;
- (void)sayWelcome;
- (void)showMenu;
- (NSNumber *)returnSum:(NSNumber *)leftNumber addTo:(NSNumber *)rightNumber;
- (NSNumber *)returnDifference:(NSNumber *)leftNumber subtractFrom:(NSNumber *)rightNumber;
- (NSNumber *)returnProduct:(NSNumber *)leftNumber multiplyBy:(NSNumber *)rightNumber;
- (NSNumber *)returnQuotient:(NSNumber *)leftNumber divideBy:(NSNumber *)rightNumber;
- (NSNumber *)returnSquared:(NSNumber *)numberToSquare;
- (NSInteger)grabMenuOption:(NSArray *)operationArray quitWords:(NSArray *)quitWordArray;
- (NSNumber *)grabNSNumberInput;
@end

@implementation Calculator
- (instancetype)init {
    self = [super init];
    if (self) {
        _currentTotal = @(0);
    }
    return self;
}

- (void)sayWelcome {
    printf("Welcome to Calculator\n");
}

- (void)showMenu {
    printf("\n");
    printf("---------------------\n");
    printf("| 1 Addition        |\n");
    printf("| 2 Subtraction     |\n");
    printf("| 3 Multiplication  |\n");
    printf("| 4 Division        |\n");
    printf("| 5 Square          |\n");
    printf("| 0 Quit            |\n");
    printf("---------------------\n");
    if ([self.currentTotal doubleValue] != 0) {
        printf("---------------------\n");
        printf("| Total: %-11.10g |\n", [self.currentTotal doubleValue]);
        printf("---------------------\n");
    }
}

- (NSNumber *)returnSum:(NSNumber *)leftNumber addTo:(NSNumber *)rightNumber {
    double result = [leftNumber doubleValue] + [rightNumber doubleValue];
    self.currentTotal = @(result);
    return @(result);
}

- (NSNumber *)returnDifference:(NSNumber *)leftNumber subtractFrom:(NSNumber *)rightNumber {
    double result = [leftNumber doubleValue] - [rightNumber doubleValue];
    self.currentTotal = @(result);
    return @(result);
}

- (NSNumber *)returnProduct:(NSNumber *)leftNumber multiplyBy:(NSNumber *)rightNumber {
    double result = [leftNumber doubleValue] * [rightNumber doubleValue];
    self.currentTotal = @(result);
    return @(result);
}

- (NSNumber *)returnQuotient:(NSNumber *)leftNumber divideBy:(NSNumber *)rightNumber {
    if ([rightNumber doubleValue] == 0.0) {
        printf("Error: Cannot divide by zero!\n");
        return self.currentTotal;
    }
    double result = [leftNumber doubleValue] / [rightNumber doubleValue];
    self.currentTotal = @(result);
    return @(result);
}

- (NSNumber *)returnSquared:(NSNumber *)numberToSquare {
    double num = [numberToSquare doubleValue];
    double result = num * num;
    self.currentTotal = @(result);
    return @(result);
}

- (NSInteger)grabMenuOption:(NSArray *)operationArray quitWords:(NSArray *)quitWordArray {
    char *input = NULL;
    NSInteger menuChoiceInt = 0;
    BOOL validInput = NO;
    BOOL foundMatch = NO;
    while (!validInput) {
        input = readline("Enter a menu option: ");
        if (input == NULL || input[0] == '\0') {
            printf("You must enter a menu option!\n");
            if (input != NULL) {
                free(input);
            }
            continue;
        }
        
        NSString *inputString = [NSString stringWithUTF8String:input];
        free(input);
        if (![inputString integerValue] || [inputString isEqualToString:@"0"]) {
            foundMatch = NO;
            
            for (NSString *quitWord in quitWordArray) {
                if ([inputString localizedCaseInsensitiveContainsString:quitWord] || [inputString isEqualToString:@"0"]) {
                    menuChoiceInt = 0;
                    validInput = YES;
                    foundMatch = YES;
                    break;
                }
            }
            
            if (!foundMatch) {
                for (NSInteger i = 0; i < operationArray.count && !foundMatch; i++) {
                    NSArray *operation = operationArray[i];
                    for (NSString *item in operation) {
                        if ([inputString localizedCaseInsensitiveContainsString:item]) {
                            menuChoiceInt = i + 1;
                            validInput = YES;
                            foundMatch = YES;
                            break;
                        }
                    }
                }
            }
            
            if (!foundMatch) {
                printf("Invalid input. Please try again.\n");
            }
        } else {
            menuChoiceInt = [inputString integerValue];
            validInput = YES;
        }
    }
    return menuChoiceInt;
}

- (NSNumber *)grabNSNumberInput {
    char *input;
    NSNumber *userNumber;
    BOOL valid = NO;
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];

    while (!valid) {
        input = readline(NULL);
        
        if (input == NULL || input[0] == '\0') {
            printf("You must enter something!\n");
            if (input != NULL) {
                free(input);
            }
            continue;
        }
        
        NSString *inputString = [NSString stringWithUTF8String:input];
        
        // Check if it's a valid number, including 0
        [numberFormatter setFormatterBehavior: NSNumberFormatterBehaviorDefault];
        [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumber *parsed = [numberFormatter numberFromString:inputString];
        if (parsed != nil) {
            userNumber = parsed;
            free(input);
            valid = YES;
            return userNumber;
        } else {
            printf("Invalid number. Please try again.\n");
            printf("Number: ");
            free(input);
        }
    }
    return nil;
}
@end

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // Operation Arrays
        NSArray *additionWordArray = @[@"add", @"addition", @"add dem", @"sum", @"plus", @"+"];
        NSArray *subtractionWordArray = @[@"sub", @"subtract", @"subtraction", @"remove dem", @"difference", @"minus", @"-"];
        NSArray *multiplicationWordArray = @[@"multi", @"multiply", @"multiply dem", @"product", @"*"];
        NSArray *divisionWordArray = @[@"div", @"divide", @"divy up", @"divide dem", @"quotient", @"/"];
        NSArray *quitWordArray = @[@"quit", @"exit", @"close", @"bye", @"q", @"yeet", @"skrrt"];
        NSArray *squareWordArray = @[@"square", @"^", @"sqr", @"sq", @"double up", @"two time"];
        NSArray *operationArray = @[additionWordArray, subtractionWordArray, multiplicationWordArray, divisionWordArray, squareWordArray];
        
        // Declaring vars and creating calc
        BOOL keepRunning = YES;
        NSInteger menuChoiceInt = 0;
        Calculator *calc = [[Calculator alloc] init];
        
        // Start calc
        [calc sayWelcome];
        [calc showMenu];
        printf("\n");
        
        while (keepRunning) {
            menuChoiceInt = [calc grabMenuOption:operationArray quitWords:quitWordArray];
            switch (menuChoiceInt) {
                case 1: {
                    printf("---------------------\n");
                    printf("|      Addition     |\n");
                    printf("---------------------\n");
                    printf("Enter the first number: ");
                    NSNumber *firstAddNumber = [calc grabNSNumberInput];
                    printf("Enter the second number: ");
                    NSNumber *secondAddNumber = [calc grabNSNumberInput];
                    NSNumber *addResult = [calc returnSum:firstAddNumber addTo:secondAddNumber];
                    printf("The sum of %.10g and %.10g is: %.10g\n", [firstAddNumber doubleValue], [secondAddNumber doubleValue], [addResult doubleValue]);
                    [calc showMenu];
                    break;
                }
                case 2: {
                    printf("---------------------\n");
                    printf("|    Subtraction    |\n");
                    printf("---------------------\n");
                    printf("Enter the first number: ");
                    NSNumber *firstSubNumber = [calc grabNSNumberInput];
                    printf("Enter the second number: ");
                    NSNumber *secondSubNumber = [calc grabNSNumberInput];
                    NSNumber *subResult = [calc returnDifference:firstSubNumber subtractFrom:secondSubNumber];
                    printf("The difference between %.10g and %.10g is: %.10g\n", [firstSubNumber doubleValue], [secondSubNumber doubleValue], [subResult doubleValue]);
                    [calc showMenu];
                    break;
                }
                case 3: {
                    printf("---------------------\n");
                    printf("|   Multiplication  |\n");
                    printf("---------------------\n");
                    printf("Enter the first number: ");
                    NSNumber *firstMultNumber = [calc grabNSNumberInput];
                    printf("Enter the second number: ");
                    NSNumber *secondMultNumber = [calc grabNSNumberInput];
                    NSNumber *multResult = [calc returnProduct:firstMultNumber multiplyBy:secondMultNumber];
                    printf("The product of %.10g and %.10g is: %.10g\n", [firstMultNumber doubleValue], [secondMultNumber doubleValue], [multResult doubleValue]);
                    [calc showMenu];
                    break;
                }
                case 4: {
                    printf("---------------------\n");
                    printf("|     Division      |\n");
                    printf("---------------------\n");
                    printf("Enter the first number: ");
                    NSNumber *firstDivNumber = [calc grabNSNumberInput];
                    printf("Enter the second number: ");
                    NSNumber *secondDivNumber = [calc grabNSNumberInput];
                    NSNumber *divResult = [calc returnQuotient:firstDivNumber divideBy:secondDivNumber];
                    printf("The quotient of %.10g and %.10g is: %.10g\n", [firstDivNumber doubleValue], [secondDivNumber doubleValue], [divResult doubleValue]);
                    [calc showMenu];
                    break;
                }
                case 5: {
                    printf("---------------------\n");
                    printf("|      Square       |\n");
                    printf("---------------------\n");
                    printf("Enter the number: ");
                    NSNumber *numberToSquare = [calc grabNSNumberInput];
                    NSNumber *squareResult = [calc returnSquared:numberToSquare];
                    printf("%.10g squared is: %.10g\n", [numberToSquare doubleValue], [squareResult doubleValue]);
                    [calc showMenu];
                    break;
                }
                    
                case 0:
                    printf("Thanks for using Calculator!\n");
                    keepRunning = NO;
                    break;
                    
                default:
                    printf("Invalid option\n");
                    break;
            }
        }
    }
    return EXIT_SUCCESS;
}

