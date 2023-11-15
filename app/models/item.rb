class Item < ApplicationRecord
  enum kind: {expenses: 1, income: 2 }
  validates :amount, presence: true
  validates :kind, presence: true
  validates :happen_at, presence: true
  validates :tags_id, presence: true

  validate :check_tags_id_belong_to_user

  def check_tags_id_belong_to_user
    all_tag_ids = Tag.where(user_id: self.user_id).map(&:id)
    # 如果不在里面
    if self.tags_id & all_tag_ids != self.tags_id 
      self.errors.add :tag_id, '不属于当前用户'
    end
  end
end