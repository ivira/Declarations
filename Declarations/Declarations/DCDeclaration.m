//
//  DCDeclaration.m
//  Declarations
//
//  Created by Vera Tkachenko on 5/20/14.
//  Copyright (c) 2014 Chesno. All rights reserved.
//

#import "DCDeclaration.h"
#import "DCVehiclesInfo.h"
#import "DCProfitInfo.h"
#import "DCDepositsInfo.h"
#import "DCFinancialLiabilities.h"
#import "DCRealtyInfo.h"
#import "DCValue.h"

@interface DCDeclaration ()

@property (strong, readonly) NSDictionary *table;

@end

static NSString *const MHDeclarationYearKey = @"year";
static NSString *const MHDeclarationURLKey = @"url";
static NSString *const MHDeclarationIDKey = @"id";
static NSString *const MHDeclarationCommentKey = @"comment";
static NSString *const MHDeclarationFieldsKey = @"fields";

static NSString *const MHDeclarationsItemsKey = @"items";
static NSString *const MHDeclarationsValueKey = @"value";
static NSString *const MHDeclarationsUnitsKey = @"units";
static NSString *const DCDeclarationsTitleKey = @"title";

@implementation DCDeclaration

@synthesize profit = _profit;

- (id)init
{
    self = [super init];
    
    if (self != nil)
    {
        self.categories = @[ self.vehicles, self.profit, self.deposit, self.realty, self.financialLiabilities ];
    }
    
    return self;
}

- (id)initWithJSONObject:(NSDictionary *)jsonObject
{
    self = [self init];
    
    if (self != nil)
    {
        _table = @{ @"profit" : @{ @"from" : @( 6 ), @"to" : @( 21 ) } };
//        _table = @{ @"5.0" : @"profit.totalProfit_5",
//                    @"6.0" : @"profit.laborSalary_6",
//                    @"7.0" : @"profit.teachingSalary_7",
//                    @"8.0" : @"profit.royalties_8",
//                    @"9.0" : @"profit.interest_9",
//                    @"10.0" : @"profit.financialAid_10",
//                    @"11.0" : @"profit.awards_11",
//                    @"12.0" : @"profit.dole_12",
//                    @"13.0" : @"profit.alimony_13",
//                    @"14.0" : @"profit.heritage_14",
//                    @"15.0" : @"profit.insuranceBenefits_15",
//                    @"16.0" : @"profit.alienationPropertyIncome_16",
//                    @"17.0" : @"profit.businessIncome_17",
//                    @"18.0" : @"profit.securitiesDisposalIncome_18",
//                    @"19.0" : @"profit.leaseIncome_19",
//                    @"20.0" : @"profit.otherIncome_20",
//                    @"21.0" : @"profit.foreignIncome_21",
//                    };
         self.categories = @[ self.vehicles, self.profit, self.deposit, self.realty, self.financialLiabilities ];
        
        [self setupWithJSON:jsonObject];
    }
    
    return self;
}

- (void)setupWithJSON:(NSDictionary *)jsonObject
{
    _year = [[jsonObject objectForKey:MHDeclarationYearKey] integerValue];
    
    NSString *url = [jsonObject objectForKey:MHDeclarationURLKey];
    if (url != nil)
    {
        _originalURL = [NSURL URLWithString:url];
    }
    
    NSDictionary *model = [jsonObject objectForKey:MHDeclarationFieldsKey];
    
    NSLog(@"model = %@", model);
    
    [model enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        //NSDictionary *keyPathDict = [self.table objectForKey:key];
        if ([obj isKindOfClass:[NSDictionary class]] && [obj allKeys].count)
        {
            NSArray *items = [obj objectForKey:MHDeclarationsItemsKey];

            NSString *units = [obj objectForKey:MHDeclarationsUnitsKey];
            NSString *title = [obj objectForKey:DCDeclarationsTitleKey];
            
            for (id currentItem in items)
            {
                id value = [currentItem objectForKey:MHDeclarationsValueKey];
                
                DCValue *newValue = [[DCValue alloc] initWithCode:key
                                                            value:value
                                                            title:title
                                                            units:units];
                
                __block NSString *foundCategory = nil;
                [self.table enumerateKeysAndObjectsUsingBlock:^(NSString *category, NSDictionary *range, BOOL *stop) {
                    if ([key floatValue] >= [range[@"from"] floatValue] && [key floatValue] <= [range[@"to"] floatValue])
                    {
                        foundCategory = category;
                        *stop = YES;
                    }
                }];
                
                if (foundCategory != nil)
                {
                    DCCategory *category = [self valueForKey:foundCategory];
                    [category addValue:newValue];
                }
                
                //[category setValue:newValue forKey:keyPathDict[@"key"]];
            }
        }
    }];
}

- (NSString *)title
{
    if (_title == nil)
    {
        _title = [NSString stringWithFormat:@"%lu", (unsigned long)self.year];

    }
    return _title;
}

#pragma mark - Categories

- (DCVehiclesInfo *)vehicles
{
    if (!_vehicles)
    {
        _vehicles = [DCVehiclesInfo new];
        _vehicles.name = @"Авто";
    }
    return _vehicles;
}

- (DCProfitInfo *)profit
{
    if (!_profit)
    {
        _profit = [DCProfitInfo new];
        _profit.name = @"Дохід";
    }
    return _profit;
}

- (DCDepositsInfo *)deposit
{
    if (!_deposit)
    {
        _deposit = [DCDepositsInfo new];
        _deposit.name = @"Депозити";
    }
    return _deposit;
}

- (DCRealtyInfo *)realty
{
    if (!_realty)
    {
        _realty = [DCRealtyInfo new];
        _realty.name = @"Нерухомість";
    }
    return _realty;
}

- (DCFinancialLiabilities *)financialLiabilities
{
    if (!_financialLiabilities)
    {
        _financialLiabilities = [DCFinancialLiabilities new];
        _financialLiabilities.name = @"Фінансові забов'язання";
    }
    return _financialLiabilities;
}

@end
