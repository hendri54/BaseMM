function schooling_test(s)
    @testset "Schooling" begin
        ns = n_school(s);
        @test ns == 3
        
        @test ed_idx(s, :HSG) == 1
        @test ed_idx(s, :CG) == ns
        @test ed_idx(s, 2) == 2
        
        @test ed_label(s, ns) == "CG"
        @test endswith(ed_label(s, :CG), "CG")
        edLabelV = ed_labels(s)
        @test isequal(edLabelV[1], ed_label(s, 1))
        @test length(edLabelV) == ns

        edSuffixV = ed_suffixes(s);
        @test endswith(edSuffixV[1], "HSG")
	end
end

@testset "Schooling" begin
    for s ∈ (Schooling3{UInt8}(), )
        schooling_test(s);
    end
end

# --------------