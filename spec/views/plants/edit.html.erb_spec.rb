require 'spec_helper'

describe "plants/edit" do
  before(:each) do
    @plant = assign(:plant, stub_model(Plant))
  end

  it "renders the edit plant form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => plants_path(@plant), :method => "post" do
    end
  end
end
