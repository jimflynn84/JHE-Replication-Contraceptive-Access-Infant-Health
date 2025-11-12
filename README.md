# JHE-Replication-Contraceptive-Access-Infant-Health
Replication package for "Contraceptive Access and Infant Health Outcomes"

Overview - The code in this replication package provides instructions for replicating all the tables and figures included in Flynn (2025) using Stata and R. All Tables and Figures require obtaining restricted-use vital records from the National Center for Health Statistics, as outlined below, but can be replicated with the code provided once users have obtained these data. I provide instructions for requesting these data below.
Data Availability and Provenance Statements

Summary of Availability - Data cannot be made publicly available. 

Data Source - NCHS linked cohort birth and infant death records, 2002–2013. 

(CDC, 2002-2013). Data are restricted use. To request these data, follow the instructions available at: https://www.cdc.gov/nchs/nvss/nvss-restricted-data.htm. I obtained: “Linked Births/ Infant Deaths” for 2002 to 2013. Code to prepare the data after obtaining it are included in “01_raw_data_clean” and must be moved to the data folder and followed precisely to replicate all tables & figures that use deaths data. Details are available upon request from the corresponding author (flynnj@miamioh.edu). 
		
		
Computational requirements
Software Requirements
Stata (version 19) - reghdfe, sdid and synth (last run 11-08-2025)
R (version 4.3.1) - tidyverse, usmap, tidycensus, ggplot2, ggthemes (last run 11-11-2025)

Description of programs/code
•	Programs are provided in the main folder in the replication kit. The programs should be ran in the order they appear.
•	The plots/ directory store results figures.
•	The tables/ directory stores tables. 

References

Centers for Disease Control and Prevention (CDC), National Vital Statistics System. 2002-2013. "Linked Births \ Infant Deaths." National Center for Health Statistics. https://www.cdc.gov/nchs/nvss/nvss-restricted-data.htm   
________________________________________
Acknowledgements
I used a template read me maintained at: https://social-science-data-editors.github.io/template_README/, created by authors Lars Vilhuber, Miklos Kóren, Joan Llull, Marie Connolly, Peter Morrow. 
