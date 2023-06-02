# frozen_string_literal: true

module COVIDObservation
  extend ActiveSupport::Concern

  LOINC_COVID_TEST_CODES = %w[50548-7 68993-5 82159-5 94306-8 94307-6 94308-4 94309-2 94500-6 94502-2 94503-0 94504-8 94507-1 94508-9 94531-1 94533-7 94534-5 94547-7 94558-4 94559-2 94562-6 94563-4 94564-2 94565-9 94640-0 94661-6 94756-4 94757-2 94758-0 94759-8 94760-6 94761-4 94762-2 94764-8 94845-5 95209-3 95406-5 95409-9 95416-4 95423-0 95424-8 95425-5 95542-7 95608-6 95609-4].freeze

  def covid?
    LOINC_COVID_TEST_CODES.include? lab_test_loinc
  end
end
