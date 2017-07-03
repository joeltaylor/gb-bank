require "rails_helper"

RSpec.describe "members/index.html.erb", type: :view do
  before(:each) do
    assign(:members, [])
    render
  end

  it "displays the page heading" do
    expect(page.find("h2")).to have_content(t("member.index.heading"))
  end

  it "displays a link to create a new member" do
    expect(page).to have_content(t("member.index.new"))
  end

  it "displays a link to create a new transaction" do
    expect(page).to have_content(t("member.index.create_transaction"))
  end

  it "displays the table headers" do
    expect(page.find("table")).to have_content("Name")
    expect(page.find("table")).to have_content("Email")
    expect(page.find("table")).to have_content("Balance")
  end

  context "with members" do
    before(:each) do
      @members = FactoryGirl.build_stubbed_list(:member_with_account, 3 )
      assign(:members, @members)
      render
    end

    it "displays all the members" do
      @members.each do |member|
        expect(page).to have_content(member.name)
        expect(page).to have_content(member.email)
        expect(page).to have_content(member.account.balance)
      end
    end

    it "displays the edit action for a user" do
      expect(page).to have_content(t("member.index.edit"))
    end
  end
end
