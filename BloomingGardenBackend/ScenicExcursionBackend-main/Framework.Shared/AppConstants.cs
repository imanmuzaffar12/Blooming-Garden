using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Basketo.Shared
{
    public class AppConstants
    {
        public const short BANKDEPOSITS_REPORT_ID = 5;
        public const short CONSOLIDATEDBALANCESHEET_REPORT_ID = 9;
        public const short COMMERCIALBANKSMONTHLYPROFIT_REPORT_ID = 10;
        public const short CONSUMERANDCREDITCARDLOANS_REPORT_ID = 11;
        public const short BRANCHESOFBANKS_REPORT_ID = 12;
        public const short ATMSSTATISTICS_REPORT_ID = 13;
        public const short POSSTATISTICS_REPORT_ID = 14;
        public const short INTERESTRATESONSARDEPOSITS_REPORT_ID = 15;
        public const short ATMS_REPORT_ID = 16;
        public const short POSDISTRIBUTIONBYBANKS_REPORT_ID = 17;

        public const short CONSOLIDATEDBALANCESHEET_SECTORS_REPORT_ID = 28;
        public const short BANKDEPOSITS_SECTORS_REPORT_ID = 29;
        public const short PERSONALLOANS_SECTORS_REPORT_ID = 30;
        public const short BRANCHESOFBANKS_SECTORS_REPORT_ID = 31;
        public const short ATMSSTATISTICS_SECTORS_REPORT_ID = 32;
        public const short POSSTATISTICS_SECTORS_REPORT_ID = 33;
        public const short INTERESTRATESONSARDEPOSITS_SECTORS_REPORT_ID = 34;

        public const string EXPRESSION_TOKENIZATION_REGEX = @"(\[\w+\])|(\+|\/|\-|\*|\(|\))";

    }
}
