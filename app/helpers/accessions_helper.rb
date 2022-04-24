# frozen_string_literal: true

module AccessionsHelper
  def practitioner(doctor)
    if doctor
      concat t('.doctor')
      tag.strong(doctor.name)
    else
      tag.strong(t('.outpatient'))
    end
  end

  def email_report(recipient, diagnostic_report, email)
    resend = case recipient
             when :practitioner
               diagnostic_report.emailed_doctor_at?
             when :patient
               diagnostic_report.emailed_patient_at?
             end
    email_report_link = resend ? t('.emailed_report') : t('.email_report')
    email_report_confirm = resend ? t('.confirm_emailed', email: email) : t('.confirm_email', email: email)
    link_to email_report_link, email_diagnostic_report_path(diagnostic_report, to: recipient),
            data: { turbo_method: :put, turbo_confirm: email_report_confirm }
  end

  def force_certify_diagnostic_report(diagnostic_report)
    button_to t('.force_certify'), force_certify_diagnostic_report_path(diagnostic_report),
            method: :patch, form: { data: { turbo_confirm: t('.confirm_forceful_certify') } }
  end

  def change_or_enter_results(diagnostic_report)
    if diagnostic_report.final? || diagnostic_report.amended?
      t('.change_results')
    else
      t('.enter_results')
    end
  end

  def search_icd_code
    link_to t('.search_icd_code'), 'http://ais.paho.org/classifications/Chapters/',
            target: :_blank, rel: :noopener, id: :search_icd_code
  end
end
