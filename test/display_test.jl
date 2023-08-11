function format_number_test()
    @testset "Format number" begin
        y = format_number(123456.789);
        @test startswith(y,  "123,456")
        y = format_number(123456.789; format = :none);
        @test startswith(y, "123456.789")

        y = format_number(123.456);
        @test startswith(y, "123.4")

        y = format_number(0.0012345);
        @test startswith(y, "0.00123");
    end
end

function format_vector_test()
    s = format_vector("abc", [1.2, 2.3, 34.56789], 2);
    @test startswith(s, "abc:")
    @test endswith(s, "34.57]")
end

@testset "Display" begin
    format_number_test();
    format_vector_test();
end

# -------------