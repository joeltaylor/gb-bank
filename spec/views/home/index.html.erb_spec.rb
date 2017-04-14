require "rails_helper"

RSpec.describe "home/index.html.erb", type: :view do
  it "displays the heading" do
    render
    expect(page.find("h2")).to have_content(t("home.index.heading"))
  end
end
