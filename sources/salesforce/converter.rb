require 'go_import'

# This converter will convert a full export from Salesforce to LIME
# Go. Export data according to
# https://help.salesforce.com/apex/HTViewHelpDoc?id=admin_exportdata.htm

# You need to customize this script to suit your Salesforce export. 

# You should save the zipfile from Salesforce in the
# EXPORT_FOLDER. You dont have to unzip the file, just put it in the folder. 
EXPORT_FOLDER = "export"

# If you put more than one zip in the folder you must name the file
# you want to import to LIME GO.
# EXPORT_FILE = ""

# go-import will NOT use any unzipped files from the EXPORT_FOLDER. It
# will instead extract the zipfile to a temporary folder.


# If you are importing files then you must set the FILES_FOLDER
# constant. FILES_FOLDER should point to the folder where the files
# are stored. FILES_FOLDER can be relative to the project directory
# or absolute. Note that you need to escape \ with a \ so in order to
# write \ use \\.
FILES_FOLDER = "./files"

# If you are importing files with an absolute path (eg
# m:\documents\readme.doc) then you probably wont have files at that
# location on the computer where "go-import run" is executed. Set
# FILES_FOLDER_AT_CUSTOMER to the folder where documents are stored at
# the customers site. Ie, in this example m:\documents.
# Note that you need to escape \ with a \ so in order to write \ use
# \\.
FILES_FOLDER_AT_CUSTOMER = "m:\\documents\\"

class Converter
    # Configure your root model, add custom fields and deal statuses.
    def configure(rootmodel)
        # add custom field to your model here. Custom fields can be
        # added to organization, deal and person. Valid types are
        # :String and :Link. If no type is specified :String is used
        # as default.
#        rootmodel.settings.with_organization do |organization|
#            organization.set_custom_field( { :integrationid => 'external_url', :title => 'Link to external system', :type => :Link } )
#        end

        rootmodel.settings.with_deal do |deal|
            deal.add_status({:label => "1. Kvalificering", :integration_id => "qualification"})
            deal.add_status({:label => "Vunnen", :integration_id => "won",
                                :assessment => GoImport::DealState::PositiveEndState })
            deal.add_status({:label => "Lost", :integration_id => "Lost",
                                :assessment => GoImport::DealState::NegativeEndState })
        end
    end

    def get_deal_status_from_salesforce_stage(salesforce_deal_stage)
        # When deals are added to LIME Go this method is called for
        # each deal. The deal's stage from Salesforce is supplied as
        # an argument and this method should return a status for the
        # deal in LIME Go. The returned value is probably a label of a
        # deal status that has been added in the configure(rootmodel)
        # method.
        deal_status = nil
        
        case salesforce_deal_stage
        when 'Prospecting'
            deal_status = '1. Kvalificering'
        when 'Closed Won'
            deal_status = 'Vunnen'
        end

        return deal_status
    end
end