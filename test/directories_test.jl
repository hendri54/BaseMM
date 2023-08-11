function directories_test()
    @testset "Directories" begin
        @test isdir(base_dir());
        @test endswith(base_dir(), "mismatch");

        @test isdir(project_dir());
        @test isdir(paper_dir());
        @test isdir(notation_dir());
        @test isfile(sym_table_path());
        @test isdir(global_comparison_dir());
        @test isdir(computer_log_dir())
        @test base_dir(:current) == base_dir()
        @test isdir(computer_out_dir())
        remoteOutDir = computer_out_dir(:longleaf)
        @test startswith(remoteOutDir, "/nas/longleaf")
        @test isdir(computer_mat_dir());

        @test isdir(dropbox_dir());
    end
end

@testset "Directories" begin
    directories_test();
end

# --------------