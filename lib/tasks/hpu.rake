require 'pg_tools'
namespace :hpu do
  desc "TODO"
  
  task :load_tkbgiangvien => :environment do
    
  	@client = Savon.client(wsdl: "http://10.1.0.238:8082/HPUWebService.asmx?wsdl")
  	response = @client.call(:tkb_theo_giai_doan)   	
  	res_hash = response.body.to_hash		
  	ls = res_hash[:tkb_theo_giai_doan_response][:tkb_theo_giai_doan_result][:diffgram][:document_element]
  	ls = ls[:tkb_theo_giai_doan]
    GiangVien.delete_all
    ActiveRecord::Base.connection.reset_pk_sequence!('giang_viens') 
    TkbGiangVien.delete_all
    ActiveRecord::Base.connection.reset_pk_sequence!('tkb_giang_viens')	
  	puts "loading... giang_vien"
  	ls.each_with_index do |l,i|
		
  		GiangVien.where(:ho_ten => titleize(l[:ten_giao_vien].strip.downcase), :ma_giang_vien => l[:ma_giao_vien].strip.upcase).first_or_create!
  						
  		tkb = TkbGiangVien.create!(hoc_ky: l[:hoc_ky].strip, ma_giang_vien: l[:ma_giao_vien].strip.upcase, ma_lop: l[:ma_lop].strip.upcase, ma_mon_hoc: l[:ma_mon_hoc].strip.upcase, ten_mon_hoc: titleize(l[:ten_mon_hoc].strip.downcase), nam_hoc: l[:nam_hoc].strip, ngay_bat_dau: l[:tu_ngay].new_offset(Rational(7, 24)), ngay_ket_thuc: l[:ngay_ket_thuc].new_offset(Rational(7, 24)), phong: (l[:ma_phong_hoc].strip if l.has_key?(:ma_phong_hoc) and l[:ma_phong_hoc].is_a?(String)), so_tiet: l[:so_tiet], so_tuan: l[:so_tuan_hoc], thu: l[:thu], tiet_bat_dau: l[:tiet_bat_dau], tuan_hoc_bat_dau: l[:tuan_hoc_bat_dau], ten_giang_vien: titleize(l[:ten_giao_vien].strip.downcase))		
  		  		  		  				
  	end
  
    Rake::Task["hpu:create_lopmonhoc"].invoke 
    Rake::Task["hpu:update_tkb2"].invoke         
  end
  
  task :create_lopmonhoc => :environment do 
    
    LopMonHoc.delete_all
    ActiveRecord::Base.connection.reset_pk_sequence!('lop_mon_hocs') 
    TkbGiangVien.all.each do |tkb|
      l = LopMonHoc.where(:ma_giang_vien => tkb.ma_giang_vien, :ma_lop => tkb.ma_lop, :ma_mon_hoc => tkb.ma_mon_hoc).first_or_create!
      l.update_attributes(ten_giang_vien: tkb.ten_giang_vien, ten_mon_hoc: tkb.ten_mon_hoc, phong_hoc: tkb.phong, ngay_bat_dau: tkb.ngay_bat_dau, ngay_ket_thuc: tkb.ngay_ket_thuc, so_tuan_hoc: tkb.so_tuan)
      l.save rescue puts "error #{l.id}"
    end
    
  end
  task :update_lopghep => :environment do 
