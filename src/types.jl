
const Double = Float64
# For no of courses
const ncInt = UInt8
# For time variables
const TimeInt = Int
# For indexing types
const TypeInt = Int
# For indexing colleges
const CollInt = Int
# For indexing school levels
const SchoolInt = Int
# For indexing grid points
const GridInt = UInt16

abstract type AbstractModelDataUnits end;
struct ModelUnits <: AbstractModelDataUnits end;
struct DataUnits <: AbstractModelDataUnits end;

# ------------