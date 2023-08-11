using BaseMM, Test

function present_value_test()
    x = 3.9;
    T = 7;
    R = 1.2;
    pvFactor = pv_factor(R, T);
    @test pvFactor > 1.0
    @test pvFactor < T

    xV = fill(x, T);
    pValue = present_value(xV, R);
    @test isapprox(x * pvFactor, pValue)

    xV = LinRange(-0.5, 3.2, T);
    pValue = present_value(xV, R);
    pv = sum(xV .* ((1/R) .^ (0 : (T-1))));
    @test isapprox(pv, pValue)
end

@testset "Helpers" begin
    present_value_test();
end

# -----------