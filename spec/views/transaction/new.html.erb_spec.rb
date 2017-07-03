require "rails_helper"

RSpec.describe "transactions/new.html.erb", type: :view do
  before(:each) do
    assign(:transaction, Transaction.new)
    render
  end

  it "displays the page heading" do
    expect(page.find("h2")).to have_content(t("transaction.create.heading"))
  end

  it "contains the new form" do
    expect(page.find("form.new_transaction")).to be_present
    expect(rendered).to match("Email")
    expect(rendered).to match("Amount")
    expect(rendered).to match("Date")
    expect(rendered).to match("Description")
  end
end
