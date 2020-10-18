# frozen_string_literal: true

module ObservationsHelper
  def doctor_name(doctor)
    if doctor
      t('.doctor')
      tag.strong(doctor.name)
    else
      tag.strong(t('.outpatient'))
    end
  end

  def format_value(observation)
    if observation.lab_test.derivation?
      number_with_precision(observation.derived_value, precision: observation.lab_test_decimals, delimiter: ',') || 'calc.'
    elsif observation.lab_test_value && observation.value.present?
      [observation.lab_test_value.value,
       ' [',
       number_with_precision(observation.value, precision: observation.lab_test_decimals, delimiter: ','),
       ']'].join
    elsif observation.lab_test_value
      observation.lab_test_value.value
    elsif observation.value.blank?
      'pend.'
    elsif observation.lab_test.ratio?
      observation.value.tr(':', '∶')
    elsif observation.lab_test.range?
      observation.value.tr('-', '–')
    elsif observation.lab_test.fraction?
      observation.value.gsub(%r{/}, ' ∕ ')
    elsif observation.lab_test.text_length?
      observation.value
    else
      number_with_precision(observation.value, precision: observation.lab_test_decimals, delimiter: ',')
    end
  end

  def format_units(observation)
    observation.unit_name unless observation.lab_test_value &&
                                 !observation.lab_test_value.numeric? &&
                                 observation.value.blank?
  end

  def flag_name(observation)
    case observation.flag
    when '<'
      t('results.off_scale_low')
    when '>'
      t('results.off_scale_high')
    when 'A'
      t('results.abnormal')
    when 'AA'
      t('results.abnormal') * 2
    when 'DET'
      t('results.detected')
    when 'E'
      t('results.equivocal')
    when 'H'
      t('results.high')
    when 'HH'
      t('results.high') * 2
    when 'I'
      t('results.intermediate')
    when 'IND'
      t('results.indeterminate')
    when 'L'
      t('results.low')
    when 'LL'
      t('results.low') * 2
    when 'N'
      t('results.normal')
    when 'ND'
      t('results.not_detected')
    when 'NEG'
      t('results.negative')
    when 'NR'
      t('results.non_reactive')
    when 'NS'
      t('results.non_susceptible')
    when 'POS'
      t('results.positive')
    when 'R'
      t('results.resistant')
    when 'RR'
      t('results.reactive')
    when 'S'
      t('results.susceptible')
    when 'WR'
      t('results.weakly_reactive')
    end
  end

  def flag_color(observation)
    case observation.flag
    when *LabTestValue::ABNORMAL_FLAGS
      'abnormal_value'
    when *LabTestValue::HIGH_FLAGS
      'high_value'
    when *LabTestValue::LOW_FLAGS
      'low_value'
    else
      'normal_value'
    end
  end

  def ranges_table(ranges)
    tag.table do
      tag.tbody do
        safe_join(ranges.collect do |range|
          tag.tr do
            range.each_with_index do |column, index|
              concat tag.td(column, class: "range_#{index}")
            end
          end
        end)
      end
    end
  end

  def registration_number(inline: false)
    if current_user.register.present?
      if inline
        " / #{t('results.index.register')} #{current_user.register}"
      else
        "#{t('results.index.register')} #{current_user.register}"
      end
    else
      ''
    end
  end

  def observation_input(builder, observation, lab_test)
    if lab_test.derivation?
      text_field_tag :value, format_value(observation), disabled: true
    elsif lab_test.lab_test_values.empty?
      builder.text_field :value
    else
      builder.collection_select(:lab_test_value_id,
                                lab_test.lab_test_values,
                                :id, :stripped_value,
                                include_blank: true) +
        (builder.text_field(:value) if result_types?(lab_test))
    end
  end

  # value -> value_quantity, value_integer
  # lab_test_value -> value_codeable_concept
  # also_numeric -> multiple_results_allowed
  # range -> value_range
  # ratio -> value_ratio
  # fraction -> value_ratio
  # text_length -> value_string
  def result_types?(lab_test)
    lab_test.also_numeric? ||
      lab_test.ratio? || lab_test.range? || lab_test.fraction? || lab_test.text_length.present?
  end

  def not_performed_class(not_performed)
    'not-performed' if not_performed
  end

  def row_class
    cycle('even', 'odd', name: 'alternating_row_colors')
  end
end
