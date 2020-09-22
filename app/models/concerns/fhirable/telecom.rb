# frozen_string_literal: true

module FHIRable
  module Telecom
    extend ActiveSupport::Concern

    def fhirable_telecom
      [
        fhirable_telecom_phone,
        fhirable_telecom_cellular,
        fhirable_telecom_email
      ]
    end

    private

    def fhirable_telecom_cellular
      return unless cellular

      {
        'use': 'mobile',
        'system': 'phone',
        'value': Phonelib.parse(cellular).e164
      }
    end

    def fhirable_telecom_email
      return if email.blank?

      {
        'use': 'home',
        'system': 'email',
        'value': email
      }
    end

    def fhirable_telecom_phone
      return unless phone

      {
        'use': 'home',
        'system': 'phone',
        'value': Phonelib.parse(phone).e164
      }
    end
  end
end
