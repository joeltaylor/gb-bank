require 'rails_helper'

RSpec.feature "Members", type: :feature do
  feature "User updates a member" do
    let(:original_email) { "person@person.com" }
    let(:original_name)  { "person" }
    let(:new_email)      { "betterperson@person.com" }
    let(:new_name)       { "better person" }
    let(:member)         { FactoryGirl.create(:member_with_account,
                                              name: original_name,
                                              email: original_email)}

    before do
      visit edit_member_path(member)
      fill_in "member_name", with: new_name
      fill_in "member_email", with: new_email
    end

    scenario "With valid data" do
      click_button(t('helpers.submit.update', model: 'Member'))

      expect(page).to have_content(t('member.index.heading'))
      expect(page).to have_content(t('member.edit.success'))
      expect(page).to have_content(new_name)
      expect(page).to have_content(new_email)
    end

    scenario "With a new e-mail that's been taken" do
      FactoryGirl.create(:member_with_account, email: new_email)

      click_button(t('helpers.submit.update', model: 'Member'))

      expect(member.reload.email).to eq(original_email)
      returns_to_members_index_with_an_error
    end

    scenario "With an invalid email" do
      fill_in "member_email", with: "not-a-email"

      click_button(t('helpers.submit.update', model: 'Member'))

      expect(member.reload.email).to eq(original_email)
      returns_to_members_index_with_an_error
    end

    scenario "Without a name" do
      fill_in "member_name", with: ""

      click_button(t('helpers.submit.update', model: 'Member'))

      expect(member.reload.name).to eq(original_name)
      returns_to_members_index_with_an_error
    end
  end

  feature "User creates a new member" do
    before do
      visit members_path
      click_link(t('member.index.new'))

      fill_in "member_name", with: "Member One"
      fill_in "member_email", with: "member@one.com"
    end

    scenario "With valid data" do
      expect {
        click_button(t('helpers.submit.create', model: 'Member'))
      }.to change(Member.all, :count).by(1)

      expect(page).to have_content(t('member.index.heading'))
      expect(page).to have_content(t('member.create.success'))
      expect(page).to have_content("Member One")
      expect(page).to have_content("member@one.com")
      expect(Member.last.account.balance).to eq(100.00)
    end

    scenario "Without a name" do
      fill_in "member_name", with: ""

      click_button(t('helpers.submit.create', model: 'Member'))

      expect(Member.count).to eq(0)
      returns_to_members_index_with_an_error
    end

    scenario "Without an email" do
      fill_in "member_email", with: ""

      click_button(t('helpers.submit.create', model: 'Member'))

      expect(Member.count).to eq(0)
      returns_to_members_index_with_an_error
    end

    scenario "With a duplicate email" do
      FactoryGirl.create(:member_with_account, email: 'member@one.com')

      click_button(t('helpers.submit.create', model: 'Member'))

      expect(Member.count).to eq(1)
      returns_to_members_index_with_an_error
    end
  end

  def returns_to_members_index_with_an_error
    expect(page).to have_content(t('member.index.heading'))
    expect(page).to have_content(t('error.generic_failure'))
  end
end
