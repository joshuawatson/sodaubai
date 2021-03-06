# encoding: UTF-8
class LopMonHocsController < ApplicationController  
  
  include DashboardHelper
  include LopMonHocsHelper  
  before_filter :authenticate_user!
  before_filter :load_lop, :except => :index
  
  def tinhhinh
    authorize! :manage, @lop_mon_hoc  
    sql = <<-eos  
        select row_number() OVER(ORDER BY t.ten, t.ho_dem, t.ho) as "stt", t."msv",
concat(t."ho" ,' ', t.ho_dem,' ', t.ten) as "hovaten",  to_char(t.ngay_sinh,'DD/MM/YYYY' ) as "ngaysinh",
case when t."T1"=0 then NULL else t."T1" end as "T1", case when t."T2"=0 then NULL else t."T2" end as "T2", 
case when t."T3"=0 then NULL else t."T3" end as "T3", case when t."T4"=0 then NULL else t."T4" end as "T4",
case when t."T5"=0 then NULL else t."T5" end as "T5", case when t."T6"=0 then NULL else t."T6" end as "T6", 
case when t."T7"=0 then NULL else t."T7" end as "T7", case when t."T8"=0 then NULL else t."T8" end as "T8", 
case when t."T9"=0 then NULL else t."T9" end as "T9", case when t."T10"=0 then NULL else t."T10" end as "T10", 
case when t."T11"=0 then NULL else t."T11" end as "T11", case when t."T12"=0 then NULL else t."T12" end as "T12",
case when t."T13"=0 then NULL else t."T13" end as "T13", case when t."T14"=0 then NULL else t."T14" end as "T14",
case when t."T15"=0 then NULL else t."T15" end as "T15", case when t."T16"=0 then NULL else t."T16" end as "T16",
COALESCE("T1",0) + COALESCE("T2",0)+ COALESCE("T3",0)+ COALESCE("T4",0)
    + COALESCE("T5",0)+ COALESCE("T6",0)+ COALESCE("T7",0)+ COALESCE("T8",0)+ COALESCE("T9",0)+ COALESCE("T10",0)
    + COALESCE("T11",0)+ COALESCE("T12",0)+ COALESCE("T13",0)+ COALESCE("T14",0)+ COALESCE("T15",0)
    + COALESCE("T16",0) as tonggiovang, t.diemchuyencan, t.diemthuchanh,
    t.lan1 as lan1, t.lan2 as lan2, t.lan3 as lan3, t.diemtbkt,  t.diemquatrinh,
    t.note as note
 from 
