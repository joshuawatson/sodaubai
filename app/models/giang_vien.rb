class GiangVien < ActiveRecord::Base
  attr_accessible :ho_ten, :hoc_ham, :hoc_vi, :ma_don_vi, :ma_giang_vien, :ma_loai
  #association
  has_many :lop_mon_hocs, :foreign_key => 'ma_giang_vien', :dependent => :destroy, :primary_key => 'ma_giang_vien'
  has_many :tkb_giang_viens, :foreign_key => 'ma_giang_vien', :dependent => :destroy, :primary_key => 'ma_giang_vien' do 
    def with_lop(ma_lop, ma_mon)
      where("tkb_giang_viens.ma_lop = ? and tkb_giang_viens.ma_mon_hoc = ?", ma_lop, ma_mon)
    end
  end

  has_many :lich_trinh_giang_days, :through => :lop_mon_hocs
  has_many :nghi_days, :foreign_key => 'ma_giang_vien', :dependent => :destroy, :primary_key => 'ma_giang_vien'  
  has_one :user, :as => :imageable
  delegate :username, :to => :user
  #validation
  validates :ho_ten, :ma_giang_vien, :presence => true
  validates :ma_giang_vien, :uniqueness => { :case_sensitive => false }
end
