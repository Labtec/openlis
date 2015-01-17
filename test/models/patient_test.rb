require 'test_helper'

class PatientTest < ActiveSupport::TestCase
  setup do
    @alice = create(:patient, given_name: 'Alice', identifier: '111-111-1111')
    @bob = create(:patient, given_name: 'Bob', identifier: '222-222-2222')
  end

  test 'search with empty string returns all records' do
    search = Patient.search('')
    assert_includes(search, @alice)
    assert_includes(search, @bob)
  end

  test 'search for patients by ID' do
    search = Patient.search('111-111-1111')
    assert_includes(search, @alice)
    assert_not_includes(search, @bob)
  end

  test 'search for patients with an incomplete ID' do
    search = Patient.search('111-111-11')
    assert_not_includes(search, @alice)
  end

  test 'search for patients by given name' do
    search = Patient.search('alice')
    assert_includes(search, @alice)
    assert_not_includes(search, @bob)
  end

  test 'search for patients with accents in their name' do
    angel = create(:patient, given_name: 'Ángel')
    search = Patient.search('angel')
    assert_includes(search, angel)
    assert_not_includes(search, @bob)
  end

  test 'search for patients with multiple argumets' do
    alicia = create(:patient, given_name: 'Alicia', middle_name: 'Alice')
    search = Patient.search('alice alicia')
    assert_includes(search, alicia)
    assert_not_includes(search, @alice)
  end
end
