using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Framework.Shared.Enums
{
    public enum ArticleTypesEnum
    {
        News = 1,
        Research = 8,
        Recommendation = 3,
        Telescope = 29,
        MigratedFromArgaam = 30,
        FinancialResults = 10,
        Dividend = 31,
        KeyDevelopment = 32,
    }
    public enum ArticleStatusesEnum
    {
        InDraft = 1,
        RequiresApproval,
        Rejected,
        Approved,
        Published=5,
        Inactive,
        Deleted,
       
    }
    public enum ArticleRelatedInfoEnum
    { 
        Market = 1,
        InternationalMarket = 2,
        EnergyPrice = 3,
        Company = 4,
        Commodity = 5,
        ArgaamSectors = 6
    }
    public enum Action
    {
        Add = 1,
        Update = 2,
        Delete = 3,
    
    }
}
