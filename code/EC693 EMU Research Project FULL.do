gen quarterly = quarterly(date, "YQ" )
format quarterly %tq
*Formats date variable to a form statacan read for graphs

twoway(line austria_spread quarterly) (line belgium_spread quarterly) 
(line finland_spread quarterly) (line france_spread quarterly) 
(line greece_spread quarterly) (line irelandspread quarterly) 
(line italy_spread quarterly) (line netherlands_spread quarterly) 
(line portugal_spread quarterly) (line spain_spread quarterly)
,ytitle("Basis Point Spread") 
title("EMU 10 Year Bond Yield Spread Against Germany")
*the above command created my yield spread graph with ytitle and graph title.

twoway(line austriaexpectedbudgetbalance quarterly), xtitle("Time") saving(austria)
twoway(line belgiumexpectedbudgetbalance quarterly), xtitle("Time") saving(belgium)
twoway(line finlandexpectedbudgetbalance quarterly), xtitle("Time") saving(Finalnd)
twoway(line franceexpectedbudgetbalance quarterly), xtitle("Time") saving(France)
twoway(line greeceexpectedbudgetbalance quarterly), xtitle("Time") saving(Greece)
twoway(line irelandexpectedbudgetbalance quarterly), xtitle("Time") saving(Ireland)
twoway(line italyexpectedbudgetbalance quarterly), xtitle("Time") saving(Italy)
twoway(line netherlandsexpectedbudgetbalance quarterly), xtitle("Time") saving(Netherlands)
twoway(line portugalexpectedbudgetbalance quarterly), xtitle("Time") saving(Portugal)
twoway(line spainexpectedbudgetbalance quarterly), xtitle("Time") saving(Spain)
*expected budget balance graph whcih will be combined into a larger single image.

label variable finlandexpectedbudgetbalance "Finland Expected Budget"
label variable portugalexpectedbudgetbalance "Portugal Expected Budget"
label variable austriaexpectedbudgetbalance "Austria Expected Budget"
label variable netherlandsexpectedbudgetbalance "Netherlands Expected Budget"
label variable italyexpectedbudgetbalance "Italy Expected Budget"
label variable irelandexpectedbudgetbalance "Ireland Expected Budget"
label variable spainexpectedbudgetbalance "Spain Expected Budget"
label variable greeceexpectedbudgetbalance "Greece Expected Budget"
label variable belgiumexpectedbudgetbalance "Belgium Expected Budget"
label variable franceexpectedbudgetbalance "France Expected Budget"
*Changed labels of variables b/c they were too long and overlapped on combined 
*graph.

graph combine austria.gph belgium.gph Finalnd.gph france.gph Greece.gph 
Ireland.gph Italy.gph Netherlands.gph Portugal.gph Spain.gph, cols(3)
*Combines the several graphs generated prior into one image

twoway line German quarterly, yaxis(2) yscale(range(0) axis(2)) || 
line logvix quarterly, yaxis(1) yscale(range(0) axis(1))
**********************Important. One graph with formatting a twoway graph with 
*different scaled y axes. German bond yield was on yaxis(2) and logvix was on
*yaxis(1). Each y axis has its own range. Good when checking cointegration.****



xtset cntry quarterly
*xtset sets your panel data so stata knows your using panel data.

*******************************************************************************
xtgls yield_spread lagged_yield_spread expected_budget_balance expected_debt_gdp
vix liquidity, panels(heteroskedastic)

eststo m1
*The first command xtgls is a panel(hence xt) generalized least squares 
*regression. The option at the end tells stata there is heteroskedasticity in 
*the erros. 
*eststo m1 tells stata to save your regression for further latex output.

********************************************************************************
xtgls yield_spread lagged_yield_spread expected_budget_balance expected_debt_gdp
 vix liquidity crisisaustria crisisbelgium crisisfinland crisisfrance 
 crisisgreece crisisireland crisisitaly crisisnetherlands crisisportugal 
 bailoutdummy crisis_euro crisis_liq crisis_exp_budget_balance 
 crisis_expected_debt_gdp crisis_vix , panels(heteroskedastic)
 
eststo m2
*The first command xtgls is a panel(hence xt) generalized least squares 
*regression. The option at the end tells stata there is heteroskedasticity in 
*the erros. 
*eststo m2 tells stata to save your regression for further latex output.
*******************************************************************************

esttab m1 m2 using stataresultstable.tex, replace
*This command combines the saved regressions above and saves it as a .tex on your
*******************************************************************************
*ROBUSTNESS TESTING
xtgls yield_spread lagged_yield_spread expected_budget_balance expected_debt_gdp vix liquidity austria_dummy belgium_dummy finland_dummy france_dummy greeece_dummy ireland_dummy italy_dummy netherlands_dummy portugal_dummy spain_dummy ,panel(heteroskedastic)
 vix liquidity belgium_dummy finland_dummy france_dummy greeece_dummy ireland_dummy
 italy_dummy netherlands_dummy portugal_dummy spain_dummy ,panel(heteroskedastic)
*checking to see if I still get the same significance when I shorten the time
*to 2003Q1 until 2006Q4, which I shouldnt. The reason for the robustness test is
*to confirm that I get different results when changing the time period which
*I did. For example coutnry dummies on their own had no effect when data included
*crisis period. When we test them for time period 2003Q1 to 2006Q4 we find they
*are significant.

eststo m11
