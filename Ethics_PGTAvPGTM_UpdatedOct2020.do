** analysis for Jia 2020
** below is the original dataset used for the ASRM abtrsact and the 1st submitted version of the manuscript
import excel "C:\Users\Lpastore\Documents\ASRM2020\ASRM2020_Jia_MaxDataset_ForUploadEvolution_EditID197.xlsx", sheet("Data4Upload_AgeMax") firstrow clear

*** below is the updated dataset used in Oct 2020
import excel "C:\Users\Lpastore\Documents\PGT_MiriamJia\Jia_Dataset_thru31July2020.xlsx", sheet("UploadDataset") cellrange(A1:DV208) firstrow clear


tab1 PGTA_yn study disorder2, missing
tabulate PGTA_yn study, miss


************* start with demographics and background data
tab1 gender marital insur_where  numcycle educ hispanic marketing, missing
** the following line is needed to record gender=2 into females
generate female = ( 0*(gender==0) + 1*(gender==1) + 1*(gender==2) ) if missing(gender)==0
tab1 female, missing
by female, sort : summarize age

by ever_preg, sort : tabulate times_been_pregnant
summarize numcycle if numcycle >0, detail


****************** RACE ******************************
tab1 race___1  race___2 race___3 race___4 race___5, nolabel
*all 2-way corss-tabs to find who checked off more than 1 category
tab2 race___1  race___2 race___3 race___4 race___5
*** two persons are Asian-White, or race2 and race5 *****
*** one person is AmerInd-Alaskan-White, or race1 and race5 *****
*** create variable to represent "multiple races" ***
generate race___6 = (  ((race___2 == 1)+(race___1 == 1))*(race___5 == 1) == 1  )
tab2 race___1 race___2 race___5 race___6

generate white = (race___5 == 1) * (race___6 < 1)
tab1 white

tab1 hispanic, missing
tab2 hispanic white, missing
tab2 hispanic race___3, missing
tab2 hispanic race___2, missing
tab2 hispanic race___1, missing
tab2 hispanic race___6, missing
tab2 hispanic race___4, missing
tab2 hispanic race___5, missing


generate whitenonhisp = (1*(race___5==1)*(race___6<1)*(hispanic==0)) + ((0*(hispanic==1))  + (0*(race___5<1)))
tab1 whitenonhisp, missing

************ we will want some data separated by PGT-a vs PGT-M for a manuscript **************
by PGTA_yn, sort : tab1 whitenonhisp female marital, missing
by PGTA_yn whitenonhisp, sort : tab1 race___1  race___2 race___3 race___4 hispanic, missing
by PGTA_yn female, sort : summarize age
by PGTA_yn, sort : tab1 educ numcycle, missing
by PGTA_yn, sort : summarize numcycle if numcycle >0, detail
 save "C:\Users\Lpastore\Documents\Ethics_PGTAvsM_2020\JiaMaxData_n207.dta"
** use variations of the code in the following line to identify the overlaps in the categories for Table 1 **
tab2 race___1 race___2 race___3 race___4 race___6 hispanic if ((whitenonhisp ==0) * (PGTA_yn==1))


************************ RELIGIOSITY ************************
by PGTA_yn, sort : tab1 religious_affiliation___1 religious_affiliation___2 religious_affiliation___3 religious_affiliation___4 religious_affiliation___5 religious_affiliation___6 religious_affiliation___7, missing
by PGTA_yn, sort : tab1 religious_affiliation_oth if (religious_affiliation___6 == 1) 


**************** assess if the dmeographic factors are statistically different by test considered ***
kwallis age if female==1, by(PGTA_yn)
kwallis numcycle if female==1, by(PGTA_yn)
kwallis numcycle if ((female==1)*(numcycle>0)), by(PGTA_yn)
tabulate whitenonhisp PGTA_yn, chi2
tabulate marital PGTA_yn, chi2 exact
generate married=(marital==2)
tabulate married PGTA_yn, chi2
tabulate educ PGTA_yn, chi2 exact


**************** make variable for religiosity that corresponds to prior ethics manuscript ************************
generate int relig = 1
replace relig = 2 if (religious_affiliation___3==1) + (religious_affiliation___6==1)
replace relig = 3 if (religious_affiliation___7==1 )
replace relig = 4 if (religious_affiliation___1==1) + (religious_affiliation___4==1) + (religious_affiliation___5==1)
tabulate relig

tabulate relig PGTA_yn, chi2 exact


   ************* obviously more similar rows for the above and below factors*******;

*** HERE   HERE   ************************

***************** MARKETING SOURCE ****************************
tabulate marketing, missing
* *** FIX CODE BELOW, BECAUSE THE RDM STUDY FOLKS HAVE DIFFERENT VARIABLES FOR THE MARKETING *********
generate mrkt1 = 3*(marketing==1)
generate mrkt2 = 3*(marketing==2)
generate mrkt3 = 3*(marketing==3)
generate mrkt5 = 6*(marketing==5)
generate mrkt6 = 6*(marketing==6)
generate mrkt8 = 8*(marketing==8)

generate marketing2 = mrkt1+mrkt2+mrkt3+mrkt5+mrkt6+mrkt8
tabulate marketing2

kwallis CONTINUOUSVAR1 if marketing2 >0, by(marketing2)

********************************************************************************************************
******************ETHICS PRIMARY RESULTS AND STRATIFIED ANALYSES ARE BELOW *****************************
********************************************************************************************************

