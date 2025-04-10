using BaseMM, CategoricalArrays, DataFrames, Random, Test

function all_approx_test()
    @testset "All approx" begin
        xTg = 2.343;
        xM = fill(xTg, 3, 4);
        @test all_approx(xM, xTg);
        tol = 1e-5;
        xM[3] -= 2 * tol;
        @test !all_approx(xM, xTg; tol);
    end
end

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

function array_to_df_test(nDims :: Integer)
    @testset "Array to Df $nDims" begin
        sizeV = [2,3,4];
        grpVars = [:ability, :parental, :hsGpa];

        sizeV = sizeV[1 : nDims];
        if nDims == 1
            grpVars = grpVars[1];
            labelV = var_label(grpVars);
        else
            grpVars = grpVars[1 : nDims];
            labelV = var_labels(grpVars);
        end
        
        rng = MersenneTwister(54);
        m = rand(rng, sizeV...);

        df = array_to_df(m, grpVars; yStr = "y", labelV);
        @test size(df.y) == (length(m), );

        isValid = true;
        for r in eachrow(df)
            # idxV = CartesianIndices(m)[iRow];
            # Get the integer indices for the row
            if labelV isa Vector
                idxV = [levelcode(r[v]) for v in labelV];
            else
                idxV = levelcode(r[labelV]);
            end
            isValid = isValid  &&  (r[:y] == m[idxV...]);
        end
        @test isValid;

        m2 = m .+ 2.0;
        add_array_to_df!(df, m2, grpVars; labelV, yStr = "y2");
        @test isapprox(df[!, :y] .+ 2.0, df[!, :y2]);
    end
end


function df_to_matrix_test()
    @testset "Df to Matrix" begin
        rng = MersenneTwister(54);
        xM = rand(rng, 3, 4);
        grpVars = [:ability, :parental];
        df = array_to_df(xM, grpVars; yStr = "Data");

        xM2, _ = df_to_matrix(df, :ability, :parental, :Data);
        @test size(xM2) == size(xM);
        @test all(isapprox.(xM2, xM));
    end
end


@testset "Helpers" begin
    all_approx_test();
    present_value_test();
    for nd ∈ (1, 2, 3)
        array_to_df_test(nd);        
    end
    df_to_matrix_test();
end

# -----------