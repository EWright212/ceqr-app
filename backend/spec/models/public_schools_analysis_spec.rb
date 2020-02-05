require 'rails_helper'

RSpec.describe PublicSchoolsAnalysis, type: :model do
  let(:project) { create(:project, build_year: 2026, bbls: [3007770001]) }

  before do
    @schoolSubdistrictMock = class_double('DoeSchoolSubdistricts')
    @schoolSubdistrictObject = double()

    allow(@schoolSubdistrictMock).to receive(:version).and_return(@schoolSubdistrictObject)

    allow(@schoolSubdistrictObject).to receive(:intersecting_with_bbls).and_return([
      {
        district: 15,
        subdistrict: 1
      }
    ])

    allow(@schoolSubdistrictObject).to receive(:for_subdistrict_pairs).and_return([
      {
        district: 15,
        subdistrict: 1,
        school_choice_ps: false,
        school_choice_is: true,
        geom: RGeo::WKRep::WKBParser.new(nil, support_ewkb: true).parse("0106000020E6100000010000000103000000010000007C000000A4FE7A85058152C0A3923A014D544440A33F34F3E48052C0BE33DAAA24544440A75A0BB3D08052C0355EBA490C54444090F5D4EAAB8052C046ED7E15E053444033FE7DC6858052C08D25AC8DB1534440D21C59F9658052C066A3737E8A534440560C5707408052C0957F2DAF5C534440E08442041C8052C05E2EE23B315344402237C30DF87F52C086E5CFB705534440401361C3D37F52C0EACE13CFD9524440591822A7AF7F52C0B37DC85BAE5244404CFF9254A67F52C0772E8CF4A2524440B30C71AC8B7F52C0DB34B6D78252444067B45549647F52C076FBAC325352444020D1048A587F52C0F19D98F56252444020B41EBE4C7F52C0BADDCB7D725244401AC05B20417F52C0471FF3018152444069519FE40E7F52C0D3669C86A8524440292504ABEA7E52C054E3A59BC452444041649126DE7E52C01FF30181CE524440C0046EDDCD7E52C0FB05BB61DB52444057CD7344BE7E52C060E811A3E7524440E9263108AC7E52C0B8E864A9F5524440FDDCD0949D7E52C0F437A11001534440F850A2258F7E52C04DA088450C5344403B8BDEA9807E52C06BD619DF17534440F086342A707E52C053E8BCC62E534440B1169F02607E52C0BC1FB75F3E534440DC0E0D8B517E52C0B77F65A5495344408690F3FE3F7E52C0B4006DAB595344400C3F389F3A7E52C00457790261534440069CA564397E52C0CFF8BEB8545344405587DC0C377E52C09F573CF548534440096CCEC1337E52C0B5DD04DF345344409BC8CC052E7E52C041F2CEA10C534440C6DD205A2B7E52C068AF3E1EFA52444015E3FC4D287E52C0261E5036E55244406B274A42227E52C01DE90C8CBC524440077C7E18217E52C0FD4AE7C3B3524440DF50F86C1D7E52C0C34659BF995244402E7079AC197E52C0BE839F3880524440664D2CF0157E52C02577D844665244400D6D0036207E52C0CD936B0A6452444053CE177B2F7E52C058CB9D9960524440910A630B417E52C01E3526C45C524440C498F4F7527E52C0732B84D55852444086CABF96577E52C0382D78D1575244408FC2F5285C7E52C0FD2E6CCD56524440F1D4230D6E7E52C082A966D6525244407EFCA5457D7E52C07E54C37E4F5244406B2C616D8C7E52C0A983BC1E4C5244401096B1A19B7E52C0A52E19C74852444068CA4E3FA87E52C0321F10E84C5244400C957F2DAF7E52C0F3FFAA23475244400F99F221A87E52C05C38109205524440280F0BB5A67E52C02942EA76F6514440F6D4EAABAB7E52C03C66A032FE514440DEE34C13B67E52C0A98427F4FA51444078B6476FB87E52C06CCD565EF25144407FC16ED8B67E52C0C2DA183BE1514440D80C7041B67E52C0079ACFB9DB5144402DE92807B37E52C000529B38B95144404E266E15C47E52C0DE1D19ABCD5144403621AD31E87E52C0E6EAC726F951444063096B63EC7E52C0DE74CB0EF15144403D635FB2F17E52C01F1329CDE6514440B5183C4CFB7E52C0F8325184D45144409D137B681F7F52C00000000000524440444DF4F9287F52C07A17EFC7ED5144404B8FA67A327F52C0A2D45E44DB514440F3C81F0C3C7F52C04C70EA03C9514440E2C80391457F52C0E4A08499B651444072C0AE264F7F52C04D4D8237A4514440323CF6B3587F52C08675E3DD91514440DA756F45627F52C08F19A88C7F51444099F1B6D26B7F52C098BD6C3B6D514440596DFE5F757F52C090F63FC05A514440486DE2E47E7F52C03A92CB7F48514440BFF4F6E7A27F52C0E256410C74514440B7B24467997F52C0A92EE0658651444028BB99D18F7F52C011FE45D09851444075AC527AA67F52C009DFFB1BB4514440577C43E1B37F52C0B9C2BB5CC45144401A19E42EC27F52C0D4282499D551444056B950F9D77F52C0D3FA5B02F05144409DBCC804FC7F52C04B3B35971B5244409CF9D51C208052C06473D53C475244402CF180B2298052C02C280CCA3452444033333333338052C095D409682252444093A641D13C8052C09E78CE16105244406B64575A468052C0D7A02FBDFD51444042226DE34F8052C0404D2D5BEB5144401AE0826C598052C079758E01D9514440C119FCFD628052C05395B6B8C6514440B119E0826C8052C0EBC5504EB4514440514B732B848052C0A1832EE1D0514440C898BB96908052C064062AE3DF514440BA6B09F9A08052C0FA25E2ADF35144405793A7ACA68052C0E5B67D8FFA514440AF93FAB2B48052C0ADC266800B524440AFD007CBD88052C05587DC0C37524440EF54C03DCF8052C0ECDADE6E49524440DD26DC2BF38052C0833463D174524440D05E7D3CF48052C0118DEE2076524440F9A067B3EA8052C0D8648D7A88524440C9022670EB8052C0A2EF6E6589524440075C57CC088152C031D3F6AFAC52444030D5CC5A0A8152C095641D8EAE524440A7EB89AE0B8152C064AC36FFAF524440DC12B9E00C8152C0F304C24EB15244403AE7A7380E8152C0225514AFB25244405E143DF0318152C0AC00DF6DDE524440450F7C0C568152C02541B8020A53444023D8B8FE5D8152C0DEE522BE13534440F836FDD98F8152C09B1F7F69515344401AA20A7F868152C0F60CE19865534440B6D95889798152C0B1DF13EB545344407EAB75E2728152C0B0C8AF1F62534440227024D0608152C0C8B60C384B53444062DA37F7578152C031EE06D15A5344400E1137A7928152C0C21550A8A753444092240857408152C0D2A8C0C9365444409031772D218152C03F8C101E6D544440A4FE7A85058152C0A3923A014D544440")
      }
    ])

    stub_const("#{CeqrData}::DoeSchoolSubdistricts", @schoolSubdistrictMock)
  end

  describe "saving "

  it "sets subdistricts correctly" do
    expect(project.public_schools_analysis.subdistricts_from_db[0]['district']).to eq(15)
    expect(project.public_schools_analysis.subdistricts_from_db[0]['subdistrict']).to eq(1)
  end

  it "sets es_school_choice and is_school_choice correctly" do
    expect(project.public_schools_analysis.es_school_choice).to eq(false)
    expect(project.public_schools_analysis.is_school_choice).to eq(true)
  end

  it "sets ceqr_school_buildings correctly" do
    expect(project.public_schools_analysis.ceqr_school_buildings[0]['district']).to eq(15)
    expect(project.public_schools_analysis.ceqr_school_buildings[0]['subdistrict']).to eq(1)

    expect(project.public_schools_analysis.ceqr_school_buildings.first).to match_json_schema("ceqr_school_buildings")
  end

  it "sets sca projects correctly" do
    expect(project.public_schools_analysis.sca_projects[0]['district']).to eq(15)
    expect(project.public_schools_analysis.sca_projects[0]['subdistrict']).to eq(1)
  end

  it "sets future_enrollment_multipliers correctly" do
    expect(project.public_schools_analysis.future_enrollment_multipliers[0]['district']).to eq(15)
    expect(project.public_schools_analysis.future_enrollment_multipliers[0]['subdistrict']).to eq(1)
  end

  it "sets hs_projections correctly" do
    borough = project.public_schools_analysis.hs_projections.map {|n| n['borough']}
    expect(borough).to eq(['brooklyn'])
  end

  it "sets future_enrollment_projections correctly" do
    expect(project.public_schools_analysis.future_enrollment_projections[0]['district']).to eq(15)
  end

  it "sets hs_students_from_housing correctly" do
    # new_students in table sca_housing_pipeline_by_boro for Brooklyn is 4802
    expect(project.public_schools_analysis.hs_students_from_housing).to eq(4802)
  end

  it "sets set future_enrollment_new_housing correctly" do
    expect(project.public_schools_analysis.future_enrollment_new_housing[0]['district']).to eq(15)
    expect(project.public_schools_analysis.future_enrollment_new_housing[0]['subdistrict']).to eq(1)
  end

  it "sets set doe_util_changes correctly" do
    schoolBuildingIds = project.public_schools_analysis.ceqr_school_buildings.map {|b| b['bldg_id']}

    allBuildingIds = (schoolBuildingIds).uniq

    doeBuildingIds = project.public_schools_analysis.doe_util_changes.map {|b| b['bldg_id']}.uniq # two items for district 15 subdistrict 1

    expect(allBuildingIds).to include(doeBuildingIds[0], doeBuildingIds[1])
  end
end
