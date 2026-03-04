# frozen_string_literal: true

# 海外貿易で重要な「作業範囲」：通関まで含むか、運送のみか等
class ServiceScope < ActiveHash::Base
  self.data = [
    { id: 1, name: '--', description: '' },
    { id: 2, name: '通関込み', description: '輸出・輸入の通関手続きを含む' },
    { id: 3, name: '輸出通関のみ', description: '輸出側の通関手続きを含む' },
    { id: 4, name: '輸入通関のみ', description: '輸入側の通関手続きを含む' },
    { id: 5, name: '通関なし（運送のみ）', description: '輸送のみ。通関は依頼者または別業者' },
    { id: 6, name: 'ドア to ドア', description: 'pick up から delivery まで一貫（通関の有無は説明欄で補足）' },
    { id: 7, name: '港 to 港', description: 'CY/CY など港間の本船運賃が中心' }
  ]

  include ActiveHash::Associations
  has_many :services

  # 選択肢から「--」を除く（登録・編集フォーム用）
  def self.selectable
    all.reject { |s| s.id == 1 }
  end
end
