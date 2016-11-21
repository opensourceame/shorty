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

    response.status = 201

    begin
      shortened = shorty.shorten_url(url, shortcode)

    rescue ArgumentError => e

      response.fail(e.to_s, 409)

    rescue StandardError => e

      response.fail(e.to_s, 409)

    rescue Exception => e
      response.fail(e.to_s)
    end

    response.set_data({
        url:        url,
        shortcode:  shortened,
                      })
  end

  # get a short code and redirect to the relevant URL
  get '/:shortcode' do

    shortcode = params[:shortcode]

    begin
      result = shorty.get(shortcode)
    rescue => e
      response.fail(e.to_s, 404)
    end

    redirect(result['url'])

  end

  # get statistics for a shortcode
  get '/:shortcode/stats' do

    begin
      stats = shorty.stats(params[:shortcode])
    rescue => e
      response.fail(e.to_s, 404)
    end

    # NOTE: Redis returns strings, so convert to specific types here
    response.set_data({
        startDate:      DateTime.parse(stats['ctime']).iso8601,
        lastSeenDate:   DateTime.parse(stats['atime']).iso8601,
        redirectCount:  stats['hits'].to_i,
    })

  end

private

  def shorty
    @shorty ||= Shorty::Code.new
  end

end
