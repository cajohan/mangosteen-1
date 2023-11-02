require 'rails_helper'

RSpec.describe User, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  it 'have email' do   #
    user = User.new email: 'john@1.com'
    expect(user.email).to eq 'john@1.com'  # test code
  end
end
