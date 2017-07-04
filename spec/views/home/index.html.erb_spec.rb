require "rails_helper"

RSpec.describe "home/index.html.erb", type: :view do
  it "displays the heading" do
    render
    expect(page.find("h2")).to have_content(t("home.index.heading"))
  end

  it "displays a link to view members" do
    render
    expect(page.find("a")).to have_content(t("home.index.members"))
  end
end
