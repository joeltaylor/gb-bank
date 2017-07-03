require "rails_helper"

RSpec.describe "members/edit.html.erb", type: :view do
  before(:each) do
    @member = FactoryGirl.build_stubbed(:member)
    assign(:member, @member)
    render
  end

  it "displays the page heading" do
    expect(page.find("h2")).to have_content(t("member.edit.heading"))
  end

  it "contains the edit form" do
    expect(page.find("form.edit_member")).to be_present
  end

  it "populates the form with member attributes" do
    expect(rendered).to match(@member.name)
    expect(rendered).to match(@member.email)
  end
end
