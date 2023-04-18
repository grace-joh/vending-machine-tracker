require 'rails_helper'

RSpec.describe 'When a user visits a vending machine show page', type: :feature do
  before(:each) do
    @owner = Owner.create!(name: "Sam's Snacks")
    @dons  = @owner.machines.create!(location: "Don's Mixed Drinks")
    @mikes  = @owner.machines.create!(location: "Mike's Hot Chicken")

    @snack1 = Snack.create!(name: 'White Castle Burger', price: 3.50)
    @snack2 = Snack.create!(name: 'Pop Rocks', price: 1.502312)
    @snack3 = Snack.create!(name: 'Flaming Hot Cheetos', price: 2.5)
    @snack4 = Snack.create!(name: 'Trail Mix', price: 1.00)

    MachineSnack.create!(machine: @dons, snack: @snack1)
    MachineSnack.create!(machine: @dons, snack: @snack2)
    MachineSnack.create!(machine: @dons, snack: @snack3)
    MachineSnack.create!(machine: @mikes, snack: @snack4)

    visit machine_path(@dons)
  end

  scenario 'they see the location of that machine' do
    expect(page).to have_content("Don's Mixed Drinks Vending Machine")
  end

  scenario 'they see the name of all of the snacks associated with that vending machine along with their price' do
    within("#snack-list") do
      expect(page).to have_content('Snacks')
      expect(page).to have_content("* #{@snack1.name}: $#{format('%.2f', @snack1.price)}")
      expect(page).to have_content("* #{@snack2.name}: $#{format('%.2f', @snack2.price)}")
      expect(page).to have_content("* #{@snack3.name}: $#{format('%.2f', @snack3.price)}")
      expect(page).to_not have_content("* #{@snack4.name}: $#{format('%.2f', @snack4.price)}")
    end
  end
end
