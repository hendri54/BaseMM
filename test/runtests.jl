using BaseMM, Test;

@testset "All" begin
    include("directories_test.jl");
    include("unit_conversion_test.jl");
    include("notation_test.jl");
    include("display_test.jl");
    include("helpers_test.jl");
    include("school_groups_test.jl");
end

# ---------------