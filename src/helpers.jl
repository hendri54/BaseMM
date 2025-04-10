# Generating reproducible random numbers
CustomRNG(seed) = StableRNG(seed);

# """
# 	$(SIGNATURES)

# Class from percentile upper bounds.
# This must be fast!
# """
# function class_from_pct(pct :: Number, pctUbV)
#     pClass = discretize_from_ub(pct,  pctUbV);
#     if dbgHigh
#         @assert (0.0 <= pct <= 1.0);
#         @assert (1 <= pClass <= length(pctUbV));
#     end
#     return pClass
# end


function all_approx(xM :: AbstractArray, xTg :: Number; tol = 1e-4)
    return all(x -> abs(x - xTg) <= tol, xM)
end


"""
	$(SIGNATURES)

Convert Array to DataFrame. Index columns are categorical.
Columns for `grpVars` just contain integers.
"""
function array_to_df(m :: AbstractArray{T,N}, grpVars; 
        labelV = var_labels(grpVars), yStr = "Data") where {T, N}
    df = DataFrame(yStr => vec(m));
    if N == 1
        labelV = [labelV];
    end
    @assert labelV isa AbstractVector;
    @assert length(labelV) == N;
    for iDim = 1 : N
        vn = labelV[iDim];
        idxM = idx_array(iDim, size(m));
        df[!, vn] = categorical(vec(idxM));
    end
    return df
end

"""
	$(SIGNATURES)

Add a Matrix to a DataFrame that has one row for each combination of the variables in `labelV` (presumably created by `array_to_df`).
This adds a new variable to `df`. It does not add columns.
"""
function add_array_to_df!(df :: AbstractDataFrame, m :: AbstractArray, grpVars;
        labelV = nothing, yStr = "Data")
    if isnothing(labelV)
        labelV = var_labels(grpVars);
    end
    @assert !hasproperty(df, yStr);
    df2 = array_to_df(m, grpVars; labelV, yStr);
    leftjoin!(df, df2; on = labelV);
end


"""
Create an array such that vec(idxM) matches the indices that go with 
vec(m) for any array m.
Test: implicit in test of matrix_to_df_data_model.
"""
function idx_array(iDim, sizeV)
    idxM = ones(Int, sizeV);
    n = sizeV[iDim];
    for j = 1 : n
        selectdim(idxM, iDim, j) .= j;
    end
    return idxM
end


"""
Convert a DataFrame into a matrix.
"""
function df_to_matrix(df, xVar, yVar, valueVar)
    xV = unique(df[!, xVar]);
    yV = unique(df[!, yVar]);
    nx = length(xV);
    ny = length(yV);
    T = eltype(df[!, valueVar]);
    m = Array{Union{T,Missing}}(missing, nx, ny);
    for dfRow in eachrow(df)
        # Get the indices for x and y
        xIdx = findfirst(x -> x == getproperty(dfRow, xVar), xV);
        yIdx = findfirst(y -> y == getproperty(dfRow, yVar), yV);
        if !isnothing(xIdx) && !isnothing(yIdx)
            m[xIdx, yIdx] = getproperty(dfRow, valueVar);
        end
    end
    if !any(ismissing.(m))
        m = Matrix{T}(m);
    end
    return m, xV, yV
end



"""
	$(SIGNATURES)

Copy a file, given by a relative path, from `srcDir` to `tgDir`.
Make `tgDir` if needed.
"""
function copy_file(fPath :: AbstractString, srcDir :: AbstractString, tgDir)
    srcPath = joinpath(srcDir, fPath);
    tgPath = joinpath(tgDir, fPath);
    if isfile(srcPath)
        make_dir(tgPath);
        cp(srcPath, tgPath; force = true);
    else
        @warn "Source file not found: $fPath"
    end
end



"""
	$(SIGNATURES)

Present value factor. Converts a constant stream into a present value.
First payoff is not discounted.
"""
pv_factor(R, T) = (((1/R) ^ T) - 1) / (1/R - 1);

"""
	$(SIGNATURES)

Present value of a stream. First entry not discounted.
"""
function present_value(xV, R)
    F = eltype(xV);
    pv = zero(F);
    discFactor = one(F);
    for x in xV
        pv += x / discFactor;
        discFactor *= R;
    end
    return pv
end


# Save anything that can be `print`ed to a text file.
function save_text_file(fPath, txtV :: AbstractVector; io = nothing)
    open(fPath, "w") do ioWrite
        for txt in txtV
            println(ioWrite, txt);
        end
    end
    showPath = fpath_to_show(fPath);
    isnothing(io)  ||  println(io, "Saved  $showPath");
end


"""
	$(SIGNATURES)

Legend for data versus model.
Small so that it does not cover graph.        
"""
data_model_labels() = ["D" "M"];


# Points to MismatchMM dir
pkg_dir() = normpath(joinpath(@__DIR__, ".."));

# For test files created by this package only.
test_file_dir() = joinpath(pkg_dir(), "test_files");


# ----------------