export var_label, var_labels, long_label, long_labels;
export is_singleton;

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
"""
long_label(v :: Symbol) = string(v);
long_label(v :: AbstractString) = v;

"""
	$(SIGNATURES)

Vector version of `long_label`.
"""
long_labels(v :: AbstractVector) = long_label.(v);
long_labels(v) = long_label(v);


# -------------