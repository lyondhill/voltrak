ActiveAdmin.register_page "Dashboard" do

  content :title => proc{ I18n.t("active_admin.dashboard") } do
    # div :class => "blank_slate_container", :id => "dashboard_default_message" do
    #   span :class => "blank_slate" do
    #     span "Voltrak Admin."
    #   end
    # end

    
    columns do
      column do
        panel "Current Counts" do
          ul do
            li "Plants: #{Plant.count}"
            li "Frames: #{Frame.count}"
            li "Cells: #{Cell.count}"
            li "Reports: #{Report.count}"
          end
        end
      end
    end

    #   column do
    #     panel "Info" do
    #       para "Welcome to ActiveAdmin."
    #     end
    #   end
    # end
  end # content
end
