

			* import the birth records file for this part of the index
			use "C:\Users\moumi\Desktop\internship(undp)\Africa (DHS)\(1) DHS (base dataset)\Burkina Faso\BFBR31DT\BFBR31FL.dta", clear

			* generating variables for regression

			gen urban = 1 if v025 == 1
			replace urban = 0 if urban == .
			lab var urban "Urban = 1"

			gen sex_fem_hh = 1 if v151 == 2
			replace sex_fem_hh = 0 if sex_fem_hh == .
			lab var sex_fem_hh "female headed hh = 1"

			gen size_hh = v136
			lab var size_hh "total num of member: hh size"

			gen want_child = 1 if v602 == 1
			replace want_child = 0 if v602 >=2
			lab var want_child "Mother want's another child"

			gen catholic = 1 if v130 ==1
			replace catholic = 0 if catholic ==.
			lab var catholic "Mother is catholic"

			gen literate = 1 if v108 <=2
			replace literate = 0 if v108 ==3
			lav var literate "Mother is literate"

			gen primary = 1 if v106>=1
			replace primary = 0 if primary == .
			lab var primary "Mother has primary education"

			gen married = 1 if v502 == 1
			replace married = 0 if v502 ==.
			lab var married "Mother currently married"

			gen tet_inj = 1 if m1 >=1
			replace tet_inj = 0 if tet_inj==.
			lab var tet_inj "Mother got Tetanus injection"

			gen delivery = .
			replace  delivery = 1 if m3a==1
			replace  delivery = 1 if m3b==1
			replace  delivery = 1 if m3c==1
			replace  delivery = 1 if m3d==1
			replace  delivery = 1 if m3e==1
			replace  delivery = 1 if m3f==1
			replace  delivery = 0 if m3h==1
			replace  delivery = 0 if m3i==1
			replace  delivery = 0 if m3j==1
			replace  delivery = 0 if m3k==1
			replace  delivery = 0 if m3l==1
			replace  delivery = 0 if m3m==1
			replace  delivery = 0 if m3n==1
			replace  delivery = 0 if m3g==1
			lab var delivery "Professional assistance during delivery"

			* v218 -- num of children in the hh
			* v012 -- age of mother
			* v201 -- total children ever born
			* v213 -- currently pregnant 
			* v404 -- currently breastfeeding
			* v714 -- respondent currently working
			
			gen urban_age = urban*v012
			gen urban_fhh = urban*sex_fem_hh
			gen sex_age = b4*v012
			
			* cluster mean literacy
			egen lit_clus = mean( literate ), by(v001)
			
			* cluster mean primary education
			egen prim_clus = mean( primary ), by(v001)

	
	local HazardModelList "urban sex_fem_hh size_hh want_child catholic literate primary married tet_inj delivery v218 v012 v213 v404 v714 urban*v012 urban*sex_fem_hh sex_age lit_clus prim_clus"
			

			
			* Discrete time hazard model
			* following code follows from
			* https://www.iser.essex.ac.uk/resources/survival-analysis-with-stata
			* Turtorials by Stephen Jenkins

	* Droping who died after 5 years of age
	drop if (b7>=60 & b5==0)
	
	* generating the age variable
	gen age = b7
	replace age = b8*12 if age==.
	
	* gererating unique ID for each child
	ge id = _n
	
	* exapnading the age variable to create the "unbalanced panel structure"
	expand age
	
	* generating the dependant variable for analysis
	sort id
	bysort id: ge dead = b5==0 & _n==_N
	lab var dead "binary depvar for discrete hazard model"
	
	bysort id: ge j = _n
	lab var j "spell month"
	
	* generating dummy variables for the piecewise constant baseline hazard funciton
	ge e1 = j <= 6
	ge e2 = j >= 7 & j <= 12
	ge e3 = j >= 13 & j <=18
	ge e4 = j >= 19 & j <=24
	ge e5 = j >= 13 & j <=29
	ge e6 = j >= 30 & j <= 35
	ge e7 = j >= 36 

	* Discrete time proportional hazard model
	cloglog dead urban sex_fem_hh size_hh want_child catholic literate primary married tet_inj delivery v218 v012 v213 v404 v714 urban_age urban_fhh sex_age lit_clus prim_clus
	
	* Withinsample prediction
	
