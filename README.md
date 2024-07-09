# BaseMM

## To Do

Remove dollar conversions using symbols.
Remove unused type constants.
Consolidate with DirectoriesMM.
Move all constants here (those that are used for data or CollegeMM)

Move to FilesLH
- copy_file


## Change Log 2024

July 9
- replaced Formatting.jl

## Change Log 2023

Oct-2 (v1.5)
- added ClassLastType
Aug-12 (v1.4)
- removed symbol based time conversions and dollar conversions
- removed `dollars_to_data_units`
- removed `check_dollar_values` with `Bool` argument
- added AbstractClassifications
Aug-11
- added `add_array_to_df!`
Aug-8 (v1.3)
- converted from CollegeStratBase
- removed course conversions
- added contents of DirectoriesMM
Jun-26 (v1.2)
- deps updated
May-10
- ModelDollars and DataDollars as types (v1.2)
Mar-9
- const FigExtension
Mar-3
- in place conversion of dollars data / model
- added `AbstractTimeUnit` for efficient dispatch.

-----------------