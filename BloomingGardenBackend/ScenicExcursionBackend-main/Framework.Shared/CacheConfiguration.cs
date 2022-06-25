﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Basketo.Shared
{
    public class CacheKeys
    {
        //Note: Consider Language while creating CACHE Keys         
        public const string CK_LANGUAGE = "CK_LANGUAGE";
        public const string CK_RESOURCE_LOCALIZATIONS = "CK_RESOURCE_LOCALIZATIONS";
        
        
        public const string CK_MARKETPULSE_SEARCH_PH0_PH1 = "CK_MARKETPULSE_SEARCH_{0}_{1}";
        public const string CK_MARKETS = "CK_MARKETS";
        public const string CK_MARKETS_PH01 = "CK_MARKETS_{0}";

        //Shareholder Types
        public const string CK_SHAREHOLDERTYPES_ = "CK_SHAREHOLDERTYPES_";
        #region Shareholders

        public const string CK_SHAREHOLDERS_DATA_PAGED_PH0_HP1_HP2 = "CK_SHAREHOLDERS_DATA_PAGED_{0}_{1}_{2}";
        public const string CK_SHAREHOLDERS_DATA_FOR_COMPANY_PH0_HP1 = "CK_SHAREHOLDERS_DATA_FOR_COMPANY_{0}_{1}";
        public const string CK_SHAREHOLDERS_INVESTED_IN_COMPANIES_PH0 = "CK_SHAREHOLDERS_INVESTED_IN_COMPANIES_{0}";
        public const string CK_SHAREHOLDERS_GET_PH0_HP1 = "CK_SHAREHOLDERS_GET_{0}_{1}";
        public const string CK_SHAREHOLDERS_SEARCH_PH0_HP1_PH2 = "CK_SHAREHOLDERS_SEARCH_{0}_{1}_{2}";
        public const string CK_NEWANNOUNCEMENT_SEARCH_PG0_PS1_TEXT2_LI3 = "CK_NEWANNOUNCEMENT_SEARCH_{0}_{1}_{2}_{3}";
        
        public const string CK_SHAREHOLDERS_GET_TOP_BUYER_IN_DAYS_RANGE_PH0_HP1 = " CK_SHAREHOLDERS_GET_TOP_BUYER_IN_DAYS_RANGE_{0}_{1}";
        public const string CK_SHAREHOLDERS_GET_TOP_SELLER_IN_DAYS_RANGE_PH0_HP1 = "CK_SHAREHOLDERS_GET_TOP_SELLER_IN_DAYS_RANGE_{0}_{1}";
        public const string CK_SHAREHOLDERS_GET_DISAPPEARED__PH0_HP1 = "CK_SHAREHOLDERS_GET_DISAPPEARED__{0}_{1}";
        public const string CK_SHAREHOLDERS_GET_APPEARED_PH0_HP1 = "CK_SHAREHOLDERS_GET_APPEARED_{0}_{1}";
        public const string CK_SHAREHOLDERS_GET_AGGREGATED_PERCENTAGE_PH0_HP1 = "CK_SHAREHOLDERS_GET_AGGREGATED_PERCENTAGE_{0}_{1}";
        
        public const string CK_SHAREHOLDERS_COMPANY_MARKET_PH0 = "CK_SHAREHOLDER_COMPANY_MARKET_{0}";
        public const string CK_SHAREHOLDERS_CHANGES_NOOFRECORDS_PH0 = "CK_SHAREHOLDERS_CHANGES_NOOFRECORDS_{0}";
        #endregion
        public const string CK_NAVIGATION_MENU = "CK_NAVIGATION_MENU";
        public const string CK_ECONOMIC_INDICATOR_MARKETS = "CK_ECONOMIC_INDICATOR_MARKETS";
        public const string CK_ECONOMIC_INDICATORS_PH0 = "CK_ECONOMIC_INDICATORS_{0}";
        public const string CK_ECONOMIC_INDICATOR_FIELD_VALUES = "CK_ECONOMIC_INDICATOR_FIELD_VALUES";
        public const string CK_ECONOMIC_INDICATOR_FIELDS = "CK_ECONOMIC_INDICATOR_FIELDS";
        public const string CK_ECONOMIC_INDICATOR_SOURCE = "CK_ECONOMIC_INDICATOR_SOURCE";
        public const string CK_SEARCH_TERMS = "CK_SEARCH_TERMS";
        public const string CK_SECTION_TEMPLATES_BYLANGUAGE_PH0 = "CK_SECTION_TEMPLATES_BYLANGUAGE_{0}";
        public const string CK_SECTIONS_BYLANGUAGE_PH0 = "CK_SECTIONS_BYLANGUAGE_{0}";
        public const string CK_SECTION_SECTIONID_PH0_BYLANGUAGE_PH1 = "CK_SECTION_SECTIONID_{0}_BYLANGUAGE_{1}";
        public const string CK_ARTICLES_BYSECTION_SECTIONID_PH0_BYLANGUAGE_PH1_ENTITYID_PH2_ROWID_PH3 = "CK_ARTICLES_BYSECTION_SECTIONID_{0}_BYLANGUAGE_{1}_ENTITYID_{2}_ROWID_{3}";
        public const string CK_ARTICLES_BYSECTION_SECTIONID_PH0_BYLANGUAGE_PH1 = "CK_ARTICLES_BYSECTION_SECTIONID_{0}_BYLANGUAGE_{1}";

        public const string CK_ARTICLES_BYCOMPANYID_PH0_PAGENO_PH1_RECORDPERPAGE_PH2 = "CK_ARTICLES_BYCOMPANYID_{0}_PAGENO_{1}_RECORDPERPAGE_{2}";
        public const string CK_ARTICLES_BYMARKETID_PH0_BYSECTIONID_PH1_PAGENO_PH2_RECORDPERPAGE_PH3 = "CK_ARTICLES_BYMARKETID_{0}_BYSECTIONID_{1}_PAGENO_{2}_RECORDPERPAGE_{3}";
        public const string CK_ARTICLES_BYSECTIONID_PH0_PAGENO_PH1_RECORDPERPAGE_PH2 = "CK_ARTICLES_BYSECTIONID_{0}_PAGENO_{1}_RECORDPERPAGE_{2}";
        public const string CK_ARTICLES_ARGAAMREPORT_BYSECTIONID_PH0_LANGUAGEID_PH1 = "CK_ARTICLES_ARGAAMREPORT_BYSECTIONID_{0}_LANGUAGEID_{1}";
        public const string CK_ARTICLE_ARGAAMREPORT_MOSTVIEWED_SECTIONID_PH0_LANGUAGEID_PH1 = "CK_ARTICLE_ARGAAMREPORT_MOSTVIEWED_SECTIONID_{0}_LANGUAGEID_{1}";
        public const string CK_ALL_COMPANIES = "CK_ALL_COMPANIES";
        public const string CK_COMPANIES_COMPANY_COMPANYID_PH0 = "CK_COMPANIES_COMPANY_COMPANYID_{0}";
        public const string CK_COMPANIES_COMPANY_COMPANYNAME_PH0 = "CK_COMPANIES_COMPANY_COMPANYNAME_{0}";
        public const string CK_ALL_SECTIONS = "CK_ALL_SECTIONS";
        public const string CK_ALL_SECTIONTEMPLATES = "CK_ALL_SECTIONTEMPLATES";
        public const string CK_SECTION_ENTITY = "CK_SECTION_ENTITY";
        public const string CK_ARTICLE_DETAIL_ARTICLEID_PH0_LANGUAGEID_PH1 = "CK_ARTICLE_DETAIL_ARTICLEID_{0}_LANGUAGEID_{1}";
        
        public const string CK_MARKETS_MARKETID_PH0 = "CK_MARKETS_MARKETID_{0}";
        public const string CK_ALL_MARKETS = "CK_ALL_MARKETS";
        public const string CK_ARTICLE_REORDERARTICLE_BYARTICLEID_PH0_LANGAUGEID_PH1 = "CK_ARTICLE_REORDERARTICLE_BYARTICLEID_{0}_LANGUAGEID_{1}";
        public const string CK_ARTICLE_BYARTICLEID_PH0 = "CK_ARTICLE_BYARTICLEID_{0}";
        public const string CK_ARTICLE_BYTEXT_PH0 = "CK_ARTICLE_BYTEXT_{0}";
        public const string CK_ARTICLE_BYTEXT_PH0_BYFROMDATE_PH1_BYTODATE_PH2_LANGUAGEID_PH3_PAGE_PH4 = "CK_ARTICLE_BYTEXT_{0}_BYFROMDATE_{1}_BYTODATE_{2}_LANGUAGEID_{3}_PAGE_{4}";
        public const string CK_ARTICLE_ARGAAMREPORT_NEWLARTICLE_SECTIONID_PH0_LANGUAGEID_PH1 = "CK_ARTICLE_ARGAAMREPORT_NEWLARTICLE_SECTIONID_{0}_LANGUAGEID_{1}";
        public const string CK_ARTICLE_ARGAAMSECTOR_BYARGAAMSECTORID_PH0_KEYWORD_PH1_ARGAAMSECTORID_PH2_MARKETSECTOR_PH3_FROMDATE_PH4_TODATE_PH5_LANGUAGEID_PH6 =
            "CK_ARTICLE_ARGAAMSECTOR_BYARGAAMSECTORID_{0}_KEYWORD_{1}_ARGAAMSECTORID_{2}_MARKETSECTOR_{3}_FROMDATE_{4}_TODATE_{5}_LANGUAGEID_{6}";
        public const string CK_ARTICLE_ARTICLECOMMENTRELATEDINFO_BYARTICLEID_PH0 = "CK_ARTICLE_ARTICLECOMMENTRELATEDINFO_BYARTICLEID_{0}";
        public const string CK_TELESCOPE_SECTION_ARTICLES = "CK_TELESCOPE_SECTION_ARTICLES";
        public const string CK_ARTICLE_RELATED_INFO_ORDER_BYARTICLEID_PH0 = "CK_ARTICLE_RELATED_INFO_ORDER_BYARTICLEID_{0}";
        public const string CK_ARTICLE_BYARGAAMSECTOR_ARGAAMSECTORID_PH0 = "CK_ARTICLE_BYARGAAMSECTOR_ARGAAMSECTORID_PH0";
        public const string CK_ALL_ARGAAMSECTOR = "CK_ALL_ARGAAMSECTOR";

        public const string CK_COMPANIES_COMPANY_SALARY_UNITE_PL0 = "CK_COMPANIES_COMPANY_SALARY_UNITE_{0}";
        public const string CK_COMPANIES_COMPANY_DEFAULT_ARGAAM_SECTORID_PL0 = "CK_COMPANIES_COMPANY_DEFAULT_ARGAAM_SECTORID_{0}";

        #region CompanyProfile Keys

        public const string CK_COMPANY_COMPANY_DETAILS_PH0 = "CK_COMPANY_COMPANY_DETAILS_{0}";
        public const string CK_REPORTS_REPORTGROUPID_PH0_ENTITYID_PH1 = "CK_REPORTS_REPORTGROUPID_{0}_ENTITYID_{1}";
        public const string CK_COMPANY_DESCRIPTION_MARKETID_PH0_MARKETSTATUSID_PH1_COMPANYID_PH2 = "CK_COMPANY_DESCRIPTION_MARKETID_{0}_MARKETSTATUSID_{1}_COMPANYID_{2}";
        public const string CK_COMPANY_TRADINGDATA_MARKETID_PH0_COMPANYID_PH1 = "CK_COMPANY_TRADINGDATA_MARKETID_{0}_COMPANYID_{1}";
        public const string CK_COMPANY_RELATED_ARGAAMSECTORS_MARKETID_PH0_MARKETSTATUSID_PH1_COMPANYID_PH2 = "CK_COMPANY_RELATED_ARGAAMSECTORS_MARKETID_{0}_MARKETSTATUSID_{1}_COMPANYID_{2}";
        public const string CK_COMPANY_SUBSIDIARY_BOOKVALUE_COMPANYID_PH0 = "CK_COMPANY_SUBSIDIARY_BOOKVALUE_COMPANYID_{0}";
        public const string CK_COMPANY_INVESTMENT_BOOKVALUE_COMPANYID_PH0 = "CK_COMPANY_INVESTMENT_BOOKVALUE_COMPANYID_{0}";
        public const string CK_COMPANY_LISTED_BYCOMPNAMEORCOMPID_MARKETID_PH0_COMPANYNAME_PH1_COMPANYID_PH2_BYLANGUAGE_PH3_PAGENO_PH4_PAGESIZE_PH5 = "CK_COMPANY_LISTED_BYCOMPNAMEORCOMPID_MARKETID_{0}_COMPANYNAME_{1}_COMPANYID_{2}_BYLANGUAGE_{3}_PAGENO_{4}_PAGESIZE_{5}";
        public const string CK_COMPANY_KEYDEVELOPMENT_COMPANYID_PH0 = "CK_COMPANY_KEYDEVELOPMENT_COMPANYID_{0}";
        public const string CK_SHAREHOLDERS_COMPANIES_FORDATE = "CK_SHAREHOLDERS_COMPANIES_FORDATE";
        public const string CK_COMPANY_SHAREHOLDER_COMPANYID_PH0_FROMDATE_PH1_TODATE_PH2 = "CK_COMPANY_SHAREHOLDER_COMPANYID_{0}_FROMDATE_{1}_TODATE_{2}";
        public const string CK_COMPANY_RELATED_COMPANIES_COMPANYID_PH0 = "CK_COMPANY_RELATED_COMPANIES_COMPANYID_{0}";
        public const string CK_COMPANY_SHAREINFORMATION_COMPANYID_PH0_MARKETID_PH1 = "CK_COMPANY_SHAREINFORMATION_COMPANYID_{0}_MARKETID_{1}";
        public const string CK_COMPANY_COMPANYSHARE_COMPANYID_PH0 = "CK_COMPANY_COMPANYSHARE_COMPANYID_{0}";
        public const string CK_COMPANY_ARGAAMSECTORFSTEMPLATE_COMPANYID_PH0 = "CK_COMPANY_ARGAAMSECTORFSTEMPLATE_COMPANYID_{0}";
        public const string CK_FINANCIAL_FSTEMPLATEFIELDS_FSTEMPLATEID_PH0_FSPARENTTEMPLATEID_PH1 = "CK_FINANCIAL_FSTEMPLATEFIELDS_FSTEMPLATEID_{0}_FSPARENTTEMPLATEID_{1}";
        public const string CK_COMPANY_FINANCIALSTATEMENT_BYFISCALPERIOD_COMPANYID_PH0_FISCALPERIOD_PH1 = "CK_COMPANY_FINANCIALSTATEMENT_BYFISCALPERIOD_COMPANYID_{0}_FISCALPERIOD_{1}";
        public const string CK_FINANCIAL_FSTEMPLATEFIELDS_COMPANYSIZE_FSTEMPLATEID_PH0_PARENTTEMPLATEID_PH1 = "CK_FINANCIAL_FSTEMPLATEFIELDS_COMPANYSIZE_FSTEMPLATEID_{0}_PARENTTEMPLATEID_{1}";
        public const string CK_COMPANY_FINANCIALSTATEMENT_FISCALPERIODID_PH0_COMPANYID_PH1 = "CK_COMPANY_FINANCIALSTATEMENT_FISCALPERIODID_{0}_COMPANYID_{1}";
        public const string CK_COMPANY_EMPLOYEES_COMPANYID_PH0 = "CK_COMPANY_EMPLOYEES_COMPANYID_{0}";
        public const string CK_ARGAAMSECTORS = "CK_ARGAAMSECTORS";
        public const string CK_COMPANY_COMPANYID_PH0 = "CK_COMPANY_COMPANYID_{0}";
        
        #endregion

        #region CompanyAction Keys
        public const string CK_COMPANY_DIVIDEND_INFO_PH0 = "CK_COMPANY_DIVIDEND_INFO_{0}";
        public const string CK_COMPANY_CAPITALCHANGE_INFO_PH0 = "CK_COMPANY_CAPITALCHANGE_INFO_{0}";
        public const string CK_CAPITALCHANGE_IPO_INFO_PH0 = "CK_CAPITALCHANGE_IPO_INFO_{0}";
        public const string CK_CAPITALCHANGEHISTORY_PH0_PH1_PH2 = "CK_CAPITALCHANGEHISTORY_{0}_{1}_{2}";
        public const string CK_COMPANY_FSVALUEOFPREVIOUSQUATER_FROMCURRENTDATE_COMPANYID_PH0_FROMDATE_PH1_FSFIELDS_PH2 = "CK_COMPANY_FSVALUEOFPREVIOUSQUATER_FROMCURRENTDATE_COMPANYID_{0}_FROMDATE_{1}_FSFIELDS_{2}";
        public const string CK_COMPANYDIVIDENDHISTORY_PH0_PH1 = "CK_COMPANYDIVIDENDHISTORY_{0}_{1}";
        
        #endregion

        #region CompanyOverview Keys
        public const string CK_FINANCIAL_FSTEMPLATE_FSTEMPLATEID_PH0 = "CK_FINANCIAL_FSTEMPLATE_FSTEMPLATEID_{0}";
        public const string CK_FINANCIAL_FSTEMPLATEFIELD_COMPANYOVERVIEW_FSTEMPLATEID_PH0_FSPARENTTEMPALTEID_PH1 = "CK_FINANCIAL_FSTEMPLATEFIELD_COMPANYOVERVIEW_FSTEMPLATEID_{0}_FSPARENTTEMPALTEID_{1}";
        public const string CK_COMPANY_FSTEMPLATEFIELDVALUES_BYFSID_FSIDS_PH0_TEMPLATETABLENAME_PH1 = "CK_COMPANY_FSTEMPLATEFIELDVALUES_BYFSID_FSIDS_{0}_TEMPLATETABLENAME_{1}";
        #endregion
        
        public const string CK_COMPANIES_COMPANY_COMPANYSTOCKPRICESARCHIVE_PL0_PL1 = "CK_COMPANIES_COMPANY_COMPANYSTOCKPRICESARCHIVE_{0}_{1}";
        public const string CK_COMPANIES_COMPANY_PREVDAYCLOSINGPRICE_PL0_PL1 = "CK_COMPANIES_COMPANY_PREVDAYCLOSINGPRICE_{0}_{1}";
        public const string CK_COMPANIES_COMPANY_INTRADAYCOMPANYSTOCKPRICES_PL0_PL1 = "CK_COMPANIES_COMPANY_INTRADAYCOMPANYSTOCKPRICES_{0}_{1}";
        
        public const string CK_COMPANIES_COMPANY_MARKETID_PL0_COMPANYID_PL1_STOCKPRICE = "CK_COMPANIES_COMPANY_MARKETID_{0}_COMPANYID_{1}_STOCKPRICE";
        public const string CK_COMPANIES_COMPANY_OS_COMPANYID_PL0 = "CK_COMPANIES_COMPANY_OS_COMPANYID_PL0_{0}";
        public const string CK_COMPANIES_COMPANY_OS_SALARY_AND_BONUS_COMPANYID_PL0_YEAR_PL1 = "CK_COMPANIES_COMPANY_OS_SALARY_AND_BONUS_COMPANYID_PL{0}_YEAR_PL{1}";
        public const string CK_COMPANIES_COMPANY_BY_TEXT_PL0_LANGUAGEID_PL1 = "CK_COMPANIES_COMPANY_BY_TEXT_{0}_LANGUAGEID_{1}";

        public const string CK_COMMODITYTYPES = "CK_COMMODITYTYPES";
        public const string CK_COMMODITYTIES = "CK_COMMODITYTIES";

        public const string CK_MARKETSECTORCOMPANIES_FOR_PETROCHEMICAL = "CK_MARKETSECTORCOMPANIES_FOR_PETROCHEMICAL";
        public const string CK_COMMODITYPRICES_BYCOMMODITYTYPE_PL0_BYCOMMCAT_PL1_COMMNAME_PL2 = "CK_COMMODITYPRICES_BYCOMMODITYTYPE_{0}_BYCOMMCAT_{1}_COMMNAME_{2}";
        
        public const string CK_COMPANIESLIST_BYSECTORID_PL0_PGNO_PL1 = "CK_COMPANIESLIST_BYSECTORID_{0}_PGNO_{1}";
        public const string CK_COMPANIESRANKLIST_BYSECTORID_PL0_PGNO_PL1 = "CK_COMPANIESRANKLIST_BYSECTORID_{0}_PGNO_{1}";
        public const string CK_COMPANIESLIST_BYARGSECTORIDS_PL0_PGNO_PL1 = "CK_COMPANIESLIST_BYARGSECTORIDS_{0}_PGNO_{1}";
        public const string CK_COMPANIESRANKLIST_BYARGSECTORIDS_PL0_PGNO_PL1 = "CK_COMPANIESRANKLIST_BYARGSECTORIDS_{0}_PGNO_{1}";
        
        public const string CK_COMPANIES_LIGHT_WEIGHT_LIST = "CK_COMPANIES_LIGHT_WEIGHT_LIST";
        public const string CK_COMPANIES_LISTED_PH0_PH1 = "CK_COMPANIES_LISTED_{0}_{1}";

        public const string CK_COMPANYSALARYANDBONUSESLIST_BYSECTORID_PL0_BYYEAR_PL1_PGNO_PL2 = "CK_COMPANYSALARYANDBONUSESLIST_BYSECTORID_{0}_{1}_PGNO_{2}";

        public const string CK_SECTION_GETALL_SECTION = "CK_SECTION_GETALL_SECTION";

        public const string CK_ENTITY_PH0 = "CK_ENTITY_{0}";
        public const string CK_COMPANYSALARYANDBONUSESLIST_BYARGSECTORID_PL0_BYYEAR_PL1_PGNO_PL2 = "CK_COMPANYSALARYANDBONUSESLIST_BYARGSECTORID_{0}_{1}_PGNO_{2}";
        public const string CK_UNIQUEYEARVALS_FOR_SALANDBONUSES = "CK_UNIQUEYEARVALS_FOR_SALANDBONUSES";
        public const string CK_COMPANIES_COMPANY_MARKETID_PH0_COMPANYID_PH1_FDATE_PH2_TODATE_PH3_STOCKPRICEARCHIVE = "CK_COMPANIES_COMPANY_MARKETID_PH0_COMPANYID_PH1_FDATE_PH2_TODATE_PH3_STOCKPRICEARCHIVE";

        public const string CK_SECTORS_ALL = "CK_SECTORS_ALL";
        public const string CK_ENTITY_NUMBERFORMATS = "CK_ENTITY_NUMBERFORMATS";

        public const string CK_COMMODITY_BYARTICLEID_PL0 = "CK_COMMODITY_BYARTICLEID_{0}";
        public const string CK_RELATEDENTITIES_BYARTICLEID_PL0 = "CK_RELATEDENTITIES_BYARTICLEID_{0}";
        public const string CK_MARKETSTOCKS_BYMARKETIDS_PL0 = "CK_MARKETSTOCKS_BYMARKETIDS_{0}";
        public const string CK_MARKETS_MARKET_MARKETSTOCKPRICESARCHIVE_PL0 = "CK_MARKETS_MARKET_MARKETSTOCKPRICESARCHIVE_{0}";
        public const string CK_MARKETS_MARKET_LASTDAY_MARKETSTOCKPRICESARCHIVE_PL0 = "CK_MARKETS_MARKET_LASTDAY_MARKETSTOCKPRICESARCHIVE_{0}";
        public const string CK_COMPANYSTOCKS_BYCOMPANYIDS_PL0 = "CK_COMPANYSTOCKS_BYCOMPANYIDS_{0}";

        public const string CK_PAGE_BY_URL_PH0 = "CK_PAGE_BY_URL_{0}";
        public const string CK_PAGE_LABEL_PH0_PH1 = "CK_PAGE_LABEL_{0}_{1}";

        public const string CK_PP_BREADCRUMBS_ISFORPP_PH0 = "CK_PP_BREADCRUMBS_ISFORPP_{0}";

        public const string CK_MARKETPULSES_MARKETID_PH0_FROMDATE_PH1_TODATE_PH2_LANGUAGEID_PH3_PAGENO_PH4_PAGESIZE_PH5 = "CK_MARKETPULSES_MARKETID_{0}_FROMDATE_{1}_TODATE_{2}_LANGUAGEID_{3}_PAGENO_{4}_PAGESIZE_{5}";
        public const string CK_MARKETPULSES_FROMDATE_PH0_TODATE_PH1_LANGUAGEID_PH2_PAGENO_PH3 = "CK_MARKETPULSES_FROMDATE_{0}_TODATE_{1}_LANGUAGEID_{2}_PAGENO_{3}";

        public const string CK_MARKETPULSES_DETAIL_MARKETPULSEID_PH0 = "CK_MARKETPULSES_DETAIL_MARKETPULSEID_{0}";

        public const string CK_PAGETEMPLATE_PAGEID_PH0_LANGUAGEID_PH1 = "CK_PAGETEMPLATE_PAGEID_{0}_LANGUAGEID_{1}";
        public const string CK_MARKETS_MARKETSTOCKS = "CK_MARKETS_MARKETSTOCKS";
        public const string CK_HOTLINKS_GET_PAGENO_PH0 = "CK_HOTLINKS_GET_PAGENO_{0}";
        public const string CK_FREEFLOATEDSHARES_COMPANIESWEIGHT_LANGUAGEID_PH0_MARKETID_PH1_MARKETSTATUSID_PH2 = "CK_FREEFLOATEDSHARES_COMPANIESWEIGHT_LANGUAGEID_{0}_MARKETID_{1}_MARKETSTATUSID_{2}";
        public const string CK_FREEFLOATEDSHARES_SECTORSWEIGHT_LANGUAGEID_PH0 = "CK_FREEFLOATEDSHARES_SECTORSWEIGHT_LANGUAGEID_{0}";

        public const string CK_TICKER_NEWS_LANGUAGEID_PH0 = "CK_TICKER_NEWS_LANGUAGEID_{0}";
        public const string CK_COMPANIES_MARKETID_PH0_ARGAAMSECTORID_PH1_SORTBYMARKETVAL_PH2_NOOFRECORDS_PH3_TOP_RANK_COMPANIES = "CK_COMPANIES_MARKETID_{0}_ARGAAMSECTORID_{1}_SORTBYMARKETVAL_{2}_NOOFRECORDS_{3}_TOP_RANK_COMPANIES";
        public const string CK_MARKETS_COMPANYSTATS_MARKETID_PH0_STATSTYPE_PH1_PAGENO_PH2_NOOFRECORDS_PH3 = "CK_MARKETS_COMPANYSTATS_MARKETID_{0}_STATSTYPE_{1}_PAGENO_{2}_NOOFRECORDS_{3}";

        public const string CK_FINANCIAL_RATIO_STRUCTURE = "CK_FINANCIAL_RATIO_STRUCTURE";
        public const string CK_FINANCIAL_RATIO_STRUCTURE_COMPANY_PH01 = "CK_FINANCIAL_RATIO_STRUCTURE_COMPANY_{0}";
        public const string CK_FINANCIAL_RATIO_COMPANY_PH01_PH1 = "CK_FINANCIAL_RATIO_COMPANY_{0}_{1}";
        public const string CK_FINANCIAL_RATIO_COMPANY_TEMPLATE_PH01 = " CK_FINANCIAL_RATIO_COMPANY_TEMPLATE__{0}";
        public const string CK_FINANCIAL_RATIO_ALL_COMPANY_PH01 = "CK_FINANCIAL_RATIO_ALL_COMPANY_{0}";
        public const string CK_FINANCIAL_RATIO_ALL_COMPANY_H_PH01 = "CK_FINANCIAL_RATIO_ALL_COMPANY_H_{0}";
        public const string CK_FINANCIAL_RATIO_ENTITY_ALL_COMPANY_PH01 = "CK_FINANCIAL_RATIO_ENTITY_ALL_COMPANY_{0}";
        public const string CK_FINANCIAL_RATIO_ENTITY_ALL_COMPANY_BY_PH01_PH2 = "CK_FINANCIAL_RATIO_ENTITY_ALL_COMPANY_BY_{0}_{1}";

        public const string CK_ATTRIBUTES = "CK_ATTRIBUTES";
        public const string CK_REPORTS_REPORTGROUPID_PH0 = "CK_REPORTS_REPORTGROUPID_{0}";
        public const string GET_PERSHARE_DATA_FOR_COMPANY_ANALYSIS_PH0_PH1_PH2_PH3__PH4_PH5_PH6_PH7 = "GET_PERSHARE_DATA_FOR_COMPANY_ANALYSIS_{0}_{1}_{2}_{3}__{4}_{5}_{6}_{7}";
        public const string GET_COMPANY_ANALYSIS_MARKET_PERFORMANCE_PH0_PH1_PH2_PH3_PH4_PH5_PH6_PH7_PH8_PH9_PH10 = "GET_COMPANY_ANALYSIS_MARKET_PERFORMANCE_{0}_{1}_{2}_{3}_{4}_{5}_{6}_{7}_{8}_{9}_{10}";
        public const string CK_SIMPLE_TABLE_REPORTS_REPORTID_YEARVALUE_PH0_PH1 = "CK_SIMPLE_TABLE_REPORTS_REPORTID_YEARVALUE_{0}_{1}";
        public const string CK_ATTRIBUTETYPE_REPORTFIELDS_REPORTID_PH0 = "CK_ATTRIBUTETYPE_REPORTFIELDS_REPORTID_{0}";
        public const string CK_REPORTFIELDS_REPORTID_PH0 = "CK_REPORTFIELDS_REPORTID_{0}";
        public const string CK_HOTLINKS_COMPANYID_PH0_LANGUAGEID_PH1 = "CK_HOTLINKS_COMPANYID_{0}_LANGUAGEID_{1}";
        public const string CK_BANK_REPORTS_REPORTID_PH0 = "CK_BANK_REPORTS_REPORTID_{0}";
        public const string CK_BANK_REPORTS_REPORTID2_PH0 = "CK_BANK_REPORTS_REPORTID2_{0}";
        public const string CK_BANK_REPORTS_REPORTID3_PH0 = "CK_BANK_REPORTS_REPORTID2_{0}";
        public const string CK_BANK_REPORTS_COMPANYVALUES_REPORTID_PH0 = "CK_BANK_REPORTS_COMPANYVALUES_REPORTID_{0}";
        
        public const string CK_BANK_REPORTS_COMPANYVALUES2_REPORTID_PH0 = "CK_BANK_REPORTS_COMPANYVALUES2_REPORTID_{0}";
        
        public const string CK_COMPANY_REPORTS_REPORTID_COMPANYID_PH0_PH1 = "CK_COMPANY_REPORTS_REPORTID_COMPANYID_{0}_{1}";

        public const string CK_SECTORS_MARKETID_PH0_LANGID_PH1 = "CK_SECTORS_MARKETID_{0}_LANGID_{1}";
        public const string CK_COMPANY_FREEFLOATEDSHARES_MARKETID_PH0_MARKETSTATUSID_PH1_YEAR_PH2_MONTH_PH3_PAGENO_PH4_PAGESIZE_PH5 = "CK_COMPANY_FREEFLOATEDSHARES_MARKETID_{0}_MARKETSTATUSID_{1}_YEAR_{2}_MONTH_{3}_PAGENO_{4}_PAGESIZE_{5}";
        public const string CK_COMPANY_FREEFLOATEDSHARES_COMPANYID_PH0_MARKETID_PH1_MARKETSTATUSID_PH2 = "CK_COMPANY_FREEFLOATEDSHARES_COMPANYID_{0}_MARKETID_{1}_MARKETSTATUSID_{2}";
        public const string CK_COMPANY_COUNT_MARKETID_PH0_MARKETSTATUSID_PH1_SECTORID_PH2 = "CK_COMPANY_COUNT_MARKETID_{0}_MARKETSTATUSID_{1}_SECTORID_{2}";
        public const string CK_COMPANY_COMPANY_RESULT_ANALYSIS_FORYEAR_PH0_FORDATE_PH1_FISCALPERIODVALUEID_PH2 = "CK_COMPANY_COMPANY_RESULT_ANALYSIS_FORYEAR_{0}_FORDATE_{1}_FISCALPERIODVALUEID_{2}";
        public const string CK_PROJECT_DETAIL_IMAGES_PROJECTID_PH0 = "CK_PROJECT_DETAIL_IMAGES_PROJECTID_{0}";
        public const string CK_PROJECT_DETAIL_FINANCINGS_PROJECTID_PH0 = "CK_PROJECT_DETAIL_FINANCINGS_PROJECTID_{0}";
        public const string CK_PROJECT_DETAIL_PROJECTID_PH0 = "CK_PROJECT_DETAIL_PROJECTID_{0}";
        public const string CK_PROJECT_COMPANY_PROJECTID_PH0 = "CK_PROJECT_COMPANY_PROJECTID_{0}";
        public const string CK_PROJECT_COMPANY_ROLES_PROJECTID_PH0 = "CK_PROJECT_COMPANY_ROLES_PROJECTID_{0}";
        public const string CK_PROJECT_ARGAAM_SECTORS_PROJECTID_PH0 = "CK_PROJECT_ARGAAM_SECTORS_PROJECTID_{0}";
        public const string CK_PROJECT_FEATUERD_PROJECT_RECORDCOUNT_PH0_ISFEATURED_PH1 = "CK_PROJECT_FEATUERD_PROJECT_RECORDCOUNT_{0}_ISFEATURED_{1}";
        public const string CK_PROJECT_COMPANY_FEATUERD_PROJECT_RECORDCOUNT_PH0_ISFEATURED_PH1_ISVISIBLE_PH2_COMPANYID_PH3 = "CK_PROJECT_COMPANY_FEATUERD_PROJECT_RECORDCOUNT_{0}_ISFEATURED_{1}_ISVISIBLE_{2}_COMPANYID_{3}";

        public const string CK_CURRENCYEXCHANGERATEINFO_FROMCURRENCY_PH0_TOCURRENCY_PH1 = "CK_CURRENCYEXCHANGERATEINFO_FROMCURRENCY_{0}_TOCURRENCY_{1}";
        public const string CK_MEASURINGUNITS = "CK_MEASURINGUNITS";
        public const string CK_COMPANYSHARE_FORCOMPANIES_BYCOMPANYID_PH0 = "CK_COMPANYSHARE_FORCOMPANIES_BYCOMPANYID_{0}";
        public const string CK_BASICINFO_FORCOMPANIES_BYCOMPANYID_PH0 = "CK_BASICINFO_FORCOMPANIES_BYCOMPANYID_{0}";
        public const string CK_BASICINFO_FORCOMPANIES_STOCKPRICES_BYCOMPANYID_PH0 = "CK_BASICINFO_FORCOMPANIES_STOCKPRICES_BYCOMPANYID_{0}";

        public const string CK_REPORTS_REPORT_AVLIBLE_YEARS_PH1 = "CK_REPORTS_REPORT_AVLIBLE_YEARS_{0}";
        public const string CK_REPORTS_REPORT_AVLIBLE_YEARS_PH1_PH2 = "CK_REPORTS_REPORT_AVLIBLE_YEARS_{0}_{1}";
        public const string CK_REPORTS_REPORT_AVLIBLE_YEARS_PH1_PH2_PH3 = "CK_REPORTS_REPORT_AVLIBLE_YEARS_{0}_{1}_{2}";
        


        public const string CK_COMPANY_BUSINESS_SEGMENTS_DEFINITION_PH0 = "CK_COMPANY_BUSINESS_SEGMENTS_DEFINITION_{0}";
        public const string CK_COMPANY_BUSINESS_SEGMENTS_FINANCIAL_FIELDS_PH0 = "CK_COMPANY_BUSINESS_SEGMENTS_FINANCIAL_FIELDS_{0}";
        public const string CK_COMPANY_BUSINESS_SEGMENTS_FINANCIAL_FIELDVALUES_PH0_PH1 = "CK_COMPANY_BUSINESS_SEGMENTS_FINANCIAL_FIELDVALUES_{0}_{1}";

        public const string CK_COMPANY_GEOLOCATION_SEGMENTS_DEFINITION_PH0 = "CK_COMPANY_GEOLOCATION_SEGMENTS_DEFINITION_{0}";
        public const string CK_COMPANY_GEOLOCATION_SEGMENTS_FINANCIAL_FIELDS_PH0 = "CK_COMPANY_GEOLOCATION_SEGMENTS_FINANCIAL_FIELDS_{0}";
        public const string CK_COMPANY_GEOLOCATION_SEGMENTS_FINANCIAL_FIELDVALUES_PH0_PH1 = "CK_COMPANY_GEOLOCATION_SEGMENTS_FINANCIAL_FIELDVALUES_{0}_{1}";

        public const string CK_MARKETSECTORS_MARKETID_PH0_SECTORID_PH1 = "CK_MARKETSECTORS_MARKETID_{0}_SECTORID_{1}";
        public const string CK_ARGAAMSECTORANDCOMPANYIDS_PH0_PH1 = "CK_ARGAAMSECTORANDCOMPANYIDS_{0}_{1}";
        public const string CK_SECTORANDCOMPANYIDS_PH0_PH1 = "CK_SECTORANDCOMPANYIDS_{0}_{1}";

        public const string CK_COMPANY_COMPANYCHART_EVENTS_MARKETID_PH0_COMPANYID_PH1 = "CK_COMPANY_COMPANYCHART_EVENTS_MARKETID_{0}_COMPANYID_{1}";
        public const string CK_ARTICLES_ARTICLETYPES = "CK_ARTICLES_ARTICLETYPES";

        public const string CK_CAPITALCHANGECHART_PH0_PH1 = "CK_CAPITALCHANGECHART_{0}_{1}";
        public const string CK_CASHDIVIDENDCHART_PH0 = "CK_CASHDIVIDENDCHART_{0}";

        public const string CK_AVAILABLEDATAFISCALS_COMPANYRESULTANALYSIS_PH0_PH1 = "CK_AVAILABLEDATAFISCALS_COMPANYRESULTANALYSIS_{0}_{1}";
        public const string CK_COMPANYIDS_PUBLISHEDFINANCIALREPORTS_PH0_PH1 = "CK_COMPANYIDS_PUBLISHEDFINANCIALREPORTS_{0}_{1}";
        public const string CK_PETROCHEMICALCOMPANYSCOUNT_PH0 = "CK_PETROCHEMICALCOMPANYSCOUNT_{0}";

        public const string CK_PETROCHEMICALPRODUCTIONCAPACITY_MARKET_PH0_COMPANY_PH1_PH2_PH3_PH4_PH5 = "CK_PETROCHEMICALPRODUCTIONCAPACITY_MARKET_{0}_COMPANY_{1}_{2}_{3}_{4}_{5}";
        public const string CK_SUBSIDIARYCOMPANIES_PERCENTAGES_INFO_PH0 = "CK_SUBSIDIARYCOMPANIES_PERCENTAGES_INFO_{0}";
        public const string CK_PROVISIONALTIMINGS = "CK_PROVISIONALTIMINGS";
        public const string CK_PETROCHEMICALPRODUCTIONSTATUSES = "CK_PETROCHEMICALPRODUCTIONSTATUSES";

        public const string CK_TOTALPRODCAPANDSHARESINFO_PH0_PH1_PH2_PH3 = "CK_TOTALPRODCAPANDSHARESINFO_{0}_{1}_{2}_{3}";
        public const string CK_AVAILABLEYEARS_PRODUCTIONCAPACITY_PH0 = "CK_AVAILABLEYEARS_PRODUCTIONCAPACITY_{0}";
        public const string CK_COMPANY_OVERVIEW_INFO_PH0 = "CK_COMPANY_OVERVIEW_INFO_{0}";
        public const string CK_FSFIELDS = "CK_FSFIELDS";
        public const string CK_FINANCIALRATIOS = "CK_FINANCIALRATIOS";
        public const string CK_REGIONS = "CK_REGIONS";
        public const string CK_COUNTRIES = "CK_COUNTRIES";
        public const string CK_FSFIELDS_BYMKTORARGSECTORS_PH0_PH1 = "CK_FSFIELDS_BYMKTORARGSECTORS_{0}_{1}";
        public const string CK_FRATIOS_BYMKTORARGSECTORS_PH0_PH1 = "CK_FRATIOS_BYMKTORARGSECTORS_{0}_{1}";
        public const string CK_FISCALSFORFSFIELDVALUES_BYMKTORARGSECTORS_PH0_PH1_PH2 = "CK_FISCALSFORFSFIELDVALUES_BYMKTORARGSECTORS_{0}_{1}_{2}";
        public const string CK_FSFIELDVALUES_BYMKTORARGSECTORS_PH0_PH1_PH2_PH3 = "CK_FSFIELDVALUES_BYMKTORARGSECTORS_{0}_{1}_{2}_{3}";

        public const string CK_FISCALS_AVAILABLE_FRATIODATA_PH0_PH1 = "CK_FISCALS_AVAILABLE_FRATIODATA_{0}_{1}";
        public const string CK_FRATIOVALUES_BYMKTORARGSECTORS_PH0_PH1_PH2_PH3_PH4_PH5 = "CK_FRATIOVALUES_BYMKTORARGSECTORS_{0}_{1}_{2}_{3}_{4}_{5}";
        public const string CK_FRATIOVALUES_BYCOMPANYID_PH0_PH1_PH2_PH3_PH4 = "CK_FRATIOVALUES_BYMKTORARGSECTORS_{0}_{1}_{2}_{3}_{4}";

        public const string CK_ADVREPORTS_USERID_PH0 = "CK_ADVREPORTS_USERID_{0}";
        public const string CK_ADVREPORTS_REPORTID_PH0 = "CK_ADVREPORTS_REPORTID_{0}";

        // Financial Report Keys
        public const string CK_FINRPT_COMPANY_DATA_PH0 = "CK_FINRPT_COMPANY_DATA_{0}";
        public const string CK_FINRPT_SECTOR_DATA_PH0 = "CK_FINRPT_SECTOR_DATA_{0}";
        public const string CK_FINRPT_BUSINESS_SEGMENT_DATA_PH0_PH1 = "CK_FINRPT_BUSINESS_SEGMENT_DATA_{0}_{1}";

        public const string CK_COMPANYMENUITEMSVISIBILITY_PH0 = "CK_COMPANYMENUITEMSVISIBILITY_{0}";

        #region deleted keys(not to be used)
        //public const string CK_COUNTRY_BYLANGUAGE_PH0 = "CK_COUNTRY_{0}";
        //public const string CK_LOCALIZATIONS = "CK_LOCALIZATIONS";
        //public const string CK_CONFIGURATIONS_KEY_PH0_CFGCAT_PH1 = "CK_CONFIGURATIONS_KEY_{0}_CFGCAT_{1}";
        //public const string CK_SHAREHOLDERS_GET_DATA_MAX_AVALIBLE_DATE = "CK_SHAREHOLDERS_GET_DATA_MAX_AVALIBLE_DATE";
        //public const string CK_SHAREHOLDERS_COMPANIES_FOR_DATE_PH0 = "CK_SHAREHOLDERS_COMPANIES_FOR_DATE_{0}";
        //public const string CK_ARTICLE_SEARCHARTICLE_TEXT_PH0_FROMDATE_PH1_TODATE_PH2 = "CK_ARTICLE_SEARCHARTICLE_TEXT_{0}_FROMDATE_{1}_TODATE_{2}";
        //public const string CK_COMPANIES_COMPANY_MARKETID_PL0_COMPANYID_PL1 = "CK_COMPANIES_COMPANY_MARKETID_{0}_COMPANYID_{1}";
        //public const string CK_COMPANIES_COMPANY_INTRADAYCOMPANYSTOCKPRICESFORCHART_PL0_PL1 = "CK_COMPANIES_COMPANY_INTRADAYCOMPANYSTOCKPRICESFORCHART_{0}_{1}";
        //public const string CK_COMPANIES_JoinTbl_PL0_Id_PL1 = "CK_COMPANIES_JoinTbl_{0}_Id_{1}";
        //public const string CK_COMPANIESLIST = "CK_COMPANIESLIST";
        //public const string CK_REPORTS_SECTORVALUES_REPORTID_PH0 = "CK_REPORTS_SECTORVALUES_REPORTID_{0}";
        //public const string CK_ENTITYREPORTS_ENTITYID_PH0_ROWID_PH1 = "CK_ENTITYREPORTS_ENTITYID_{0}_ROWID_{1}";
        #endregion deleted keys(not to be used)
    }

    /// <summary>
    /// Durations in seconds
    /// </summary>
    public enum CacheDurationsEnum : int
    {
        OneMinute = 60,
        FiveMinutes = 300,
        TenMinutes = 600,
        FifteenMinutes = 900,
        ThirtyMinutes = 1800,
        OneHour = 3600,
        SixHours = 21600
    }

    /// <summary>
    /// Durations in seconds
    /// </summary>
    public enum CacheAsyncUpdateDuration : int
    {
        TwoSeconds = 2,
        FiveSeconds = 5,
        TenSeconds = 10,
        FifteenSeconds = 15,
        ThirtySeconds = 30,
        OneMinute = 60,
        FiveMinutes = 300,
        TenMinutes = 600,
        FifteenMinutes = 900,
        OneHour = 3600,
        SixHours = 21600
    }
}
