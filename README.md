# imprs-sailing

## Project: Quantifying the added value and rate of improvement of underway pCO2 data from sailboats

1) Application of SOM-FFN method on SOCAT data with and without sailing data to quantify changes in air-sea CO2 flux
2) Do the sailing data result in a reduction of the air-sea CO2 flux uncertainty?
3) Effect of small-scale ocean features on air-sea CO2 exchange

The codes in this project handle observational pCO2 data measured by sailing boats from 2018 until 2021 as well as pCO2 observations from the SOCAT database (https://www.socat.info/index.php/data-access/, Bakker et al., 2016), in which the sailing data are included. 
The (in time and space heterogenous) pCO2 observations are used to reconstruct homogenous pCO2 maps (Landschützer et al., 2014), which are then used to estimate the air-sea CO2 flux based on a standard bulk parametrization (Wanninkhof et al., 1992).

# How to reconstruct basin-wide pCO2 maps from observations - SOM-FFN:
The pCO2 data and also other data (environmental driver variables, prognostic proxies), that drive changes in pCO2, are prepared for the SOM-FFN method (Landschützer et al., 2014), a two-step neural network mapping approach to reconstruct basin-wide monthly maps of the sea surface partial pressure of CO2 (pCO2) flux at a resolution of 1° × 1°.
The SOM-based clustering identifies biogeochemical biomes/provinces/cluster based on common patterns in environmental variables such as SST, SSS, MLD etc., that drive observed changes in pCO2.
The FFN establishes non-linear relationships between the environmental drivers and all available pCO2 observations within each biome/SOM-cluster. It takes these relationships to estimate all missing pCO2 observations within each biome/SOM cluster.

# Project Structure
- PREP: Preparation (load/read data, regridding) (prepared data are then stored)
- v2021: SOM-FFN & flux calculation
- plotting, selecting ocean regions
