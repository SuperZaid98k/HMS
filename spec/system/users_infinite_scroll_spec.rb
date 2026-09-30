# spec/system/users_infinite_scroll_spec.rb
require 'rails_helper'

RSpec.describe "Users Management Infinite Scroll", type: :system, js: true do
  let(:admin_user) { create(:user, :admin) }

  before do
    # Create 35 users so we have at least 3 batches (15 per batch)
    create_list(:user, 35)
    sign_in admin_user
  end

  it "loads the next batch automatically when the sentinel enters view" do
    visit users_path

    # Initial batch loads 15 users
    expect(page).to have_css("#users-table-body tr", count: 15)
    expect(page).to have_selector("#scroll-sentinel")

    # Scroll the real browser to the bottom of the page
    page.execute_script("window.scrollTo(0, document.body.scrollHeight)")

    # Playwright waits for Turbo Stream to append the second batch automatically
    expect(page).to have_css("#users-table-body tr", count: 30, wait: 5)
  end
end