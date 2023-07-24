require 'rails_helper'

RSpec.describe Product, type: :model do
    describe 'Validations' do
      # Test that a product with all four fields set will save successfully
      it 'is valid with all fields set' do
        category = Category.create(name: 'Test Category')
        product = Product.new(
          name: 'Test Product',
          price: 9.99,
          quantity: 10,
          category: category
        )
        expect(product).to be_valid
      end
  
      # Test the 'name' validation
      it 'is not valid without a name' do
        category = Category.create(name: 'Test Category')
        product = Product.new(
          price: 9.99,
          quantity: 10,
          category: category
        )
        product.valid?
        expect(product.errors[:name]).to include("can't be blank")
      end
  
      # Test the 'price' validation
      it 'is not valid without a price' do
        category = Category.create(name: 'Test Category')
        product = Product.new(
          name: 'Test Product',
          quantity: 10,
          category: category
        )
        product.valid?
        expect(product.errors[:price]).to include("can't be blank")
      end
  
      # Test the 'quantity' validation
      it 'is not valid without a quantity' do
        category = Category.create(name: 'Test Category')
        product = Product.new(
          name: 'Test Product',
          price: 9.99,
          category: category
        )
        product.valid?
        expect(product.errors[:quantity]).to include("can't be blank")
      end
  
      # Test the 'category' validation
      it 'is not valid without a category' do
        product = Product.new(
          name: 'Test Product',
          price: 9.99,
          quantity: 10
        )
        product.valid?
        expect(product.errors[:category]).to include("can't be blank")
      end
    end
end