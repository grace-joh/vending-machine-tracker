require 'rails_helper'

RSpec.describe 'When a user visits a vending machine show page', type: :feature do
  before(:each) do
    @owner = Owner.create!(name: "Sam's Snacks")
    @dons = @owner.machines.create!(location: "Don's Mixed Drinks")
    @mikes = @owner.machines.create!(location: "Mike's Hot Chicken")
    @costco = @owner.machines.create!(location: 'Costco')

    @snack1 = Snack.create!(name: 'White Castle Burger', price: 3.50)
    @snack2 = Snack.create!(name: 'Pop Rocks', price: 1.5)
    @snack3 = Snack.create!(name: 'Flaming Hot Cheetos', price: 2.5)
    @snack4 = Snack.create!(name: 'Trail Mix', price: 1.00)

    MachineSnack.create!(machine: @dons, snack: @snack1)
    MachineSnack.create!(machine: @dons, snack: @snack2)
    MachineSnack.create!(machine: @dons, snack: @snack3)
    MachineSnack.create!(machine: @mikes, snack: @snack3)
    MachineSnack.create!(machine: @mikes, snack: @snack4)

    visit snack_path(@snack3)
  end

  scenario 'they see the name of that snack and price and locations list with the avg snack price and snack count' do
    expect(page).to have_content(@snack3.name)
    expect(page).to have_content("Price: $#{format('%.2f', @snack3.price)}")
    expect(page).to have_content("Locations")
    expect(page).to have_content("* #{@dons.location} (#{@dons.snack_count} kinds of snacks, average price of $#{format('%.2f', @dons.average_snack_price)})")
    expect(page).to have_content("* #{@mikes.location} (#{@mikes.snack_count} kinds of snacks, average price of $#{format('%.2f', @mikes.average_snack_price)})")
    expect(page).to_not have_content("* #{@costco.location}")
  end
end
