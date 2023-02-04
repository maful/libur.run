# frozen_string_literal: true

module Religion
  extend ActiveModel::Translation

  RELIGION_LIST = {
    islam: 0,
    christianity: 1,
    hinduism: 2,
    buddhism: 3,
    judaism: 4,
    sikhism: 5,
    jainism: 6,
    shinto: 7,
    other: 8,
    not_to_say: 9,
  }.freeze

  def religion_name
    return nil if religion.blank?

    Religion.human_attribute_name("name.#{religion}")
  end
end
