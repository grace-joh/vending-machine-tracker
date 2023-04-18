require 'rails_helper'

RSpec.describe Machine, type: :model do
  describe 'validations' do
    it { should validate_presence_of :location }
  end

  describe 'relationships' do
    it { should belong_to :owner }
    it { should have_many :machine_snacks }
    it { should have_many(:snacks).through(:machine_snacks) }
  end

  describe 'instance methods' do
    describe '#average_snack_price' do
      before(:each) do
        @owner = Owner.create!(name: "Sam's Snacks")
        @dons  = @owner.machines.create!(location: "Don's Mixed Drinks")
        @mikes  = @owner.machines.create!(location: "Mike's Hot Chicken")

        @snack1 = Snack.create!(name: 'White Castle Burger', price: 3.50)
        @snack2 = Snack.create!(name: 'Pop Rocks', price: 1.50)
        @snack3 = Snack.create!(name: 'Flaming Hot Cheetos', price: 2.50)
        @snack4 = Snack.create!(name: 'Trail Mix', price: 1.00)

        MachineSnack.create!(machine: @dons, snack: @snack1)
        MachineSnack.create!(machine: @dons, snack: @snack2)
        MachineSnack.create!(machine: @dons, snack: @snack3)
        MachineSnack.create!(machine: @mikes, snack: @snack4)
      end

      it 'returns average price of all snacks in the machine' do
        average = ((@snack1.price + @snack2.price + @snack3.price) / 3).round(2)

        expect(@dons.average_snack_price).to eq(average)
      end

      it 'returns average price of all snacks in the machine' do
        expect(@dons.snack_count).to eq(3)
        expect(@mikes.snack_count).to eq(1)
      end
    end
  end
end
