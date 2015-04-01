require "spec_helper"

describe 'handout routing' do

  let(:handout_params) do
    { locale: 'de',
      format: 'pdf',
      real_estate_id: '111222111222',
      controller: 'handouts',
      action: 'show' }
  end

  it 'routes handout pdf correct' do

    expect(get: "/de/real_estates/111222111222/handout.pdf")
      .to route_to(handout_params)

    expect(get: "/de/real_estates/111222111222/Xxx_Vvvv.pdf")
      .to route_to(handout_params.merge(name: 'Xxx_Vvvv', action: 'deprecated_route'))
  end

end