by PGTA_yn, sort : tab1 eth_fatalchild eth_majordisab eth_adultwithtx eth_adultnotx eth_nondz_phys eth_nondz_mental eth_implantabnorm
by PGTA_yn, sort : tab1 eth_embryo_norm_dispos___1 eth_embryo_norm_dispos___2  eth_embryo_norm_dispos___3 eth_embryo_norm_dispos___4 
by PGTA_yn, sort : tab1 eth_embryo_abnorm_disp_new___1 eth_embryo_abnorm_disp_new___2 eth_embryo_abnorm_disp_new___3 eth_embryo_abnorm_disp_new___4
by PGTA_yn, sort : tab1 eth_stratrepro eth_unforeseenperson  eth_unforeseensociety eth_avoidtop eth_techimper eth_empower


tabulate eth_fatalchild PGTA_yn, chi2 exact
tabulate eth_majordisab PGTA_yn, chi2 exact
tabulate eth_adultwithtx PGTA_yn, chi2 exact
tabulate eth_adultnotx PGTA_yn, chi2 exact
tabulate eth_nondz_phys PGTA_yn, chi2 exact
tabulate eth_nondz_mental PGTA_yn, chi2 exact
tabulate eth_implantabnorm PGTA_yn, chi2 exact


tabulate eth_embryo_norm_dispos___1 PGTA_yn, chi2 exact
tabulate eth_embryo_norm_dispos___2 PGTA_yn, chi2 exact
tabulate eth_embryo_norm_dispos___3 PGTA_yn, chi2 exact
tabulate eth_embryo_norm_dispos___4 PGTA_yn, chi2 exact
tabulate eth_embryo_abnorm_disp_new___1 PGTA_yn, chi2 exact
tabulate eth_embryo_abnorm_disp_new___2 PGTA_yn, chi2 exact
tabulate eth_embryo_abnorm_disp_new___3 PGTA_yn, chi2 exact
tabulate eth_embryo_abnorm_disp_new___4 PGTA_yn, chi2 exact


tabulate eth_stratrepro PGTA_yn, chi2 exact
tabulate eth_unforeseenperson PGTA_yn, chi2 exact
tabulate eth_unforeseensociety PGTA_yn, chi2 exact
tabulate eth_avoidtop PGTA_yn, chi2 exact
tabulate eth_techimper PGTA_yn, chi2 exact
tabulate eth_nondz_mental PGTA_yn, chi2 exact
tabulate eth_empower PGTA_yn, chi2 exact



************************************
** potential coding lines below 
*************************************
pwcorr CONTINUOUSVAR1 hios_engage hios_appreh, sig
pwcorr CONTINUOUSVAR2  hios_engage hios_appreh, sig

ttest hios_engage == hios_appreh

ttest Distress_score_22, by(white) unequal
ttest CostBenUncertainty_score_5, by(white) unequal
ttest DecisUncertainty_score_7, by(white) unequal
ttest pgt_decison_spouse_partner, by(white) unequal



******************************************************
* Is there a difference in the responses of PGT-M considerers if they completed the PGT STudy or the RDM STudy?
* This was a question raised by one fo the reviewers
*************************************************************************

tabulate PGTA_yn study, miss
* keep PGT-M people only
keep if PGTA_yn ==0

tabulate eth_fatalchild study, chi2 exact
tabulate eth_majordisab study, chi2 exact
tabulate eth_adultwithtx study, chi2 exact
tabulate eth_adultnotx study, chi2 exact
tabulate eth_nondz_phys study, chi2 exact
tabulate eth_nondz_mental study, chi2 exact
tabulate eth_implantabnorm study, chi2 exact


tabulate eth_embryo_norm_dispos___1 study, chi2 exact
tabulate eth_embryo_norm_dispos___2 study, chi2 exact
tabulate eth_embryo_norm_dispos___3 study, chi2 exact
tabulate eth_embryo_norm_dispos___4 study, chi2 exact
tabulate eth_embryo_abnorm_disp_new___1 study, chi2 exact
tabulate eth_embryo_abnorm_disp_new___2 study, chi2 exact
tabulate eth_embryo_abnorm_disp_new___3 study, chi2 exact
tabulate eth_embryo_abnorm_disp_new___4 study, chi2 exact


tabulate eth_stratrepro study, chi2 exact
tabulate eth_unforeseenperson study, chi2 exact
tabulate eth_unforeseensociety study, chi2 exact
tabulate eth_avoidtop study, chi2 exact
tabulate eth_techimper study, chi2 exact
tabulate eth_nondz_mental study, chi2 exact
tabulate eth_empower study, chi2 exact



***************************************
*** potential coding lines below for stratification by other variables
***************************************
kwallis Distress_score_22, by(whereinprocess)
kwallis Distress_score_22, by(age)
kwallis Distress_score_22, by(insur_ny)
kwallis Distress_score_22, by(educ)
kwallis Distress_score_22, by(ever_preg)
kwallis Distress_score_22, by(marketing)
kwallis Distress_score_22, by(reason4testing___1)
kwallis Distress_score_22, by(reason4testing___2)
kwallis Distress_score_22, by(reason4testing___3)
kwallis Distress_score_22, by(reason4testing___4)
kwallis Distress_score_22, by(reason4testing___5)
kwallis Distress_score_22, by(reason4testing___6)
kwallis Distress_score_22, by(reason4testing___7)
kwallis Distress_score_22, by(reason4testing___8)
kwallis Distress_score_22, by(reason4testing___9)
kwallis Distress_score_22, by(gender)
