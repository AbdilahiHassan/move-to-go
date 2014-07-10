require "spec_helper"
require "fruit_to_lime"

describe "DealClassSettings" do
    let(:deal_class_settings) {
        FruitToLime::DealClassSettings.new
    }

    it "should not allow new deal status without a label" do
        # given, when
        begin
            deal_class_settings.add_status({:integration_id => "123"})
        rescue FruitToLime::InvalidDealStatusError
        end

        # then
        deal_class_settings.statuses.length.should eq 0
    end

    it "should set assessment to NotAnEndState as default" do
        # given, when
        status = deal_class_settings.add_status({:label => "1. Kvalificering"})

        # then
        status.assessment.should eq FruitToLime::DealState::NotAnEndState
    end

    it "should set assessment if specified" do
        # given, when
        status = deal_class_settings.add_status({
                                                    :label => "4. Won deal",
                                                    :assessment => FruitToLime::DealState::PositiveEndState
                                                })

        # then
        status.assessment.should eq FruitToLime::DealState::PositiveEndState
    end

    it "should find a status by case insensitive label" do
        # given
        deal_class_settings.add_status({:label => "1. Kvalificering"})
        deal_class_settings.add_status({:label => "2. Skickat offert"})

        # when
        status = deal_class_settings.find_status_by_label("2. skICkat OfFert")

        # then
        status.label.should eq "2. Skickat offert"
    end

    it "should find a status by integration id" do
        # given
        deal_class_settings.add_status({:label => "1. Kvalificering", :integration_id => "qualify"})
        deal_class_settings.add_status({:label => "2. Skickat offert", :integration_id => "tender sent"})

        # when
        status = deal_class_settings.find_status_by_integration_id("tender SeNT")

        # then
        status.label.should eq "2. Skickat offert"
    end

    it "should find nil by label if no statuses are defined" do
        # given, when
        status = deal_class_settings.find_status_by_label("3. Won")

        # then
        status.should eq nil
    end

    it "should find nil by label if label is nil" do
        # given
        deal_class_settings.add_status({:label => "1. Kvalificering", :integration_id => "qualify"})
        deal_class_settings.add_status({:label => "2. Skickat offert", :integration_id => "tender sent"})

        # when
        status = deal_class_settings.find_status_by_label(nil)

        # then
        status.should eq nil
    end

    it "should find nil by integration id if no statuses are defined" do
        # given, when
        status = deal_class_settings.find_status_by_integration_id("3. Won")

        # then
        status.should eq nil
    end

    it "should find nil by integration id if integration id is nil" do
        # given
        deal_class_settings.add_status({:label => "1. Kvalificering", :integration_id => "qualify"})
        deal_class_settings.add_status({:label => "2. Skickat offert", :integration_id => "tender sent"})

        # when
        status = deal_class_settings.find_status_by_integration_id(nil)

        # then
        status.should eq nil
    end
end


