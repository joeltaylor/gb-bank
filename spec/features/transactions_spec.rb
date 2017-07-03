require 'rails_helper'

RSpec.feature "Transactions", type: :feature do
  let(:member)   { FactoryGirl.create(:member) }
  let!(:account)  { FactoryGirl.create(:account, member: member, balance: 50.00) }

  feature "User creates a transaction for a member" do
    before do
      visit members_path
      click_link(t('member.index.create_transaction'))
      fill_in "member_email", with: member.email
      fill_in "transaction_amount", with: 100.00
      fill_in "transaction_date", with: Date.today
      fill_in "transaction_description", with: "Gift"
    end

    scenario "With valid data and a positive amount" do
      click_button(t('helpers.submit.create', model: 'Transaction'))

      behaves_like_a_successful_deposit_transaction
    end

    scenario "With valid data and a negative amount" do
      fill_in "transaction_amount", with: -100.00

      click_button(t('helpers.submit.create', model: 'Transaction'))

      behaves_like_a_successful_charge_transaction
    end

    scenario "With a charge that would cause an overdrawn account balance" do
      fill_in "transaction_amount", with: -300.00

      click_button(t('helpers.submit.create', model: 'Transaction'))

      behaves_like_a_failed_transaction
    end

    scenario "With an amount that would cause the balance to go outside support range" do
      fill_in "transaction_amount", with: 10**10

      click_button(t('helpers.submit.create', model: 'Transaction'))

      behaves_like_a_failed_transaction
    end

    scenario "With a valid member e-mail that is capitalized" do
      fill_in "member_email", with: member.email.upcase

      click_button(t('helpers.submit.create', model: 'Transaction'))

      behaves_like_a_successful_deposit_transaction
    end

    scenario "With a non-existent member e-mail" do
      fill_in "member_email", with: "noone@noone.com"

      click_button(t('helpers.submit.create', model: 'Transaction'))

      behaves_like_a_failed_transaction
    end

    scenario "Without a description" do
      fill_in "transaction_description", with: ""

      click_button(t('helpers.submit.create', model: 'Transaction'))

      behaves_like_a_failed_transaction
    end

    scenario "With a description longer than 140 chars" do
      fill_in "transaction_description", with: "a"*141

      click_button(t('helpers.submit.create', model: 'Transaction'))

      expect(Transaction.last.description).to eq("a"*140)
      behaves_like_a_successful_deposit_transaction
    end

    scenario "With an invalid date" do
      fill_in "transaction_date", with: "2017/01/1000000"

      click_button(t('helpers.submit.create', model: 'Transaction'))

      behaves_like_a_failed_transaction
    end

    scenario "Without a date" do
      fill_in "transaction_date", with: ""

      click_button(t('helpers.submit.create', model: 'Transaction'))

      behaves_like_a_failed_transaction
    end

  end

  def behaves_like_a_successful_deposit_transaction
    balance_is_increased_by_deposit
    expect(page).to have_content(t('member.index.heading'))
    expect(page).to have_content(t('transaction.create.success'))
  end

  def behaves_like_a_successful_charge_transaction
    balance_is_decreased_by_charge
    expect(page).to have_content(t('member.index.heading'))
    expect(page).to have_content(t('transaction.create.success'))
  end

  def behaves_like_a_failed_transaction
    balance_does_not_change
    expect(page).to have_content(t('member.index.heading'))
    expect(page).to have_content(t('error.generic_failure'))
  end

  def balance_is_increased_by_deposit
    expect(account.reload.balance).to eq(150.00)
  end

  def balance_is_decreased_by_charge
    expect(account.reload.balance).to eq(-50.00)
  end

  def balance_does_not_change
    expect(account.reload.balance).to eq(50.00)
  end
end
