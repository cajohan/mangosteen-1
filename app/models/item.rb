# encoding: UTF-8

class Item < ApplicationRecord
  paginates_per 25
  enum kind: { expenses: 1, income: 2 }
  validates :amount, presence: true
  validates :kind, presence: true
  validates :happen_at, presence: true
  validates :tag_ids, presence: true

  belongs_to :user

  validate :check_tag_ids_belong_to_user

  def check_tag_ids_belong_to_user
    all_tag_ids = Tag.where(user_id: self.user_id).map(&:id)
    # 如果不在里面
    if self.tag_ids & all_tag_ids != self.tag_ids
      self.errors.add :tag_id, "不属于当前用户"
    end
  end
end
