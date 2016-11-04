class Shorty::App < Sinatra::Base

  before do
    content_type 'application/json'
  end

  # service is alive :-)
  get '/' do
    response.add_data(status: :ok)
  end

  # shorten a URL
  post '/shorten' do

    url       = params[:url]
    shortcode = params[:shortcode]
    shortened = Shorty::URL.shorten(url, shortcode)

    check_code(shortened)

    response.status = 201
    response.set_data({
        url:        url,
        shortcode:  shortened,
                      })
  end

  # get a short code and redirect to the relevant URL
  get '/:shortcode' do

    shortcode = params[:shortcode]
    result    = shorty.get(shortcode)

    check_code(result)

    redirect(result['url'])

  end

  # get statistics for a shortcode
  get '/:shortcode/stats' do

    data = shorty.stats(params[:shortcode])

    check_code(data)

    response.set_data({
        startDate:      data['ctime'],
        lastSeenDate:   data['atime'],
        redirectCount:  data['hits'],
    })

  end

private

  # note, a case statement could be used here, as could some kind of error code + message map
  # but this method is simpler for a small number of possible errors
  def check_code(code)
    response.fail('invalid URL',          400) if code == Shorty::URL::ERROR_URL_INVALID
    response.fail('shortcode in use',     409) if code == Shorty::URL::ERROR_CODE_EXISTS
    response.fail('invalid shortcode',    422) if code == Shorty::URL::ERROR_CODE_INVALID
    response.fail('shortcode not found',  404) if code == Shorty::URL::ERROR_CODE_NOT_FOUND
  end


  def shorty
    @shorty ||= Shorty::URL.new
  end

end
