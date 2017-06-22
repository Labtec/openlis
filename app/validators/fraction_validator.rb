# frozen_string_literal: true

# Validates fraction result format
class FractionValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value.match?(/\A(\d+)\/(\d+)\z/)
      record.errors[attribute] << (options[:message] || I18n.t(:fraction, scope: %i[errors messages]))
    end
  end
end
