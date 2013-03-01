ActiveAdmin.register Report do
  action_item do
    link_to "Full CSV", reports_path(format: "csv"), confirm: 'This could take a very long time?'
  end

  index do
    column :id
    column :report_time
    column :voltage
    column :cell do |report|
      report.cell.uid
    end
    # default_actions
  end                                 
  
end
