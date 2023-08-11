
# Basedir is expected at this location relative to home for file transfer
const relBaseDir = 
	joinpath("Documents", "projects", "p2022", "mismatch");

"""
	$(SIGNATURES)

Points to `mismatch`. All project files are in this directory.

Currently not relocatable.
"""
function base_dir(computer :: Union{Symbol, Computer} = :current)
	return joinpath(home_dir(computer), relBaseDir)
end


# """
# 	$(SIGNATURES)

# Directory for Julia shared code. Perhaps not needed?
# """
# function julia_dir(computer :: Union{Symbol, Computer} = :current)
# 	return joinpath(home_dir(computer),  "Documents",  "julia")
# end

"""
	$(SIGNATURES)

Code and other material that get synced to `github` are here.
"""
function project_dir(computer :: Union{Symbol, Computer} = :current)
    return joinpath(base_dir(computer),  "MismatchMM");
end


# Files for the paper live here. 
# On local machine: write directly to Dropbox.
# On remote: these files go into an arbitrary local dir.
function paper_dir(computer :: Union{Symbol, Computer} = :current)
	# if is_remote(computer)
		pDir = joinpath(base_dir(computer), "paper");
	# else
	# 	pDir = joinpath(dropbox_dir(computer), "lutz", "paper");
	# end
	return pDir
end
	
"""
	$(SIGNATURES)

Base directory for all output files.
"""
function computer_out_dir(computer :: Union{Symbol, Computer} = :current)
    return joinpath(base_dir(computer), "out")
end


"""
	$(SIGNATURES)

Comparisons across cases are stored here.
"""
function global_comparison_dir(computer :: Union{Symbol, Computer} = :current)
    return joinpath(computer_out_dir(computer), "compare")
end


"""
	$(SIGNATURES)

Base directory for all `mat` files (binaries).
"""
function computer_mat_dir(computer :: Union{Symbol, Computer} = :current)
    return joinpath(base_dir(computer), "mat")
end

computer_json_dir(computer :: Union{Symbol, Computer} = :current) = 
	joinpath(base_dir(computer), "mat");


"""
	$(SIGNATURES)

Logs need to be outside of the directory that gets `rsync`ed to longleaf.
Otherwise logs of running jobs get overwritten.
"""
function computer_log_dir(computer :: Union{Symbol, Computer} = :current)
	return joinpath(base_dir(computer),  "log")
end


# Put files generated by tests here
function test_dir(computer = :current)
	return joinpath(computer_out_dir(computer), "test_files")
end

# Profiler data live here. Delete before uploading (lots of useless files)
profile_dir(computer :: Union{Symbol, Computer} = :current) =
	joinpath(project_dir(computer),  "statprof");


## -----------  Files needed for paper
# Live in Dropbox (if local)

dropbox_dir(computer = :current) = 
	"/Users/lutz/Dropbox/Dropout Policies/lutz/admissions idea";


"""
	$(SIGNATURES)

Directory where notation files (e.g. notation preamble) are stored.
Local dir, so it works on server.
"""
function notation_dir(computer = :current)
	# if is_remote(computer)
		pDir = joinpath(paper_dir(computer), "notation");
	# else
	# 	pDir = joinpath(dropbox_dir(computer), "lutz", "notation");
	# end
	return pDir
end

notation_copy_dir(computer = :current) = 
	joinpath(dropbox_dir(computer), "lutz", "notation");

# CSV file exported from excel. Local
sym_table_path(computer = :current) = 
    joinpath(notation_dir(computer), "notation_table.csv");


# -------