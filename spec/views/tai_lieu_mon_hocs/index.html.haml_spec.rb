require 'spec_helper'

describe "tai_lieu_mon_hocs/index" do
  before(:each) do
    assign(:tai_lieu_mon_hocs, [
      stub_model(TaiLieuMonHoc,
        :ma_giang_vien => "Ma Giang Vien",
        :ma_lop => "Ma Lop",
        :ma_mon_hoc => "Ma Mon Hoc",
        :noi_dung => "MyText",
        :nam_hoc => "Nam Hoc",
        :hoc_ky => 1
      ),
      stub_model(TaiLieuMonHoc,
        :ma_giang_vien => "Ma Giang Vien",
        :ma_lop => "Ma Lop",
        :ma_mon_hoc => "Ma Mon Hoc",
        :noi_dung => "MyText",
        :nam_hoc => "Nam Hoc",
        :hoc_ky => 1
      )
    ])
  end

  it "renders a list of tai_lieu_mon_hocs" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Ma Giang Vien".to_s, :count => 2
    assert_select "tr>td", :text => "Ma Lop".to_s, :count => 2
    assert_select "tr>td", :text => "Ma Mon Hoc".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "Nam Hoc".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
