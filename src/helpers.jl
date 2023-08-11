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


"""
	$(SIGNATURES)

Convert Array to DataFrame. Index columns are categorical.
"""
function array_to_df(m :: AbstractArray{T,N}, grpVars; 
        labelV = var_labels(grpVars), yStr = "Data") where {T, N}
    df = DataFrame(yStr => vec(m));
    if N == 1
        labelV = [labelV];
    end
    for iDim = 1 : N
        vn = labelV[iDim];
        idxM = idx_array(iDim, size(m));
        df[!, vn] = categorical(vec(idxM));
    end
    return df
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