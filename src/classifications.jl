export AbstractClassification, MultiClassification, Grouping;
export ClassAll, ClassHsGpa, ClassParental, ClassRichPoor, ClassAbility;
export ClassQuality, ClassQualOld, ClassQualNew, ClassLastType, ClassSchooling;
export ClassType, ClassYear, ClassDataModel, ClassUpDown;

export groupvar, n_classes, n_groupings;
export suffix, data_suffix, latex_sym;
export var_label, var_labels, long_label, long_labels, short_label, short_labels;
export subplot_label;
export is_singleton;

abstract type AbstractClassification end;
const MultiClassification = AbstractVector{<: AbstractClassification};
const Grouping = Union{AbstractClassification, MultiClassification};


## --------  Fallbacks

"""
	$(SIGNATURES)

User indicates which classifications are singletons (to be ignored).
"""
is_singleton(x) = false;


"""
	$(SIGNATURES)

Symbol, used as column title in DataFrames. Pass-through. Define for other types as needed.
"""
var_label(v :: Symbol) = v;
var_label(v :: AbstractString) = Symbol(v);

"""
	$(SIGNATURES)

Same as `var_label`, but works on Vectors and Scalars.
"""
var_labels(v :: AbstractVector) = var_label.(v);
var_labels(v) = var_label(v);

"""
	$(SIGNATURES)

String label, used for axis labels. Pass-through. Define for other types as needed.
Contains spaces.
"""
long_label(v :: Symbol) = string(v);
long_label(v :: AbstractString) = v;

"""
	$(SIGNATURES)

Vector version of `long_label`.
"""
long_labels(v :: AbstractVector) = long_label.(v);
long_labels(v) = long_label(v);

long_label(grpVars :: MultiClassification) = 
    prod([BaseMM.long_label(grp)  for grp in grpVars]);

long_labels(classVar :: AbstractClassification, n :: Integer) = 
    ["$(long_label(classVar)) $j"  for j = 1 : n];

short_labels(ds, grpVar :: AbstractClassification) = 
    short_labels(grpVar, n_classes(ds, grpVar)); # +++++

short_label(grpVars :: MultiClassification) = 
    prod([short_label(grp)  for grp in grpVars]);

short_labels(classVar :: AbstractClassification, n :: Integer) = 
    ["$(short_label(classVar))$j"  for j = 1 : n];

# For subplot headers, especially when they need to be short (e.g. 1x4)
subplot_label(classVar :: AbstractClassification) = short_label(classVar);
# E.g. "p1"
subplot_label(classVar :: AbstractClassification, j :: Integer) = 
    subplot_label(classVar) * "$j";


suffix(x :: AbstractString) = x;
suffix(v :: MultiClassification) = prod([suffix(x)  for x in v]);

# For matching data moments; e.g. `fracEnter_gV`
data_suffix(:: Nothing) = "";
data_suffix(c :: AbstractClassification) = "_" * lowercase(suffix(c)) * "V";
data_suffix(c :: MultiClassification) = 
    "_" * prod(lowercase.(suffix.(c))) * "M";


n_classes(ms, classV :: MultiClassification) = 
    [n_classes(ms, classVar)  for classVar in classV];
# n_classes(ms, classes :: Tuple{A,B}) where {A,B} = n_classes(ms, classes...);
n_classes(ms, x :: AbstractClassification, y :: AbstractClassification) = 
    (n_classes(ms, x), n_classes(ms, y));


## --------  Individual groups

# For computing aggregate stats. Dispatch only.
struct ClassAll <: AbstractClassification end
n_classes(ms, ::ClassAll) = 1;
suffix(::ClassAll) = nothing;
is_singleton(::ClassAll) = true;  

struct ClassHsGpa <: AbstractClassification end
# Grouping var in Stats DataFrame
groupvar(::ClassHsGpa) = :hsGpaClass;
# For short file names and display
suffix(::ClassHsGpa) = "G";  # e.g., "ByG"
# Grouping var in ModelSolution
# class_var(ms, ::ClassHsGpa) = ms.hsGpaClass_jV;
# n_classes(ms, ::ClassHsGpa) = CollegeStratData.n_gpa(ms);
# For file names and other internals
short_label(::ClassHsGpa) = "AFQT";
long_label(::ClassHsGpa) = "AFQT";  # for legends
latex_sym(::ClassHsGpa) = "g";

# By default: quartiles
struct ClassParental <: AbstractClassification end
groupvar(::ClassParental) = :parentalClass;
suffix(::ClassParental) = "P";
# class_var(ms, ::ClassParental) = ms.parentalClass_jV;
# n_classes(ms, ::ClassParental) = CollegeStratData.n_parental(ms);
short_label(::ClassParental) = "Yp";
long_label(::ClassParental) = "Parental income";
latex_sym(::ClassParental) = "p";
subplot_label(::ClassParental) = "p";

