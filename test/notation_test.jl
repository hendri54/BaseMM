using BaseMM, Test;
mdl = BaseMM;

function notation_test()
    @testset "Notation" begin
        testDir = mdl.test_file_dir();
        # CSV file with notation for testing. Hand written.
        stPath = joinpath(testDir, "notation_table.csv");
        @test isfile(stPath);

        reload_symbol_table(stPath);
        st = symbol_table();

        sName = :abil;
        @test lsymbol(sName) isa String;
        @test ldescription(sName) isa String;
        descr, cmd, v = symbol_entry(st, sName, 0.55);
        @test descr == ldescription(sName);
        @test cmd == "abilV";
        @test v == 0.55;
	end
end

@testset "Notation" begin
    notation_test();
end

# --------------