## -----------  School types

export LblHSG, LblSC, LblCG, SymHSG, SymSC, SymCG, IdxHSG, IdxSC, IdxCG;
export is_dropout, is_graduate;

const SymHSG = :HSG;
const SymSC = :SC;
const SymCG = :CG;

const LblCG = "CG";
const LblSC = "SC";
const LblHSG = "HSG";

const IdxHSG = 1;
const IdxSC = 2;
const IdxCG = 3;

abstract type AbstractSchoolGroups{I1 <: Integer} end

# Map :HSG => 1 etc
function ed_idx(s :: AbstractSchoolGroups{I1}, ed :: Symbol) where I1
    edIdx = findfirst(ed_symbols(s) .== ed);
    @assert  (!isnothing(edIdx)  && edIdx > 0)  "Invalid $ed"
    return edIdx
end

ed_idx(s :: AbstractSchoolGroups{I1}, ed :: Integer) where I1 = I1(ed);

# String labels
ed_labels(s :: AbstractSchoolGroups{I1}) where I1 = string.(ed_symbols(s));
ed_label(s :: AbstractSchoolGroups{I1}, ed :: Symbol) where I1 = 
    ed_labels(s)[ed_idx(s, ed)];
ed_label(s :: AbstractSchoolGroups{I1}, ed :: Integer) where I1 = ed_labels(s)[ed];
ed_symbol(s :: AbstractSchoolGroups{I1}, idx) where I1 = ed_symbols(s)[idx];

# Suffixes of the form "_1HSG" for files
ed_suffixes(s :: AbstractSchoolGroups{I1}) where I1 =
    [ed_suffix(s, j)  for j = 1 : n_school(s)];

function ed_suffix(s :: AbstractSchoolGroups{I1}, ed) where I1
    edIdx = ed_idx(s, ed);
    edStr = ed_label(s, ed);
    return "_$edIdx$edStr"
end


# ------- HSG, CD, CG

struct Schooling3{I1} <: AbstractSchoolGroups{I1} end;

Base.show(io :: IO, s :: Schooling3{I1}) where I1 = 
    print(io, "Schooling: HSG, SC, CG");

StructLH.describe(s :: Schooling3{I1}) where I1 =
    ["Schooling:"  "HSG, SC, CG"];

n_school(s :: Schooling3{I1}) where I1 = I1(3);

ed_symbols(s :: Schooling3) = [SymHSG, SymSC, SymCG];

is_dropout(edLevel :: Symbol) = (edLevel == SymSC);
is_dropout(edLevel :: String) = (edLevel == LblSC);
is_dropout(edLevel :: Integer) = (edLevel == IdxSC);
is_graduate(edLevel :: Symbol) = (edLevel == SymCG);
is_graduate(edLevel :: String) = (edLevel == LblCG);
is_graduate(edLevel :: Integer) = (edLevel == IdxCG);

# ---------------