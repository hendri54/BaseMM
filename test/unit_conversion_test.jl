function dollars_test()
	@testset "Dollars" begin
		dDollars = 1000.0;
		mDollars = dollars_data_to_model(dDollars, :perYear);
        dDollars2 = dollars_model_to_data(mDollars, :perYear);
        @test isapprox(dDollars, dDollars2)
        @test isapprox(mDollars, dollars_data_to_model(dDollars, TuYear()));
        @test isapprox(dDollars, dollars_model_to_data(mDollars, TuYear()));

        @test isapprox(mDollars, dollar_convert(dDollars, DDollars(), MDollars()));
        @test isapprox(dDollars, dollar_convert(dDollars, DDollars(), DDollars()));
        @test isapprox(dollar_factor(DDollars(), DDollars()), 1.0);
        v = [dDollars];
        dollar_convert!(v, DDollars(), MDollars());
        @test isapprox(only(v), mDollars);

		mDollars3 = dollars_data_to_model(dDollars, :perDay);
		@test mDollars3 > 300 * mDollars
		dDollars3 = dollars_model_to_data(mDollars3, :perDay);
		@test dDollars3 ≈ dDollars

        mDollarV = [1.2, 2.3];
        tUnit = TuMonth();
        dDollarV = dollars_model_to_data(mDollarV, tUnit);
        @test isapprox(dollars_data_to_model(dDollarV, tUnit), mDollarV);
        @test isapprox(dDollarV, 
            dollars_to_data_units(ModelUnits(), mDollarV, tUnit));
        dDollar2V = copy(mDollarV);
        dollars_model_to_data!(dDollar2V, tUnit);
        @test isapprox(dDollarV, dDollar2V);
        dollars_data_to_model!(dDollar2V, tUnit);
        @test isapprox(dDollar2V, mDollarV);
        @test isapprox(mDollarV, 
            dollars_to_model_units(DataUnits(), dDollarV, tUnit));
        @test isapprox(mDollarV, 
            dollars_to_model_units(ModelUnits(), mDollarV, tUnit));

        @test check_dollar_values(DataUnits(), [1000.0, 2000.0], 500.0, 3000.0);
        @test !check_dollar_values(ModelUnits(), [1000.0, 2000.0], 500.0, 3000.0);
        @test check_dollar_values(ModelUnits(), 
            dollars_data_to_model([1000.0, 2000.0], TuYear()), 500.0, 3000.0);
        @test !check_dollar_values(ModelUnits(), [1000.0, 2000.0], 500.0, 3000.0);
	end
end


function time_units_test()
    @testset "Time units" begin
        mtu = [0.7, 0.2];
        validate_mtu(mtu);
        hours = mtu_to_hours_per_week(mtu);
        mtu2 = hours_per_week_to_mtu(hours);
        @test mtu ≈ mtu2

        modelHours = [0.2, 0.7];
        for timeFactor ∈ [:weeksPerYear, :daysPerYear, :hoursPerYear, :hoursPerWeek]
            hd = hours_mtu_to_data(modelHours, timeFactor);
            @test all(hd .> 0.0)
            @test all(hd .< BaseMM.hoursPerYear)
            hm = hours_data_to_mtu(hd, timeFactor);
            @test all(hm .≈ modelHours)
        end

        hd = hours_mtu_to_data(modelHours, :hoursPerWeek);
        hd2 = mtu_to_hours_per_week(modelHours);
        @test all(hd .≈ hd2)
    end
end




@testset "Unit conversion" begin
    dollars_test();
    time_units_test();
end

# -------------