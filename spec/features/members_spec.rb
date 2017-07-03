require 'rails_helper'

RSpec.feature "Members", type: :feature do
  feature "User updates a member" do
    let(:member) { FactoryGirl.create(:member, name: "person", email: "person@person.com") }

    scenario "Successfully" do
      visit edit_member_path(member)
      fill_in "member_name", with: "New Name"
      fill_in "member_email", with: "new@email.com"
      click_button(t('helpers.submit.update', model: 'Member'))

      expect(page).to have_content(t('member.index.heading'))
      expect(page).to have_content(t('member.edit.success'))
      expect(page).to have_content("New Name")
      expect(page).to have_content("new@email.com")
    end

    scenario "With a duplicate email" do
      FactoryGirl.create(:member, email: 'previous@email.com')

      visit edit_member_path(member)
      fill_in "member_email", with: "previous@email.com"
      click_button(t('helpers.submit.update', model: 'Member'))

      expect(page).to have_content(t('member.index.heading'))
      expect(page).to have_content(t('member.edit.failure'))
      expect(page).to have_content("person@person.com")
    end

    scenario "With an invalid email" do
      visit edit_member_path(member)
      fill_in "member_email", with: "not-a-email"
      click_button(t('helpers.submit.update', model: 'Member'))

      expect(page).to have_content(t('member.index.heading'))
      expect(page).to have_content(t('member.edit.failure'))
    end

    scenario "Without a name" do
      visit edit_member_path(member)
      fill_in "member_name", with: ""
      click_button(t('helpers.submit.update', model: 'Member'))

      expect(page).to have_content(t('member.index.heading'))
      expect(page).to have_content(t('member.edit.failure'))
    end
  end

  feature "Creating a new member" do
    scenario "Successfully" do
      visit members_path
      click_link(t('member.index.new'))

      expect {
        fill_in "member_name", with: "Member One"
        fill_in "member_email", with: "member@one.com"
        click_button(t('helpers.submit.create', model: 'Member'))
      }.to change(Member.all, :count).by(1)

      expect(page).to have_content(t('member.index.heading'))
      expect(page).to have_content(t('member.create.success'))
      expect(page).to have_content("Member One")
      expect(page).to have_content("member@one.com")
      expect(Member.last.account.balance).to eq(100.00)
    end

    scenario "Without a name" do
      visit members_path
      click_link(t('member.index.new'))

      fill_in "member_email", with: "member@one.com"
      click_button(t('helpers.submit.create', model: 'Member'))

      expect(Member.count).to eq(0)
      expect(page).to have_content(t('member.index.heading'))
      expect(page).to have_content(t('member.create.failure'))
    end

    scenario "Without an email" do
      visit members_path
      click_link(t('member.index.new'))

      fill_in "member_name", with: "Member One"
      click_button(t('helpers.submit.create', model: 'Member'))

      expect(Member.count).to eq(0)
      expect(page).to have_content(t('member.index.heading'))
      expect(page).to have_content(t('member.create.failure'))
    end

    scenario "With a duplicate email" do
      FactoryGirl.create(:member, email: 'previous@email.com')

      visit members_path
      click_link(t('member.index.new'))

      fill_in "member_name", with: "Member One"
      fill_in "member_email", with: "previous@email.com"
      click_button(t('helpers.submit.create', model: 'Member'))

      expect(page).not_to have_content("Member One")
      expect(page).to have_content(t('member.index.heading'))
      expect(page).to have_content(t('member.create.failure'))
    end
  end
end
