# Child Mortality Survival Analysis Using DHS Data

This repository contains Stata code for analysing **under-five mortality using Demographic and Health Survey (DHS) birth-history data**.

The analysis constructs child-level survival histories from DHS birth records and estimates a **discrete-time proportional hazard model** to examine how household, maternal, demographic, and healthcare characteristics are associated with mortality during the first five years of life.

## Research Objective

The purpose of the analysis is to examine variation in the risk of child mortality according to characteristics of the child, mother, household, and community.

The workflow demonstrates how DHS birth-history data can be transformed from child-level records into a **person-period dataset** suitable for discrete-time survival analysis.

## Data

The analysis uses a DHS **Birth Recode (BR)** file.

Relevant DHS variables used in the code include information on:

- child's survival status and age
- sex of the child
- mother's age
- mother's education and literacy
- household size
- urban/rural residence
- sex of household head
- mother's marital status
- fertility preferences
- pregnancy and breastfeeding status
- mother's employment
- tetanus vaccination
- assistance during delivery
- number of children
- religion
- survey cluster

> DHS microdata are not included in this repository. Access to DHS datasets must be requested separately through the DHS Program.

## Data Preparation

### 1. Construct household and maternal characteristics

The Stata workflow constructs a set of demographic, socioeconomic, and maternal-health variables from the original DHS variables.

Examples include:

- urban residence
- female-headed household
- household size
- mother's fertility preferences
- mother's literacy
- primary education
- marital status
- maternal employment
- current pregnancy
- breastfeeding status
- tetanus vaccination
- professional assistance during delivery

These variables are subsequently included as covariates in the child-mortality model.

### 2. Construct community-level characteristics

The analysis also creates cluster-level measures using DHS sampling clusters.

For example, the code calculates:

- cluster mean literacy
- cluster mean primary education

These measures provide information on the broader socioeconomic environment surrounding the household.

### 3. Construct interaction terms

Several interaction variables are generated to examine whether associations differ across demographic and household characteristics.

Examples include interactions between:

- urban residence and maternal age
- urban residence and female-headed households
- child's sex and maternal age

## Survival Analysis

The main analysis uses a **discrete-time hazard model**.

Children who survive beyond five years are excluded from the under-five mortality risk period used in this analysis.

The code first constructs the child's observed age in months using DHS birth-history variables.

A unique identifier is then assigned to each child.

### Creating the person-period dataset

The child-level dataset is expanded so that each child contributes one observation for each month that the child is observed.

The resulting structure can be represented as:

`Child-level DHS birth record`

↓

`Determine survival duration in months`

↓

`Expand each child into child-month observations`

↓

`Construct monthly mortality indicator`

↓

`Estimate discrete-time hazard model`

This produces an **unbalanced child-month panel**, where children contribute different numbers of observations depending on their survival duration.

## Mortality Outcome

A binary variable (`dead`) identifies whether death occurs during a particular child-month.

For children who die during the observation period, the mortality indicator equals one in the final observed month.

For preceding months, the indicator equals zero.

This structure allows the probability of mortality to be modelled conditional on the child having survived to the beginning of each period.

## Baseline Hazard

The code constructs duration indicators (`e1`–`e7`) intended to represent intervals of the child's age and allow the underlying mortality hazard to vary over time.

The intervals distinguish different periods of early childhood, including:

- 0–6 months
- 7–12 months
- 13–18 months
- 19–24 months
- later childhood periods

These variables can be used to specify a **piecewise-constant baseline hazard** rather than assuming that mortality risk remains constant throughout the first five years of life.

## Discrete-Time Proportional Hazard Model

The mortality model is estimated using Stata's complementary log-log (`cloglog`) regression.

The general specification is:

`cloglog(mortality) = f(child characteristics, maternal characteristics, household characteristics, healthcare variables, community characteristics)`

The complementary log-log specification is commonly used for discrete-time representations of proportional hazard models.

Covariates in the code include measures related to:

### Child characteristics
- sex
- age/survival duration

### Maternal characteristics
- age
- literacy
- education
- marital status
- fertility preferences
- employment
- pregnancy status
- breastfeeding status

### Maternal healthcare
- tetanus vaccination
- professional assistance during delivery

### Household characteristics
- urban residence
- household size
- female-headed household
- number of children

### Community characteristics
- cluster-level literacy
- cluster-level primary education

The specification also includes selected interaction terms.

## Tools

- **Stata** — data preparation and survival analysis
- **DHS Birth Recode data** — child birth histories, mortality, maternal and household characteristics

## Methodological Reference

The discrete-time survival-analysis workflow was developed following Stephen Jenkins' **Survival Analysis with Stata** materials from the Institute for Social and Economic Research (ISER), University of Essex.

