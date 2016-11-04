class Shorty::App < Sinatra::Base

  before do
    content_type 'application/json'
  end

  # shorten a URL
  post '/' do

    binding.pry

  end

  get '/' do
    response.add_data(status: :ok)
  end

  get '/:shortcode' do

    shortcode = params[:shortcode]

    response.fail('invalid shortcode', 422)   unless shorty.valid_shortcode?(shortcode)

    result = shorty.get(shortcode)

    response.fail('shortcode not found', 404) if result == Shorty::URL::ERROR_CODE_NOT_FOUND

    response.set_data({ shortcode: shortcode })
  end

  get '/:shortcode/stats' do

    data = Shorty::URL::get(params[:shortcode])

    {
        startDate:      data['ctime'],
        lastSeenDate:   data['atime'],
        redirectCount:  data['hits'],
    }

  end

  private

  def shorty
    @shorty ||= Shorty::URL.new
  end

end
