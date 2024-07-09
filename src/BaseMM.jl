module BaseMM

using CategoricalArrays, DataFrames, Dates, DocStringExtensions;
using Format, PrettyTables, StableRNGs;
using FilesLH, LatexLH, ModelParams, StructLH

# Types
export Double, TimeInt, ncInt, TypeInt, CollInt, SchoolInt, GridInt;

# Directories
export relBaseDir, base_dir;
export notation_dir, notation_copy_dir;
export sym_table_path;
export project_dir, paper_dir;
export computer_out_dir, computer_mat_dir, computer_log_dir, computer_json_dir, global_comparison_dir;
export profile_dir, dropbox_dir;

# Colleges
export n_colleges;

# School groups
export AbstractSchoolGroups, Schooling3
export ed_idx, ed_label, ed_labels, ed_symbol, ed_symbols, ed_suffixes, ed_suffix, n_school

export copy_file, test_dir

# Notation
export SymTable, symbol_table, reload_symbol_table, lsymbol, ldescription, symbol_entry; # , copy_symbol_table_from_dropbox
export RegrIntercept, GpaLabel

# Display
export format_number, format_dollars, format_model_dollars, format_vector, chain_strings
export current_time, show_text_table, show_matrix, fpath_to_show;
export settings_list, settings_table

# Unit conversions
export ModelUnits, DataUnits, AbstractModelDataUnits;
export hours_per_week_to_mtu, hours_data_to_mtu, hours_mtu_to_data, validate_mtu, mtu_to_hours_per_week, per_year_to_per_week
export check_dollar_values;
export dollars_data_to_model, dollars_model_to_data, dollars_data_to_model!, dollars_model_to_data!;
export dollars_to_data_units, dollars_to_model_units;
export dollar_factor, dollar_convert, dollar_convert!, d2m, m2d;
export ModelDollars, DataDollars, MDollars, DDollars;


# Helpers
export present_value, pv_factor, save_text_file, data_model_labels;
export array_to_df, add_array_to_df!;
export all_approx;
export CustomRNG;

# Debugging
export dbgLow, dbgMedium, dbgHigh

# Testing
export test_header, test_divider

# Stub
n_colleges(x) = nothing;


include("types.jl");
include("constants.jl");
include("helpers.jl");
include("school_groups.jl");
include("directories.jl");
include("notation.jl");
include("time_units.jl");
include("unit_conversions.jl");
include("display.jl");
include("classifications.jl");
include("testing.jl");

end
