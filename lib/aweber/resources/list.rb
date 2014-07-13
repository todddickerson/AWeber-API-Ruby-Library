module AWeber
  module Resources
    class List < Resource
      basepath "/lists"
      
      FOLLOWUP_TYPE_LINK  = File.join(AWeber.api_url, "#followup_campaign")
      BROADCAST_TYPE_LINK = File.join(AWeber.api_url, "#broadcast_campaign")
      
      api_attr :name
      api_attr :unique_list_id

      api_attr :campaigns_collection_link
      api_attr :subscribers_collection_link
      api_attr :web_forms_collection_link
      api_attr :web_form_split_tests_collection_link
      api_attr :custom_fields_collection_link
      
      has_many :campaigns
      has_many :custom_fields
      has_many :subscribers
      has_many :web_forms
      has_many :web_form_split_tests
      
      def initialize(*args)
        super(*args)
        @followups  = nil
        @broadcasts = nil
      end
      
      def broadcasts
        return @broadcasts if @broadcasts

        @broadcasts = AWeber::Collection.new(client, Campaign, :parent => self)
        @broadcasts.entries = Hash[campaigns.select { |id, c| c.is_broadcast? }]
        @broadcasts
      end
      
      def followups
        return @followups if @followups

        @followups = AWeber::Collection.new(client, Campaign, :parent => self)
        @followups.entries = Hash[campaigns.select { |id, c| c.is_followup? }]
        @followups
      end
    end
  end
end
