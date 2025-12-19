
// Author: Zac Reeves
// Created: 11-19-25
// Updated: 12-18-25
// Version: 1.0

#import <Foundation/Foundation.h>
#import <readline/readline.h>

@interface Calculator : NSObject
@property double currentTotal;
- (void)sayWelcome;
- (void)showMenu;
- (double)returnSum:(double)leftNumber addTo:(double)rightNumber;
- (double)returnDifference:(double)leftNumber subtractFrom:(double)rightNumber;
- (double)returnProduct:(double)leftNumber multiplyBy:(double)rightNumber;
- (double)returnQuotient:(double)leftNumber divideBy:(double)rightNumber;
- (double)returnSquared:(double)numberToSquare;
- (NSInteger)grabMenuOption:(NSArray *)operationArray quitWords:(NSArray *)quitWordArray;
- (double)grabDoubleInput;
@end

@implementation Calculator
- (instancetype)init {
    self = [super init];
    if (self) {
        _currentTotal = 0.0;
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
    printf("| 0 Quit            |\n");
    printf("---------------------\n");
    if (self.currentTotal != 0) {
        printf("---------------------\n");
        printf("| Total: %-11.10g |\n", self.currentTotal);
        printf("---------------------\n");
    }
}

- (double)returnSum:(double)leftNumber addTo:(double)rightNumber {
    double result = leftNumber + rightNumber;
    self.currentTotal = result;
    return result;
}

- (double)returnDifference:(double)leftNumber subtractFrom:(double)rightNumber {
    double result = leftNumber - rightNumber;
    self.currentTotal = result;
    return result;
}

- (double)returnProduct:(double)leftNumber multiplyBy:(double)rightNumber {
    double result = leftNumber * rightNumber;
    self.currentTotal = result;
    return result;
}

- (double)returnQuotient:(double)leftNumber divideBy:(double)rightNumber {
    if (rightNumber == 0.0) {
        printf("Error: Cannot divide by zero!\n");
        self.currentTotal = 0;
        return self.currentTotal;
    }
    double result = leftNumber / rightNumber;
    self.currentTotal = result;
    return result;
}

- (double)returnSquared:(double)numberToSquare {
    double result = numberToSquare * numberToSquare;
    self.currentTotal = result;
    return result;
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

- (double)grabDoubleInput {
    char *input;
    double userNumber;
    BOOL valid = NO;
    
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
        if ([inputString doubleValue] != 0.0 || [inputString isEqualToString:@"0"] || [inputString isEqualToString:@"0.0"]) {
            userNumber = [inputString doubleValue];
            free(input);
            valid = YES;
            return userNumber;
        } else {
            printf("Invalid number. Please try again.\n");
            printf("Number: ");
            free(input);
        }
    }
    return 0;
}
@end

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // Operation Arrays
        NSArray *additionWordArray = @[@"add", @"addition", @"add dem", @"sum", @"plus", @"+"];
        NSArray *subtractionWordArray = @[@"sub", @"subtract", @"subtraction", @"remove dem", @"difference", @"minus", @"-"];
        NSArray *multiplicationWordArray = @[@"multi", @"multiply", @"double up", @"multiply dem", @"product", @"*"];
        NSArray *divisionWordArray = @[@"div", @"divide", @"divy up", @"divide dem", @"quotient", @"/"];
        NSArray *quitWordArray = @[@"quit", @"exit", @"close", @"bye", @"q", @"yeet", @"skrrt"];
        NSArray *operationArray = @[additionWordArray, subtractionWordArray, multiplicationWordArray, divisionWordArray];
        
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
                case 1:
                    printf("---------------------\n");
                    printf("|      Addition     |\n");
                    printf("---------------------\n");
                    
                    printf("Enter the first number: ");
                    double firstAddNumber = [calc grabDoubleInput];
                    printf("Enter the second number: ");
                    double secondAddNumber = [calc grabDoubleInput];
                    double addResult = [calc returnSum:firstAddNumber addTo:secondAddNumber];
                    printf("The sum of %.10g and %.10g is: %.10g\n", firstAddNumber, secondAddNumber, addResult);
                    [calc showMenu];
                    break;
                    
                case 2:
                    printf("---------------------\n");
                    printf("|    Subtraction    |\n");
                    printf("---------------------\n");
                    printf("Enter the first number: ");
                    double firstSubNumber = [calc grabDoubleInput];
                    printf("Enter the second number: ");
                    double secondSubNumber = [calc grabDoubleInput];
                    double subResult = [calc returnDifference:firstSubNumber subtractFrom:secondSubNumber];
                    printf("The difference between %.10g and %.10g is: %.10g\n", firstSubNumber, secondSubNumber, subResult);
                    [calc showMenu];
                    break;
                    
                case 3: 
                    printf("---------------------\n");
                    printf("|   Multiplication  |\n");
                    printf("---------------------\n");
                    printf("Enter the first number: ");
                    double firstMultNumber = [calc grabDoubleInput];
                    printf("Enter the second number: ");
                    double secondMultNumber = [calc grabDoubleInput];
                    double multResult = [calc returnProduct:firstMultNumber multiplyBy:secondMultNumber];
                    printf("The product of %.10g and %.10g is: %.10g\n", firstMultNumber, secondMultNumber, multResult);
                    [calc showMenu];
                    break;

                case 4:
                    printf("---------------------\n");
                    printf("|     Division      |\n");
                    printf("---------------------\n");
                    printf("Enter the first number: ");
                    double firstDivNumber = [calc grabDoubleInput];
                    printf("Enter the second number: ");
                    double secondDivNumber = [calc grabDoubleInput];
                    double divResult = [calc returnQuotient:firstDivNumber divideBy:secondDivNumber];
                    printf("The quotient of %.10g and %.10g is: %.10g\n", firstDivNumber, secondDivNumber, divResult);
                    [calc showMenu];
                    break;
                    
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