(SELECT "msv", sv1.ho, sv1.ho_dem, sv1.ten, sv1.ngay_sinh , "T1", "T2", "T3", "T4", "T5", "T6", "T7", "T8", "T9", "T10", "T11",
    "T12", "T13", "T14", "T15", "T16",  COALESCE("T1",0) + COALESCE("T2",0)+ COALESCE("T3",0)+ COALESCE("T4",0)
    + COALESCE("T5",0)+ COALESCE("T6",0)+ COALESCE("T7",0)+ COALESCE("T8",0)+ COALESCE("T9",0)+ COALESCE("T10",0)
    + COALESCE("T11",0)+ COALESCE("T12",0)+ COALESCE("T13",0)+ COALESCE("T14",0)+ COALESCE("T15",0)
    + COALESCE("T16",0) as tonggiovang, sv1.diem_chuyen_can as diemchuyencan, sv1.diem_thuc_hanh as diemthuchanh,
    sv1.lan1 as lan1, sv1.lan2 as lan2, sv1.lan3 as lan3, sv1.diem_tbkt as diemtbkt,  sv1.diem_qua_trinh as diemquatrinh,
    sv1.note as note
    FROM crosstab(
      'select dd.ma_sinh_vien, l.tuan, sum(so_tiet_vang) as so_vang
    from t1.diem_danhs dd
    inner join t1.lich_trinh_giang_days l on l.id = dd.lich_trinh_giang_day_id
    where l.lop_mon_hoc_id = #{@lop_mon_hoc.id}
    and dd.so_tiet_vang > 0
    group by ma_sinh_vien, tuan
    order by 1,2',
    'select m from generate_series(1,16) m')
    AS ("msv" text, "T1" int, "T2" int, "T3" int, "T4" int, "T5" int, "T6" int, "T7" int, "T8" int, "T9" int, "T10" int
    , "T11" int, "T12" int, "T13" int, "T14" int, "T15" int, "T16" int)
    inner join t1.lop_mon_hoc_sinh_viens sv1 on sv1.ma_sinh_vien = msv and sv1.lop_mon_hoc_id = 183

    union all
    select ma_sinh_vien as "msv", ho, ho_dem, ten, ngay_sinh, 0 as "T1", 0 as "T2", 
    0 as "T3", 0 as "T4", 0 as "T5", 0 as "T6", 
0 as "T7", 0 as "T8", 0 as "T9", 0 as "T10", 0 as "T11", 0 as "T12", 
0 as "T13", 0 as "T14", 0 as "T15", 0 as "T16", 0 as tongiovang , diem_chuyen_can , diem_thuc_hanh as diemthuchanh,
lan1, lan2, lan3, diem_tbkt as diemtbkt, diem_qua_trinh as diemquatrinh, note as note
from t1.lop_mon_hoc_sinh_viens where lop_mon_hoc_id=183 and ma_sinh_vien not in (select dd.ma_sinh_vien
    from t1.diem_danhs dd
    inner join t1.lich_trinh_giang_days l on l.id = dd.lich_trinh_giang_day_id
    where l.lop_mon_hoc_id = #{@lop_mon_hoc.id}
    and dd.so_tiet_vang > 0)
 ) as t
 order by t.ten, t.ho_dem, t.ho, t.ngay_sinh
    eos
    @res = ActiveRecord::Base.connection.execute(sql)    
    respond_to do |format|
      format.pdf do 
        pdf = Prawn::Document.new(:page_layout => :landscape,         
        :page_size => 'A4')
        #pdf.font "#{Rails.root}/app/assets/fonts/arial.ttf"
        pdf.font_families.update(
          'Arial' => { :normal => Rails.root.join('app/assets/fonts/arial2.ttf').to_s,
                       :bold   => Rails.root.join('app/assets/fonts/arialbd.ttf').to_s,
                       :italic => Rails.root.join('app/assets/fonts/arialbi.ttf').to_s}                       
        )
       # items = @res.map do |item|
        #  [
        #    item["stt"],
        #    item["msv"],            
        #    item["hovaten"],
        #    item["ngaysinh"],
        #    item["T1"],item["T2"],item["T3"],item["T4"],item["T5"],item["T6"],item["T7"],item["T8"],item["T9"],item["T10"],item["T11"],item["T12"],item["T13"],item["T14"],item["T15"],item["T16"],
         #   item["tonggiovang"], item["diemchuyencan"], item["diemthuchanh"], item["lan1"], item["lan2"], item["lan3"], item["diemtbkt"], item["diemqt"], item["note"]
        #  ]        
        #end
        m = @res.each_slice(20)

        m.each do |m1|
          pdf.font "Arial"
          pdf.text "BẢNG THEO DÕI TÌNH HÌNH MÔN HỌC", :align => :center, :style => :bold
          pdf.move_down(10)
        items1 = m1.map {|i| [i["stt"], i["msv"], i["hovaten"], i["ngaysinh"]]}        
        mtable01 = pdf.make_table [["Stt", "Mã SV", "Họ và tên", "Ngày sinh"]], :width => 180, :cell_style => {:align => :center, :valign => :center, :size => 6, :height => 40}, :column_widths => {1 => 45, 2 => 75, 3 => 40}, :header => true
        mtable02 = pdf.make_table items1, :width => 180, :cell_style => {:align => :center, :valign => :center, :size => 6, :height => 20 }, :column_widths => {1 => 45, 2 => 75, 3 => 40}, :header => true do 
          (0..items1.length).each do |l|
            row(l).columns(2).align = :left
          end
        end

        items2 = m1.map {|item| 
          [item["T1"],item["T2"],item["T3"],item["T4"],item["T5"],item["T6"],item["T7"],item["T8"],item["T9"],item["T10"],item["T11"],item["T12"],item["T13"],item["T14"],item["T15"],item["T16"],
            item["tonggiovang"], item["diemchuyencan"]]}
        items3 = @res.map {|item| [item["lan1"], item["lan2"], item["lan3"], item["diemtbkt"]]}        
        mytable0 = pdf.make_table [["Điểm danh"]], :width => 360, :cell_style => {:align => :center, :valign => :center, :size => 6, :height => 20}, :header => true
        mytable01 = pdf.make_table [["T1","T2","T3","T4","T5","T6","T7","T8","T9","T10","T11","T12","T13","T14","T15","T16","Tổng giờ vắng", "Điểm chuyên cần"]] + items2, :width => 360, :cell_style => {:align => :center, :valign => :center, :size => 6, :height => 20}, :header => true do 
          (0..items2.length).each do |l|            
            row(l).columns(16).width = 20
            row(l).columns(17).width = 20
          end
          row(0).columns(16).size = 3.5
          row(0).columns(17).size = 3.5
        end

        items3 = m1.map {|i| [i["diemthuchanh"]]}        
        mtable11 = pdf.make_table [["Điểm TH, TN, BTL, ĐA"]] + items3, :width => 20, :cell_style => {:align => :center, :valign => :center, :size => 6, :height => 20} do           
            row(0).columns(0).height = 40
            row(0).columns(0).size = 3.5          
        end

        items4 = m1.map {|i| [i["lan1"], i["lan2"], i["lan3"], i["diemtbkt"]]}
        mtable2 = pdf.make_table [["Điểm kiểm tra thường xuyên"]], :width => 80, :cell_style => {:align => :center, :valign => :center, :size => 3.5, :height => 20}
        mtable21 = pdf.make_table [["Lần 1", "Lần 2", "Lần 3", "TB Kiểm tra"]] + items4, :width => 80, :cell_style => {:align => :center, :valign => :center, :size => 6, :height => 20} do 
          (0..3).each do |i|
            row(0).columns(i).size = 3.5
          end
        end
        
        items5 = m1.map {|i| [i["diemquatrinh"], i["note"]]}        
        mtable31 = pdf.make_table [["Tổng điểm QT", "Ghi chú"]] + items5, :cell_style => {:align => :center, :valign => :center, :size => 6, :height => 20} do           
            (0..1).each do |i|
              row(0).columns(i).height = 40
              row(0).columns(i).size = 3.5          
            end
            (0..items5.length).each do |t|
              row(t).columns(0).width = 20
              row(t).columns(1).width = 30
            end
        end
        
        #mytable1 = pdf.make_table [[mytable0],[mytable01]]

        #mtable0 = pdf.make_table [["Điểm kiểm tra thường xuyên"]], :width => 80, :cell_style => {:align => :center, :size => 7}
        #mtable01 = pdf.make_table [["Lần 1", "Lần 2", "Lần 3", "TB Kiểm tra"]] + items3, :width => 80, :cell_style => {:align => :center, :size => 7}
        pdf.table [ 
          [
            [
              [mtable01],[mtable02]
            ],            
            [
              [mytable0],[mytable01]
            ],
            [
              [mtable11]
            ],
            [
              [mtable2],[mtable21]
            ],
            [
              [mtable31]
            ]
          ]
        ]
        pdf.start_new_page
      end
        
        #items.unshift ["Stt","Mã SV","Họ và tên","Ngày sinh",mytable1, "Điểm TH, TN, BTL, ĐA", mtable1, "Tổng điểm QT", "Ghi chú"]
        
                
        send_data pdf.render, filename: "lich_trinh_lop_#{@lop_mon_hoc.ma_lop}_#{@lop_mon_hoc.ten_giang_vien}.pdf", 
                          type: "application/pdf"
      end
    end
  end
  def lichtrinh
    authorize! :manage, @lop_mon_hoc    
    #output = LichReport.new(@lop_mon_hoc).to_pdf    
    @lichs = @lop_mon_hoc.lich_trinh_giang_days.where('char_length(noi_dung_day) > 0').order('ngay_day, tuan')
    respond_to do |format|
      format.pdf do
        pdf = Prawn::Document.new(:page_layout => :portrait,         
        :page_size => 'A4')
        pdf.font "#{Rails.root}/app/assets/fonts/arial.ttf"
        
        items = @lichs.map do |item|
          [
            item.tuan,            
            item.noi_dung_day,
            item.so_tiet_day_moi,
            item.hienthingay                    
          ]
        end        
        items.unshift ["Tuần","NỘI DUNG GIẢNG DẠY","Số tiết","Thứ ngày thực hiện"]
        cell_width = 50
        row_height = 120
        img_path = "#{Rails.root}/public/images/logo.png"
        pieces = [[img_path, ""]]
        pieces.each do |p|
          #pdf.move_down 5 # a bit of padding
          cursor = pdf.cursor 
          p.each_with_index do |v,j|
             pdf.bounding_box [cell_width*j, cursor], :height => row_height, :width => ( j == 0 ? cell_width : 600) do
              if j == 0
                pdf.image v, :width => 40
              else
                #pdf.text v, :size => 10 unless v.blank?
                dd = [["BỘ GIÁO DỤC VÀ ĐÀO TẠO","","CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM"],["TRƯỜNG ĐẠI HỌC DÂN LẬP HẢI PHÒNG","","Độc lập - Tự do - Hạnh phúc"]]
                pdf.table dd, :cell_style => {:borders => [], size: 12}, :column_widths => {1 => 50}  do
                  
                  dd.count.times do |t|
                    [0,1,2].each do |k|
                      row(t).columns(k).valign = :center                      
                      row(t).columns(k).align = :center                                 
                    end                  
                  end                                    
                  row(0).columns(1).size = 12
                  row(1).columns(1).size = 13
                end
              end
            end
          end
        end
        # header
        pdf.bounding_box [pdf.bounds.left, pdf.bounds.top], :width  => pdf.bounds.width do               
            pdf.move_down(80)
            pdf.text "LỊCH GIẢNG DẠY", :align => :center, :size => 16
            pdf.move_down(30)
            data = [
              ["Số tuần lễ", "","#{@lop_mon_hoc.sotuan}","", "Môn học: #{@lop_mon_hoc.ten_mon_hoc}"],
              ["Số tiết lý thuyết", "","...","", "CBGD phục trách: #{@lop_mon_hoc.ten_giang_vien}"],
              ["Số tiết BT,TN,TH,TKMH ","","...","", "Ngành: ........... Khóa: .........."],
              ["Tổng số tiết","","#{@lop_mon_hoc.khoi_luong}","", "Lớp: #{@lop_mon_hoc.ma_lop} Học kỳ: #{@current_tenant.hoc_ky} Năm học: #{@current_tenant.nam_hoc}"]
            ]
            pdf.table data, :cell_style => {:borders => [], :size => 13}, :column_widths => {0 => 200, 2 => 30, 3 => 30} do               
              4.times do |t|
                row(t).columns(2).align = :center
              end
              row(0).columns(0).borders = [:top, :left]
              row(0).columns(1).borders = [:top]
              row(0).columns(2).borders = [:top, :right]
              row(0).columns(3).size = 13

              row(1).columns(0).borders = [:left]
              row(1).columns(1).borders = []
              row(1).columns(2).borders = [:right]
              row(1).columns(3).size = 13

              row(2).columns(0).borders = [:left]
              row(2).columns(1).borders = []
              row(2).columns(2).borders = [:right]
              row(2).columns(3).size = 13

              row(3).columns(0).borders = [:left, :bottom]
              row(3).columns(1).borders = [:bottom]
              row(3).columns(2).borders = [:right, :bottom]
              row(3).columns(3).size = 13
              #row(0).columns(0).font_style = :bold

            end

        end
        pdf.move_down(20)
        
        pdf.table(items, :header => true, :cell_style => {:size => 14}, :column_widths => {0 => 60,1 => 200, 2 => 60, 3 => 200}, :width => 520) do           
          items.count.times do |t|
            [0,1,2,3].each do |k|
              row(t).columns(k).valign = :center
              row(t).columns(k).align = :center
            end
          end
          row(0).columns(2).valign = :center
          row(0).columns(2).align = :center          
        end
        pdf.move_down(20)        
        pdf.text "Ghi chú: Lập thành 02 bản - Bộ môn và CBGD thực hiện - Kết thúc học kỳ nộp lại cho phòng ĐT"
        d = DateTime.now
        footer = [["","", "Hải phòng, ngày #{d.day} tháng #{d.month} năm #{d.year}"],
        ["CHỦ NHIỆM BỘ MÔN","","GIẢNG VIÊN"]]
        pdf.table footer, :cell_style => {:borders => []}, :column_widths => {0 => 200, 1 => 100}, :width => 520 do 
          row(0).columns(2).align = :center
          row(1).columns(0).align = :center
          row(1).columns(2).align = :center
        end
        pdf.move_down(20)
        pdf.text "KÝ DUYỆT KẾ HOẠCH"
        pdf.move_down(60)
        pdf.text "KÝ XÁC NHẬN ĐÃ HOÀN THÀNH KẾ HOẠCH"        
        pdf.create_stamp("approved") do
          pdf.rotate(30, :origin => [-5, -5]) do
            pdf.stroke_color "FF3333"
            pdf.stroke_ellipse [0, 0], 29, 15
            pdf.stroke_color "000000"
          
            pdf.fill_color "993333"
            
            pdf.draw_text "Đã xác nhận", :at => [-23, -3]            
            pdf.fill_color "000000"
          end
        end              
        pdf.repeat(:all) do 
          pdf.draw_text "QC07-B04/1", :at => [10, -10]
          pdf.stamp "approved" 
        end
        pdf.number_pages "Trang <page>", :at => [400, -10], :page_filter => :all
        send_data pdf.render, filename: "lich_trinh_lop_#{@lop_mon_hoc.ma_lop}_#{@lop_mon_hoc.ten_giang_vien}.pdf", 
                          type: "application/pdf"
      end
    end
  end  
  def index
    authorize! :read, @lop_mon_hoc
    @lops = LopMonHoc.find(:all, :order => "id desc", :limit => 3)
    respond_to do |format|    
      format.xlsx {
        p = Axlsx::Package.new        
        wb = p.workbook
        wb.add_worksheet(:name => "Pie Chart") do |sheet|
          sheet.add_row ["Simple Pie Chart"]
          @lops.each { |label| sheet.add_row [label.ma_lop, label.get_sinh_viens.count] }
          sheet.add_chart(Axlsx::Pie3DChart, :start_at => [0,5], :end_at => [10, 20], :title => "example 3: Pie Chart") do |chart|
            chart.add_series :data => sheet["B2:B4"], :labels => sheet["A2:A4"],  :colors => ['FF0000', '00FF00', '0000FF']
          end
        end
        send_data p.to_stream.read, :filename => 'lops.xlsx', :type => "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet"     
      }
    end  
        
  end
  def report

    raise ActiveRecord::RecordNotFound unless @lop_mon_hoc
    #@lichs = @lop_mon_hoc.lich_trinh_giang_days.order('ngay_day, tuan')
    @svs = @lop_mon_hoc.lop_mon_hoc_sinh_viens
    respond_to do |format|
      format.html
    end

  end
  def show
    authorize! :read, @lop_mon_hoc
    @svs = @lop_mon_hoc.lop_mon_hoc_sinh_viens
    
    @lichs = @lop_mon_hoc.lich_trinh_giang_days.where('char_length(noi_dung_day) > 0').order('ngay_day, tuan')
    respond_to do |format|      
      format.html {render :show}
      #format.pdf { render_lichtrinh(@lichs) }
    end    
  end
  def export_lichtrinh
    authorize! :manage, @lop_mon_hoc
    @lichs = @lop_mon_hoc.lich_trinh_giang_days.where('char_length(noi_dung_day) > 0').order('ngay_day, tuan')
    @sotuan = @lichs.pluck(:tuan).uniq.count
    respond_to do |format|
      format.html
    end
  end
  def tuan
    @lop_mon_hoc = LopMonHoc.find(params[:id])
    @lichlop = @lop_mon_hoc.get_days
    @lich = @lichlop.select {|l| l["tuan"] == params[:tuan_id].to_i}.uniq if @lichlop
    respond_to do |format|
      format.html { render 'calendar'}
    end
  end
  def update
    authorize! :manage, @lop_mon_hoc
    @sn = params[:so_nhom].to_s.empty? ? 1 : params[:so_nhom].to_i
    @sl = params[:so_lan_kt].to_s.empty? ? 0 : params[:so_lan_kt].to_i
    @st = params[:so_tiet_phan_bo].empty? ? @lop_mon_hoc.so_tiet : params[:so_tiet_phan_bo].to_f
    th = params[:thuc_hanh]
    if @sn <= 0 then @sn = 1 end
    @lop_mon_hoc.update_attributes(group: @sn, so_lan_kt: @sl, so_tiet_phan_bo: @st) if @sl >= 0 and @sl <= 5 and @sn >= 1 
    @lop_mon_hoc.thuc_hanh = true if th
    @lop_mon_hoc.thuc_hanh = false unless th
    

    if @lop_mon_hoc.save! then 
      @lop_mon_hoc_sinh_viens = @lop_mon_hoc.lop_mon_hoc_sinh_viens
      @lop_mon_hoc_sinh_viens.update_all(:group_id => 1) if @sn == 1 
      @group = @lop_mon_hoc.group || 1
      @groups_arrays = {}
      @group.times do |g|
        @groups_arrays[(g+1).to_s] = "Nhóm #{g+1}"
      end
      respond_to do |format|
        format.js
      end
    end
  end


  def search
    authorize! :search, LopMonHoc

    @lop = LopMonHoc.find(params[:id])    
    @lichtrucnhat = @lop.convert_trucnhat if @lop.trucnhat
    respond_to do |format|
      format.js
      format.xlsx {
        p = Axlsx::Package.new
        wb = p.workbook
        wb.add_worksheet(:name => "Lịch trực nhật") do |sheet|
          sheet.add_row ["Lịch trực nhật"]
          sheet.add_row ["Mã lớp: #{@lop.ma_lop}"]
          sheet.add_row ["Tên môn học: #{@lop.ten_mon_hoc}"]
          sheet.add_row ["Tên giảng viên: #{@lop.ten_giang_vien}"]
          sheet.add_row ["Phòng: #{@lop.phong_hoc}"]
          sheet.add_row ["Ngày bắt đầu: #{@lop.ngay_bat_dau.localtime.strftime('%d/%m/%Y %Hh:%M')}"]
          sheet.add_row ["Ngày kết thúc: #{@lop.ngay_ket_thuc.localtime.strftime('%d/%m/%Y %Hh:%M')}"]
          sheet.add_row ["Ca học", "Thời gian", "Họ và tên", "Mã sinh viên", "Mã lớp hành chính", "Hoàn thành", "Không hoàn thành"]
          @lichtrucnhat.each { |label| sheet.add_row [label[:ca], label[:time], label[:ho_va_ten], label[:ma_sinh_vien], label[:lop_hc]] }          
        end
        send_data p.to_stream.read, :filename => "lichtrucnhat-#{@lop.ma_lop + @lop.ma_mon_hoc}.xlsx", :type => "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet"
      }
    end
  end  
  def calendar
    authorize! :read, @lop_mon_hoc
    @lich = @lop_mon_hoc.get_days
    respond_to do |format|          
      format.html {render :calendar}            
    end
  end
  def showdkbs
    authorize! :manage, @lop_mon_hoc
    @sotietbs = @lop_mon_hoc.so_tiet_phan_bo - @lop_mon_hoc.khoi_luong_phan_bo

    if @lop_mon_hoc.da_duyet_bo_sung == true
      @sobuoibs = @lop_mon_hoc.so_buoi_bo_sung
    end    
    respond_to do |format|
      format.js
    end
  end
  def dkbs
    authorize! :manage, @lop_mon_hoc
    @sobuoibs = params[:sobuoibs].to_i
    @sotietbs = params[:sotietbs].to_i

    if @sobuoibs > 0
      @lop_mon_hoc.da_duyet_bo_sung = false
      @lop_mon_hoc.so_tiet_bo_sung = @sotietbs
      @lop_mon_hoc.so_buoi_bo_sung = @sobuoibs
      @lop_mon_hoc.save!
    end

    respond_to do |format|
      format.js
    end
  end
  def qldkbs
    authorize! :manage, @lop_mon_hoc

    respond_to do |format|
      format.js
    end
  end
  protected
  def load_lop
    @lop_mon_hoc ||= LopMonHoc.find(params[:id])
  end
  private
  def render_svvang(lich)
    res = ""
    if lich.diem_danhs.count > 0
      res = "<ol>"
      lich.diem_danhs.each do |dd|
        res += "<li>#{dd.sinh_vien.to_s}</li>"
      end
      res += "</ol>"
    end
    return res
  end
  def render_lichtrinh(lichtrinhs)
    report = ThinReports::Report.new layout: File.join(Rails.root, 'app', 'reports', 'lichtrinh.tlf')

    lichtrinhs.each_with_index do |lich, index|
      report.list.add_row do |row|
        row.values no: index+1, 
                   tuan: lich.tuan.to_s, 
                   thoigian: format_date2(lich.ngay_day) + (lich.loai == 2 ? "<br/> <i><strong>( dạy bù vào #{format_date2(lich.ngay_day_moi)} </strong></i>)" : "" ), 
                   noidung: (lich.noi_dung_day.gsub(/\n/,'<br/>') if lich.noi_dung_day) || "",
                   sotiet: lich.so_tiet_day_moi,
                   phong: lich.phong_moi || "",
                   svvang: render_svvang(lich)
        
      end
    end
    
    send_data report.generate, filename: 'lichtrinh.pdf', 
                               type: 'application/pdf', 
                               disposition: 'attachment'
  end
end
