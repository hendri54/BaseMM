"""
	$(SIGNATURES)

This is used to list settings for nested `ModelObject`s.
"""
settings_table(x) = Matrix{String}(undef, 0, 0);

"""
	$(SIGNATURES)

This is used to write literals from nested objects into preambles. Objects return `Vector{Vector{String}}` or `Vector{Tuple}`. Each entry contains (description, newcommand name, value).
"""
settings_list(x, st) = Vector{Vector{String}}();



"""
$(SIGNATURES)

Display current time and date as "2020-Jan-10 at 10:35am".
"""
function current_time()
    x = Dates.now();
    return Dates.format(x, "Y-u-d") * " at " * Dates.format(x, "HH:MM")
end


# Given a vector of things that can be converted to string, return a string of the form "abc_def_dhi" with connector character `linkChar`
chain_strings(v :: AbstractVector{T}, linkStr = "_") where T = 
    join(v, linkStr);

chain_strings(v :: AbstractString, linkStr = "_") = v;


"""
$(SIGNATURES)

Show a text table.
"""
function show_text_table(tbM; io = stdout)
    pretty_table(io, tbM, noheader = true);
    return nothing
end


function show_text_table(tbM, headerV, fPath :: T1) where T1 <: AbstractString
    open(fPath, "w") do io
        pretty_table(io,  tbM,  headerV);
        println("Saved  $(fpath_to_show(fPath))")
    end
end


function show_matrix(io :: IO, m :: Matrix{F1}, 
ndigits :: Integer) where F1 <: AbstractFloat

    nr, nc = size(m);
    for ir = 1 : nr
        for ic = 1 : nc
            print(io, round(m[ir, ic], digits = ndigits), "\t");
        end
        println(io, " ");
    end
    println(io, " ");
end


## --------------  Format numbers

"""
$(SIGNATURES)

Format a vector of numbers with a header. Output is a string.
"""
function format_vector(headerStr, numberV, nDigits :: Integer)
    roundV = round.(numberV, digits = nDigits);
    if isempty(headerStr)
        return "$roundV"
    else
        return headerStr * ":  $roundV"
    end
end


## Format a single number in easy to read format.
function format_number(x :: Number; format :: Symbol = :default)
    if format == :dollars
        return format_dollars(x);
    elseif format == :default
        return format_number_default(x);
    elseif format == :none
        return string(x);
    else
        error("Invalid format: $format")
    end
end

format_number(x :: Missing; format :: Symbol = :default) = "na";
# format_number(x :: NaN; format :: Symbol = :default) = "NaN";

## Format a number for display in a table
function format_number_default(x :: Number)
    absX = abs(x);
    if isnan(x)
        y = "NaN";
    elseif absX > 1e3
        y = format(x, precision = 1, commas = true);
    elseif absX > 1
        y = format(x, precision = 2, commas = false);
    elseif absX > 0.1
        y = format(x, precision = 3, commas = false);
    elseif absX > 0.01
        y = format(x, precision = 4);
    else
        y = format(x, precision = 6);
    end
    return y
end


## Format a dollar number
function format_dollars(x; decimals = 0)
    format(x, precision = decimals, commas = true);
end

function format_model_dollars(x :: Number; decimals = 0)
    format_dollars(m2d(x); decimals)
end

"""
	$(SIGNATURES)

Format a vector of model dollars to show data dollar amounts. Output is a single string.
"""
function format_model_dollars(x :: AbstractVector; decimals = 0)
    return join(map(d -> format_model_dollars(d; decimals), x), " | ")
end


# Show a file name with `n` last directories
function fpath_to_show(fPath :: String; nDirs :: Integer = 3)
    fDir, fName = splitdir(fPath);
    s = right_dirs(fDir, nDirs) * " - " * fName;
    return s
end


# # Display calibrated if true and fixed if false
# function calibrated_string(isCal :: Bool; fixedValue = nothing) 
#     if isCal
#         x = "calibrated"
#     else
#         if isnothing(fixedValue)
#             valStr = "fixed";
#         else
#             valStr = "fixed at $fixedValue";
#         end
#     end
#     return x
# end

# function calibrated_string(p :: Param)
#     calibrated_string(is_calibrated(p); fixedValue = default_value(p));
# end

# function calibrated_string(pv :: ParamVector, vName :: Symbol)
#     calibrated_string(retrieve(pv, vName));
# end

# StructLH.describe(switches :: ModelSwitches) = 

# --------------