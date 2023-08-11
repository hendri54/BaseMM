# Time units
export AbstractTimeUnit, TuYear, TuMonth, TuWeek, TuDay, TuHour;
export time_factor;


## --------------  Endowments
# One model time unit is `hoursPerWeek = 112` data hours per week.
# This is also the time endowment.

# 7 * 16 hours per week
const weeksPerYear = 52
const daysPerYear = 365
const hoursPerWeek = 112
const hoursPerYear = hoursPerWeek * weeksPerYear;


abstract type AbstractTimeUnit end;
struct TuYear <: AbstractTimeUnit end;
struct TuMonth <: AbstractTimeUnit end;
struct TuWeek <: AbstractTimeUnit end;
struct TuDay <: AbstractTimeUnit end;
struct TuHour <: AbstractTimeUnit end;

# Multiply dollar values by this factor to make it annual
time_factor(::TuYear) = 1;
time_factor(::TuMonth) = 12;
time_factor(::TuWeek) = weeksPerYear;
time_factor(::TuDay) = daysPerYear;
time_factor(::TuHour) = hoursPerYear;
    


## ------------  Convert data to model time units

# Convert model time units into hours per week
function mtu_to_hours_per_week(mtu)
    hoursPerWeek .* mtu;
end

function hours_per_week_to_mtu(hours)
    return hours ./ hoursPerWeek;
end

function time_factor(timeUnit :: Symbol)
    if timeUnit == :weeksPerYear
        tf = weeksPerYear;
    elseif timeUnit == :daysPerYear
        tf = daysPerYear;
    elseif timeUnit == :hoursPerYear
        tf = hoursPerYear;
    elseif timeUnit == :hoursPerWeek
        tf = hoursPerWeek;
    else
        error("Invalid timeUnit: $timeUnit")
    end
    return tf
end


"""
	$(SIGNATURES)

Convert arbitrary data hours into model time units.
"""
function hours_data_to_mtu(hours, timeUnit)
    tf = time_factor(timeUnit);
    return hours ./ tf
end

function hours_mtu_to_data(hours, timeUnit)
    tf = time_factor(timeUnit);
    return hours .* tf
end

"""
	$(SIGNATURES)

Convert hours per year to hours per week.
"""
per_year_to_per_week(hours) = 
    hours ./ weeksPerYear;


## -------------  Validate model time units

"""
	$(SIGNATURES)

Validate model time units
"""
function validate_mtu(mtu)
    if any(mtu .< 0.0)  ||  any(mtu .> 1.0)
        error("""
            Invalid time input: 
            $mtu
        """);
    end
    return nothing
end


## --------------  Money units

abstract type AbstractDollars end
struct DataDollars{TU} <: AbstractDollars end
struct ModelDollars{TU} <: AbstractDollars end

const MDollars = ModelDollars{TuYear};
const DDollars = DataDollars{TuYear};



# -----------