struct ClassRichPoor <: AbstractClassification end
groupvar(::ClassRichPoor) = :richPoorClass;
suffix(::ClassRichPoor) = "R";
short_label(::ClassRichPoor) = "Rp";
long_label(::ClassRichPoor) = "Higher vs lower income";
latex_sym(::ClassRichPoor) = "r";

struct ClassAbility <: AbstractClassification end
groupvar(::ClassAbility) = :abilClass;
suffix(::ClassAbility) = "A";
# class_var(ms, ::ClassAbility) = ms.abilClass_jV;
# n_classes(ms, ::ClassAbility) = n_abil(ms);
short_label(::ClassAbility) = "Abil";
long_label(::ClassAbility) = "Ability";
latex_sym(::ClassAbility) = "a";
subplot_label(::ClassAbility) = "a";

struct ClassUpDown <: AbstractClassification end
groupvar(::ClassUpDown) = :upDownClass;
suffix(::ClassUpDown) = "U";
n_classes(ms, ::ClassUpDown) = 3;
short_label(::ClassUpDown) = "UpDown";
long_label(::ClassUpDown) = "Up vs down";
# latex_sym(::ClassUpDown) = "u";
long_labels(::ClassUpDown, n :: Integer) = [LblUp, LblDown, LblNoChange];

struct ClassQuality <: AbstractClassification end
groupvar(::ClassQuality) = :quality;
suffix(::ClassQuality) = "Q";
# n_classes(ms, ::ClassQuality) = n_colleges(ms);
short_label(::ClassQuality) = "Qual";
long_label(::ClassQuality) = "Quality";
latex_sym(::ClassQuality) = "q";
subplot_label(::ClassQuality) = "q";

struct ClassQualOld <: AbstractClassification end;
groupvar(::ClassQualOld) = :qOld;
suffix(::ClassQualOld) = "Qold";
short_label(::ClassQualOld) = "Qold";
long_label(::ClassQualOld) = "Origin quality";
latex_sym(::ClassQualOld) = "q_{old}";

struct ClassQualNew <: AbstractClassification end;
groupvar(::ClassQualNew) = :qNew;
suffix(::ClassQualNew) = "Qnew";
short_label(::ClassQualNew) = "Qnew";
long_label(::ClassQualNew) = "Target quality";
latex_sym(::ClassQualNew) = "q_{new}";
    
# Only for renaming regressors.
struct ClassLastType <: AbstractClassification end;
short_label(::ClassLastType) = "Qual";
long_label(::ClassLastType) = "Quality";

struct ClassYear <: AbstractClassification end
groupvar(::ClassYear) = :year;
suffix(::ClassYear) = "T";
# n_classes(ms, ::ClassYear) = max_college_duration(ms);
short_label(::ClassYear) = "Year";
long_label(::ClassYear) = "Year";
latex_sym(::ClassYear) = "t"; 


struct ClassSchooling <: AbstractClassification end
groupvar(::ClassSchooling) = :school;
suffix(::ClassSchooling) = "S";
# n_classes(ms, ::ClassSchooling) = n_school(schoolS);
short_label(::ClassSchooling) = "School";
long_label(::ClassSchooling) = "Schooling";
latex_sym(::ClassSchooling) = "s";

struct ClassType <: AbstractClassification end
groupvar(::ClassType) = :type;
suffix(::ClassType) = "J";
# n_classes(ms, ::ClassType) = n_types(ms);
short_label(::ClassType) = "Type";
long_label(::ClassType) = "Type";

struct ClassDataModel <: AbstractClassification end
groupvar(::ClassDataModel) = :dm;
suffix(::ClassDataModel) = "DM";
n_classes(ms, ::ClassDataModel) = 2;
short_label(::ClassDataModel) = "D-M";
long_label(::ClassDataModel) = "Data/model";

## ----------------  Labels

# Variable in stats DataFrame used for grouping
groupvar(v :: Symbol) = v;
groupvar(v :: AbstractString) = Symbol(v);
groupvar(v :: MultiClassification) = [groupvar(x)  for x in v];
# groupvar(v :: NTuple{N, AbstractClassification}) where N = 
#     [groupvar(x) for x in v];

# Used for DataFrames
var_label(v :: AbstractClassification) = groupvar(v);
var_label(v :: MultiClassification) = groupvar(v);

n_groupings(::AbstractClassification) = 1;
n_groupings(grpVars :: MultiClassification) = length(grpVars);



# -------------