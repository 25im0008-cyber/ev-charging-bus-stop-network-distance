# EV Charging Station–Bus Stop Network Distance

## Overview

This project develops an R-based approach to measure road-network accessibility between electric vehicle (EV) charging stations and bus stops in Telangana, India.

Instead of using straight-line distance, the analysis uses road-network distances obtained through OSRM (Open Source Routing Machine), providing a more realistic representation of accessibility through the existing road network.

## Objective

The objective is to estimate network distances between EV charging stations and bus stops and use these measures to understand the accessibility of charging infrastructure to public transport facilities.

## Methodology

1. Load EV charging station and bus stop coordinate data.
2. Check and clean latitude and longitude values.
3. Remove records with missing coordinates.
4. Divide charging stations and bus stops into smaller batches.
5. Calculate road-network distances using OSRM.
6. Store the resulting distance matrix.
7. Save the processed distance information as a CSV file.

## Tools Used

- R
- OSRM (Open Source Routing Machine)
- `osrm` R package
- CSV data
- Road-network distance analysis

## Key Implementation Decision

The analysis uses road-network distance instead of Euclidean (straight-line) distance because road distance better represents actual accessibility between charging stations and bus stops.

The calculations are also performed in smaller batches to make the process manageable when working with a large number of origin-destination pairs.

## Files

- `Network_Dist_New.R` — R script used for the network-distance analysis.

## Application

This analysis can support transportation planning and EV infrastructure research by providing a network-based measure of the relationship between charging infrastructure and public transport accessibility.
