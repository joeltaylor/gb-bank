require "rails_helper"

RSpec.describe "members/new.html.erb", type: :view do
  before(:each) do
    assign(:member, Member.new)
    render
  end

  it "displays the page heading" do
    expect(page.find("h2")).to have_content(t("member.create.heading"))
  end

  it "contains the new form" do
    expect(page.find("form.new_member")).to be_present
    expect(rendered).to match("Email")
    expect(rendered).to match("Name")
  end
end
