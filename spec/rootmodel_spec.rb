require "spec_helper"
require 'fruit_to_lime'

describe "RootModel" do
    let(:rootmodel) {
        FruitToLime::RootModel.new
    }

    it "will contain integration coworker by default" do
        rootmodel.find_coworker_by_integration_id("import").first_name.should eq "Import"
        rootmodel.coworkers.length.should eq 1
    end


    it "can add a coworker from a hash" do
        rootmodel.add_coworker({
            :integration_id=>"123key",
            :first_name=>"Kalle",
            :last_name=>"Anka",
            :email=>"kalle.anka@vonanka.com"
        })
        rootmodel.find_coworker_by_integration_id("123key").first_name.should eq "Kalle"
        rootmodel.coworkers.length.should eq 2
    end

    it "can add a coworker from a new coworker" do
        coworker = FruitToLime::Coworker.new
        coworker.integration_id = "123key"
        coworker.first_name="Kalle"
        coworker.last_name="Anka"
        coworker.email = "kalle.anka@vonanka.com"
        rootmodel.add_coworker(coworker)
        rootmodel.find_coworker_by_integration_id("123key").first_name.should eq "Kalle"
        rootmodel.coworkers.length.should eq 2
    end

    it "will not add a new coworker when the coworker is already added (same integration id)" do
        rootmodel.add_coworker({
            :integration_id=>"123key",
            :first_name=>"Kalle",
            :last_name=>"Anka",
            :email=>"kalle.anka@vonanka.com"
        })
        rootmodel.coworkers.length.should eq 2
        expect { 
            rootmodel.add_coworker({
                :integration_id=>"123key",
                :first_name=>"Knatte",
                :last_name=>"Anka",
                :email=>"knatte.anka@vonanka.com"
            })
        }.to raise_error(FruitToLime::AlreadyAddedError)
        rootmodel.find_coworker_by_integration_id("123key").first_name.should eq "Kalle"
        rootmodel.coworkers.length.should eq 2
    end

end