#    tenant = Tenant.last
#    PgTools.set_search_path tenant.scheme, false
    tts = {}
    LopGhep.all.each do |lg|
      tts[[lg.ma_lop, lg.ma_mon_hoc]] = lg.ma_lop_ghep
    end
    LopMonHocSinhVien.all.each do |lmh|      
      lmh.ma_lop_ghep = lmh.ma_lop
      if tts[[lmh.ma_lop, lmh.ma_mon_hoc]] then         
        lmh.ma_lop_ghep = tts[[lmh.ma_lop, lmh.ma_mon_hoc]]        
      end
      lmh.save rescue puts "error"
    end
  end
  # cap nhat tkb set days
  task :update_tkb2 => :environment do 
    tenant = Tenant.last
    PgTools.set_search_path tenant.scheme, false
    TkbGiangVien.all.each do |tkb|
      tkb.update_attributes(days: tkb.get_days)
      tkb.save rescue puts "Error #{tkb.ma_lop}"
      #puts tkb.id if tkb.lop_mon_hoc.nil?
    end
  end
  
  
  
  task :load_sv => :environment do     
 #   tenant = Tenant.last
  #  PgTools.set_search_path tenant.scheme, false
    SinhVien.delete_all
    ActiveRecord::Base.connection.reset_pk_sequence!('sinh_viens')
    # attr_accessible :gioi_tinh, :ho_dem, :lop_hc, :ma_he_dao_tao, :ma_khoa_hoc, :ma_nganh, :ma_sinh_vien, :ngay_sinh, :ten, :trang_thai, :ten_nganh

    @client = Savon.client(wsdl: "http://10.1.0.238:8082/HPUWebService.asmx?wsdl")
    response = @client.call(:sinh_vien)
    res_hash = response.body.to_hash
    ls = res_hash[:sinh_vien_response][:sinh_vien_result][:diffgram][:document_element]
    ls = ls[:sinh_vien]  
    puts "loading ... sinh viens"
    ls.each do |l|
      SinhVien.create!(
        gioi_tinh: (l[:gioi_tinh] if l[:gioi_tinh] and l[:gioi_tinh]),
        ho_dem: (titleize(l[:hodem].strip.downcase) if l[:hodem] and l[:hodem].is_a?(String)), 
        lop_hc: (l[:lop].strip.upcase if  l[:lop] and l[:lop].is_a?(String) ) ,
        ma_he_dao_tao: ( titleize(l[:ten_he_dao_tao].strip.downcase) if l[:ten_he_dao_tao] and l[:ten_he_dao_tao].is_a?(String) ),
        ma_khoa_hoc: ( titleize(l[:ten_khoa_hoc].strip.downcase) if l[:ten_khoa_hoc] and l[:ten_khoa_hoc].is_a?(String) ) ,
        ma_sinh_vien: (l[:ma_sinh_vien].strip.upcase if l[:ma_sinh_vien]),
        ngay_sinh: (l[:ngay_sinh].new_offset(Rational(7, 24)) if l[:ngay_sinh]),
        ten: ( titleize(l[:ten].strip.downcase) if l[:ten] and l[:ten].is_a?(String) ),
        trang_thai: (l[:trang_thai] if l[:trang_thai]),
        ten_nganh: ( titleize(l[:ten_nganh].strip.downcase) if l[:ten_nganh] and l[:ten_nganh].is_a?(String))
      )
    end
  end  
  task :load_lopsv => :environment do  
    
  	@client = Savon.client(wsdl: "http://10.1.0.238:8082/HPUWebService.asmx?wsdl")
  	response = @client.call(:lop_mon_hoc_sinh_vien_hk)
  	res_hash = response.body.to_hash
  	ls = res_hash[:lop_mon_hoc_sinh_vien_hk_response][:lop_mon_hoc_sinh_vien_hk_result][:diffgram][:document_element]
  	ls = ls[:lop_mon_hoc_sinh_vien_hk]  
  	LopMonHocSinhVien.delete_all
    ActiveRecord::Base.connection.reset_pk_sequence!('lop_mon_hoc_sinh_viens')
  	puts "loading... lopsv"
    LopMonHocSinhVien.delete_all
    ActiveRecord::Base.connection.reset_pk_sequence!('lop_mon_hoc_sinh_viens') 
  	ls.each do |l|  		
  		lop = LopMonHocSinhVien.create!(ma_lop: l[:malop].strip, ma_mon_hoc: l[:ma_mon_hoc].strip.upcase, ma_sinh_vien: l[:ma_sinh_vien].strip.upcase, ten_mon_hoc: titleize(l[:ten_mon_hoc].strip.downcase), ho_dem: titleize(l[:hodem].strip.downcase), ten: titleize(l[:ten].strip.downcase) ) 	
  	end	
        
  end
 

  
  task :load_tuans => :environment do
    
  	@client = Savon.client(wsdl: "http://10.1.0.238:8082/HPUWebService.asmx?wsdl")
  	response = @client.call(:thoi_gian_tuan)   	
  	res_hash = response.body.to_hash		
  	ls = res_hash[:thoi_gian_tuan_response][:thoi_gian_tuan_result][:diffgram][:document_element]
  	ls = ls[:thoi_gian_tuan]
  	Tuan.delete_all
    ActiveRecord::Base.connection.reset_pk_sequence!('tuans') 
  	puts "loading... tuan"
  	ls.each do |l|		
  		Tuan.create(stt: l[:tuan], tu_ngay: l[:tu_ngay].new_offset(Rational(7, 24)), den_ngay: l[:den_ngay].new_offset(Rational(7, 24)))
  	end
  end
  task :load_lopghep => :environment do 
    
    @client = Savon.client(wsdl: "http://10.1.0.238:8082/HPUWebService.asmx?wsdl")
    response = @client.call(:lop_ghep_hk)    
    res_hash = response.body.to_hash    
    ls = res_hash[:lop_ghep_hk_response][:lop_ghep_hk_result][:diffgram][:document_element]
    ls = ls[:t_lop_ghep_hk]
    LopGhep.delete_all
    ActiveRecord::Base.connection.reset_pk_sequence!('lop_gheps') 
    puts "loading... lop ghep"
    ls.each do |l|
      LopGhep.create!(ma_lop_ghep: l[:ma_lop_ghep].strip, nam_hoc: l[:nam_hoc].strip,
        hoc_ky: l[:hoc_ky], ma_lop: l[:ma_lop].strip, ma_mon_hoc: l[:ma_mon_hoc].strip)
    end
  end

  task :load_all => :environment do 
    tenant = Tenant.last
    PgTools.set_search_path tenant.scheme, false
  	Rake::Task["hpu:load_tuans"].invoke # load tuans
    Rake::Task["hpu:load_lopghep"].invoke 
  	Rake::Task["hpu:load_tkbgiangvien"].invoke  	# load tkb_giang_vien, giang_vien, lop_mon_hoc
  	Rake::Task["hpu:load_lopsv"].invoke # load lop_mon_hoc_sinh_vien, sinh_vien    
    Rake::Task["hpu:update_lopghep"].invoke
    Rake::Task["hpu:update_tong_so_tiet"].invoke  
    Rake::Task["hpu:update_upcase"].invoke  
  end
  task :update_tong_so_tiet => :environment do 
