## -----------  Notation

const GpaLabel = "AFQT";

# This holds a copy of the symbol table, so it need not be reloaded all the time.
const SymTable = SymbolTable();


"""
	$(SIGNATURES)

Returns `SymbolTable` with notation. If `SymTable` is populated, returns it. Otherwise reads a CSV file.

This will be used by `write_notation_preamble`.

Todo: Allow for recursive symbol definitions. This can already be done, but one needs to ensure that dependencies are in groups that come earlier than uses.
"""
function symbol_table(; fPath = nothing, forceReload :: Bool = false)
    if forceReload  ||  isempty(SymTable)
        @assert !isnothing(fPath)  "Need path to reload SymbolTable";
        reload_symbol_table(fPath);
    end
    return SymTable
end

function reload_symbol_table(fPath)
    @assert isfile(fPath)  "Not found: $fPath";
    LatexLH.erase!(SymTable);
    # copy_symbol_table_from_dropbox();
    load_from_csv!(SymTable, fPath);
end

# sym_table_path(computer = :current) = 
#     joinpath(notation_dir(computer), "notation_table.csv");

# # Symbol table is hand-edited in a Dropbox dir. Needs to imported periodically.
# function copy_symbol_table_from_dropbox()
#     if !is_remote(get_computer(:current))
#         tgDir = notation_dir();
#         isdir(tgDir)  ||  mkpath(tgDir);
#         srcPath = joinpath(dropbox_dir(), "lutz", "notation", "notation_table.csv");
#         @assert isfile(srcPath)  "Not found: $srcPath";
#         cp(srcPath, sym_table_path(); force = true);
#     end
# end

# Latex symbol by name
lsymbol(name :: Symbol; defaultValue = string(name)) = 
    LatexLH.latex(symbol_table(), name; defaultValue);
ldescription(name :: Symbol; defaultValue = string(name)) = 
    LatexLH.description(symbol_table(), name; defaultValue);


"""
	$(SIGNATURES)

Make an entry for a symbol. Returns a vector with (description, newcommand name, numerical value).

# Example
```
symbol_entry(st, :workTime, 1.2) == ("Wrk time", "workTimeV", 1.2)
```
"""
function symbol_entry(st :: SymbolTable, sName :: Symbol, value)
    si = st[sName];
    return LatexLH.description(si), "$(si.name)V", value
end


# """
# 	$(SIGNATURES)

# Write preamble with newcommand statements that define notation for the paper.
# Writes to a local directory so that code can run on the cluster.
# Calls `symbol_table` to make code revisions easier.
# """
# function write_notation_preamble(fPath)
#     st = symbol_table();
#     println("Writing notation preamble to ", fpath_to_show(fPath));
#     make_dir(fPath);
#     open(fPath, "w") do io
#         write_preamble(io, st);
#     end
#     # if copyToDropbox  &&  !is_remote(:current)
#     #     tgPath = joinpath(notation_copy_dir(), "notation_preamble.tex");
#     #     cp(fPath, tgPath; force = true);
#     # end
#     # println("Done");
#     return fPath
# end

# # notation_preamble_path() = joinpath(notation_dir(), "notation_preamble.tex");

# """
# 	$(SIGNATURES)

# Write a tex file that lists notation. To be included in another document as a Section.
# Writes to a local directory so that code can run on the cluster.
# """
# function write_notation_summary(fPath)
#     println("Writing notation summary to ", fpath_to_show(fPath));
#     make_dir(fPath);
#     open(fPath, "w") do io
#         write_notation_tex(io, symbol_table());
#     end
#     # if copyToDropbox  &&  !is_remote(:current)
#     #     tgPath = joinpath(notation_copy_dir(), "notation_summary.tex");
#     #     cp(fPath, tgPath; force = true);
#     # end
#     # println("Done");
# end

# notation_summary_path() = joinpath(notation_dir(), "notation_summary.tex");

# ------------