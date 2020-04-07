
20200407

Eq 1-4 from the paper are implemnted in ~\R\B_Kin-Cohort_Analysis.R

=====
Eq 1 (OD) implementeded in: 
~\R\B_Kin-Cohort_Analysis\4 - CD_cumulative_number.R, 
Implemented in function expected_child_death(), which is called from  child_loss()

=====
Eq 2 age-specific probability that an average woman will experience the death of a child (〖(_1^)q〗_((a,c))^k)
where h(a,c)=〖OD〗_((a+1,c))^k- 〖OD〗_((a,c))^k is the hazard rate of experiencing the death of a child younger than k

This is implementeded in function offspring_death_prevalence(), where
nqx_od = 1 - exp(-diff) is Eq 2

=====
Eq 3 
The proportion of women (per 1,000 mothers) who have ever lost one or more children younger than k 
is implementeded in function offspring_death_prevalence(), where

bereaved_women = (1 - qx2lx(nqx = nqx_od, radix = 1)) * lx_scaled * 1000


=====
Eq 4 (mOM - women to mothers) implementeded in:
~\R\B_Kin-Cohort_Analysis\7 - mOM_mU5M_mIM.R, function offspring_death_prevalence()