#    tenant = Tenant.last
#    PgTools.set_search_path tenant.scheme, false
    LopMonHoc.all.each do |lop|
      lop.so_tiet = lop.tong_so_tiet
      lop.save! rescue "Save error #{lop.id}"
    end
  end
  task :update_upcase => :environment do 
   # tenant = Tenant.last
   # PgTools.set_search_path tenant.scheme, false
    LopMonHoc.all.each do |lop|
      lop.ma_giang_vien = lop.ma_giang_vien.strip.upcase
      lop.ma_lop = lop.ma_lop.strip.upcase
      lop.ma_mon_hoc = lop.ma_mon_hoc.strip.upcase
      lop.save! rescue "Save error #{lop.id}"
    end
    LopMonHocSinhVien.all.each do |lmh|
      lmh.ma_lop_ghep = lmh.ma_lop_ghep.strip.upcase
      lmh.ma_lop = lmh.ma_lop.strip.upcase
      lmh.ma_mon_hoc = lmh.ma_mon_hoc.strip.upcase
      lmh.ma_sinh_vien = lmh.ma_sinh_vien.strip.upcase
      lmh.save!
    end
    GiangVien.all.each do |gv|
      gv.ma_giang_vien = gv.ma_giang_vien.strip.upcase
      gv.save!
    end
    SinhVien.all.each do |sv|
      sv.ma_sinh_vien = sv.ma_sinh_vien.strip.upcase
      sv.save!
    end
    TkbGiangVien.all.each do |tkb|
      tkb.ma_lop = tkb.ma_lop.strip.upcase
      tkb.ma_mon_hoc = tkb.ma_mon_hoc.strip.upcase
      tkb.ma_giang_vien = tkb.ma_giang_vien.strip.upcase
      tkb.phong = tkb.phong.strip.upcase if tkb.phong
      tkb.save!
    end
    LopGhep.all.each do |lgh|
      lgh.ma_lop = lgh.ma_lop.strip.upcase
      lgh.ma_mon_hoc = lgh.ma_mon_hoc.strip.upcase
      lgh.ma_lop_ghep = lgh.ma_lop_ghep.strip.upcase
      lgh.save!
    end
  end
  task :test_gv => :environment do 
    
    GiangVien.all.each do |gupatev|
      puts gv.ma_giang_vien if gv.days = nil
    end
  end
  task :create_tenant => :environment do 
   
      
      t = Tenant.where(:nam_hoc => '2013-2014', :hoc_ky => 1, :scheme => 't1').first_or_create!
      
   
  end
end
def titleize(str)
  str.split(" ").map(&:capitalize).join(" ").gsub("Ii","II")
end