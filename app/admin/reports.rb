ActiveAdmin.register Report do
  csv do
    column :frame do |report|
      report.cell.frame.name
    end
    column :cell do |report|
      report.cell.uid
    end
    column :report_time
    column :voltage
    column :id
  end

  index do
    column :id
    column :report_time
    column :voltage
    column :cell do |report|
      report.cell.uid
    end
    default_actions
  end                                 
  
end
