class App < Sinatra::Base
  get "/" do

  end

  get(/\/differentiate\/(.*)/) do
    numbers = params[:captures].first.split('/').map(&:to_i)
    Differentiator.new(numbers).result
  end
end
