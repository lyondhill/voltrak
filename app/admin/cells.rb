ActiveAdmin.register Cell do
  index do
    column :id
    column :uid
    column :status 
    column :last_voltage, sortable: :last_voltage do |cell|
      cell.last_voltage.round(2)
    end       
    default_actions                   
  end                                 
  
end
