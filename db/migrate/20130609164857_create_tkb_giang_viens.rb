class CreateTkbGiangViens < ActiveRecord::Migration
  def change    
    create_table :tkb_giang_viens do |t|
      t.string :ma_giang_vien
      t.string :ma_lop
      t.string :ma_mon_hoc
      t.string :phong
      t.string :nam_hoc
      t.integer :hoc_ky
      t.integer :tuan_hoc_bat_dau
      t.integer :so_tuan
      t.datetime :ngay_bat_dau
      t.datetime :ngay_ket_thuc
      t.integer :so_tiet
      t.integer :tiet_bat_dau
      t.integer :thu

      t.timestamps
    end
  end
end
