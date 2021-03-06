#encoding: utf-8
class DashboardController < ApplicationController

  
  before_filter :load_lops, :except => [:search]
  def index    

    @current_lich = @lich.select {|l| l["tuan"] == @current_week}.uniq if @lich
    @current_lich2 = @lich2.select {|l| l["tuan"] == @current_week}.uniq if @lich2
    
    @lichbus = @lichbosungs.select {|l| l.loai == 2 and l.status == 3 and l.tuan == @current_week}
  
  end



  def show
    
    @current_lich = @lich.select {|l| l["tuan"] == params[:id].to_i}.uniq if @lich 
    @current_lich2 = @lich2.select {|l| l["tuan"] == @current_week}.uniq if @lich2    
  end
  def calendar
    @lichbus = @lichbosungs.select {|l| l.loai == 2 and l.status == 3}
  end
  def search
    @type = params[:type]
    @keyword = params[:search]
    if params[:type] == '1'
      @search = Sunspot.search(SinhVien) do 
        fulltext params[:search]
        SinhVien::FACETS.each do |f|
          facet(f)
        end        
        with(:lop_hc, params[:lop_hc]) if params[:lop_hc].present?
        with(:ten, params[:ten]) if params[:ten].present?
        with(:ten_nganh, params[:ten_nganh]) if params[:ten_nganh].present?
        with(:ma_khoa_hoc, params[:ma_khoa_hoc]) if params[:ma_khoa_hoc].present?
        paginate(:page => params[:page] || 1, :per_page => 50)
      end
      @results = @search.results
    elsif params[:type] == '2'
      @search = Sunspot.search(LopMonHoc) do 
        fulltext params[:search]
        
        LopMonHoc::FACETS.each do |f|
          facet(f)
        end        
        with(:ten_mon_hoc, params[:ten_mon_hoc]) if params[:ten_mon_hoc].present?
        with(:ten_giang_vien, params[:ten_giang_vien]) if params[:ten_giang_vien].present?
        with(:phong_hoc, params[:phong_hoc]) if params[:phong_hoc].present?
        paginate(:page => params[:page] || 1, :per_page => 50)
      end
      @results = @search.results
    end
    respond_to do |format|      
      format.html      
    end
  end
  protected
  def to_zdate(str)
    DateTime.strptime(str.gsub("T","-").gsub("Z",""), "%Y-%m-%d-%H:%M").change(:offset => Rational(7,24))
  end
  def load_lops    
    
    
    @type = current_user.imageable
    if @type        	
    	@current_lops = @type.lop_mon_hocs
      
      @lich = @type.get_days[:ngay].uniq if @type.get_days

      @lichbosungs = @type.lich_trinh_giang_days.select {|l| [1,2,3,4].include?(l.loai)}

      generator = ColorGenerator.new saturation: 0.3, lightness: 0.75
      @color = [] 
      20.times do |i|
        @color << generator.create_hex
      end
      @color_map = {}
      @info = {}
      unless @current_lops.empty?
        @current_lops.each_with_index do |l,i|
          @color_map["#{l.ma_lop}-#{l.ma_mon_hoc}"] = @color[i] if l 
        end           
      end
      unless @lichbosungs.empty?
        @lichbosungs.each_with_index do |l,i|
          @color_map["#{l.ngay_day.localtime.strftime('%Y-%m-%d-%H:%M')}"] = "A00000"
          @info["#{l.ngay_day.localtime.strftime('%Y-%m-%d-%H:%M')}"] = l.info
        end
      end
    else
      @current_lops = []
    end


    
    @current_lops2 = current_user.lop_mon_hocs
    @lichbosungs = current_user.lich_trinh_giang_days.select {|l| [1,2,3,4].include?(l.loai)}
    @lich2 = current_user.get_days[:ngay].uniq if current_user.get_days
    
    generator = ColorGenerator.new saturation: 0.2, lightness: 0.8
    @color2 = [] 
    20.times do |i|
      @color2 << generator.create_hex
    end
    @color_map2 = {}
    @info2 = {}
    unless @current_lops2.empty?
      @current_lops2.each_with_index do |l,i|
        @color_map2["#{l.ma_lop}-#{l.ma_mon_hoc}"] = @color2[i] if l 
      end           
    end
    unless @lichbosungs.empty?
      @lichbosungs.each_with_index do |l,i|
        @color_map2["#{l.ngay_day.localtime.strftime('%Y-%m-%d-%H:%M')}"] = "A00000"
        @info2["#{l.ngay_day.localtime.strftime('%Y-%m-%d-%H:%M')}"] = l.info
      end
    end
  end

end
