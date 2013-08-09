require 'json'
class GiangVien < ActiveRecord::Base
  attr_accessible :ho_ten, :hoc_ham, :hoc_vi, :ma_don_vi, :ma_giang_vien, :ma_loai, :days
  #association
  has_many :lop_mon_hocs, :foreign_key => 'ma_giang_vien', :dependent => :destroy, :primary_key => 'ma_giang_vien'
  has_many :tkb_giang_viens, :foreign_key => 'ma_giang_vien', :dependent => :destroy, :primary_key => 'ma_giang_vien' do 
    def with_lop(ma_lop, ma_mon)
      where("tkb_giang_viens.ma_lop = ? and tkb_giang_viens.ma_mon_hoc = ?", ma_lop, ma_mon)
    end
    def tuans
      group(:tuan_hoc_bat_dau).count
    end
  end

  has_many :lich_trinh_giang_days, :through => :lop_mon_hocs
  has_many :nghi_days, :foreign_key => 'ma_giang_vien', :dependent => :destroy, :primary_key => 'ma_giang_vien'  
  has_one :user, :as => :imageable
  
  #validation
  validates :ho_ten, :ma_giang_vien, :presence => true
  validates :ma_giang_vien, :uniqueness => { :case_sensitive => false }
  def to_s
    "#{ho_ten} #{ma_giang_vien}"
  end
  def get_days
    ngays = []
    if tkb_giang_viens.count > 0 
      tkb_giang_viens.all.each do |tkb|
        ngay = JSON.parse(tkb.days)["ngay"]
        ngays = ngays + ngay
      end
      ngays = ngays.sort_by {|h| [h["tuan"], h["time"]]}
    end
    return {:ngay => ngays}
  end
end
