# Constants
export FigExtension;
export N2year, parentalUbV, hsGpaUbV;
export DataAfqtVar, DataSchoolVar, DataParentalVar;
export LblUp, LblDown, LblNoChange;

const N2year = 1;

# AFQT and parental class bounds (must match data)
const hsGpaUbV = 0.25 : 0.25 : 1.0;
const parentalUbV = 0.25 : 0.25 : 1.0;

# For ClassUpDown
const LblUp = "Up";
const LblDown = "Down";
const LblNoChange = "No change";

## -----------  Data constants

const DataAfqtVar = :afqt;
const DataSchoolVar = :school;
const DataParentalVar = :parental;
# const DataQualityVar = :last_type;


## --------------  Debugging

const dbgLow = true
const dbgMedium = true
const dbgHigh = true


## ------------  Symbols

# Name of the constant term in regressions
const RegrIntercept = :cons


## ------------  Figures

const FigExtension = "pdf";

# ------------