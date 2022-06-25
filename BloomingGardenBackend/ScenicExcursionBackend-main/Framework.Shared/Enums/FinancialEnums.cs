using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Framework.Shared.Enums
{
    public enum FSTemplateFieldTypesEnum : int
    {
        Field = 1,
        Formula = 2,
        Heading = 3,
        Separator = 4,
        StatementSeparator = 5,
    }

    public enum FSFieldDisplayAreasEnum : int
    {
        FS = 1,
        FP = 2,
        HO=3,
        CO=4,
        EA=5
     }

    public enum FiscalPeriodEnum : int
    { 
        YEAR = 1,
        Q1 = 	2,
        Q2  =	3,
        Q3  =	4,
        Q4  =	5,
        w1   =	6,
        w2   =	7,
        w3   =	8,
        w4   =	9,
        w5   =	10,
        w6   =	11,
        w7   =	12,
        w8   =	13,
        w9   =	14,
        w10  =	15,
        w11  =	16,
        w12  =	17,
        w13  =	18,
        w14  =	19,
        w15  =	20,
        w16  =	21,
        w17  =	22,
        w18  =	23,
        w19  =	24,
        w20  =	25,
        w21  =	26,
        w22  =	27,
        w23  =	28,
        w24  =	29,
        w25  =	30,
        w26  =	31,
        w27  =	32,
        w28  =	33,
        w29  =	34,
        w30 = 	35,
        w31  =	36,
        w32  =	37,
        w33  =	38,
        w34  =	39,
        w35  =	40,
        w36  =	41,
        w37  =	42,
        w38  =	43,
        w39  =	44,
        w40  =	45,
        w41  =	46,
        w42  =	47,
        w43  =	48,
        w44  =	49,
        w45  =	50,
        w46  =	51,
        w47  =	52,
        w48  =	53,
        w49  =	54,
        w50  =	55,
        w51 = 	56,
        w52  =	57,
        m1   =	58,
        m2   =	59,
        m3   =	60,
        m4   =	61,
        m5   =	62,
        m6   =	63,
        m7   =	64,
        m8   =	65,
        m9   =	66,
        m10  =	67,
        m11=	68,
        m12=	69,
        I1=	70,
        I2=	71,
        I3=	72,
        I4=	73,
    }

    public enum FiscalPeriodTypesEnum : int
    {
        Week = 1,
        Month = 2,
        Quarter = 3,
        Year = 4,
        Interim = 5
    }

    public enum FSFieldsEnum : short
    {
        Dividends = 94,
        ISNetIncome = 54,
        TotalOperatingIncome = 40
    }
    public enum FinancialReportTemplateEnum :short
    {
        SectorResult = 1,
        CompanyResult = 2,
        MarketAggregatedIncomes = 3,
        CementMonthlyReportIncomes = 4
    }
}
