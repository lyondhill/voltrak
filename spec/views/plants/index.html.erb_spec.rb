require 'spec_helper'

describe "plants/index" do
  before(:each) do
    assign(:plants, [
      stub_model(Plant),
      stub_model(Plant)
    ])
  end

  it "renders a list of plants" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
