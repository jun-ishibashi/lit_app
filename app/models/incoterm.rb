# frozen_string_literal: true

# インコタームズ（貿易条件）。見積・比較時に条件を揃えるために使用
class Incoterm < ActiveHash::Base
  self.data = [
    { id: 1, name: '--', code: '' },
    { id: 2, name: 'EXW（工場渡し）', code: 'EXW' },
    { id: 3, name: 'FCA（運送人渡し）', code: 'FCA' },
    { id: 4, name: 'FOB（本船積込渡し）', code: 'FOB' },
    { id: 5, name: 'CFR（運賃込み）', code: 'CFR' },
    { id: 6, name: 'CIF（運賃・保険込み）', code: 'CIF' },
    { id: 7, name: 'CPT（輸送費込み）', code: 'CPT' },
    { id: 8, name: 'CIP（輸送費・保険込み）', code: 'CIP' },
    { id: 9, name: 'DAP（指定地持込渡し）', code: 'DAP' },
    { id: 10, name: 'DDP（関税込持込渡し）', code: 'DDP' }
  ]

  include ActiveHash::Associations
  has_many :services
  has_many :quote_requests

  def self.selectable
    all.reject { |i| i.id == 1 }
  end
end
