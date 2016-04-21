class Differentiator

  S_Templates = {
    res_with_exponent: "%sx^%s",
    res_without_exponent: "%sx"

  }

  Selector = {
    0 => proc { |const|
      const.to_s
    },
    1 => proc { |const,modifier|
      [(S_Templates[:res_without_exponent] % const),modifier]
    },
  else: proc { |const,modifier,i|
    [(S_Templates[:res_with_exponent] % [const,i]),modifier]
    }
  }


  Modifier = {
    true => '',
    false => '+'
  }

  def initialize constants
    @constants = constants
  end

  def result
    multiply_constants.transform_to_expresions.flatten.join
  end

  def multiply_constants
    @multiplied_consts = @constants.reverse.each_with_index.map do |pv,i|
      [pv * i,i - 1]
    end.reverse.reject do |const,i|
      const == 0 || i < 0
    end
    self
  end

  def transform_to_expresions
    @multiplied_consts.each_with_index.map do |(const,i),m_i|
      modifier = Modifier[@multiplied_consts[i - 1].first < 0 || m_i + 1 == @multiplied_consts.length]
      Selector.fetch(i,Selector[:else]).call(const,modifier,i)
    end
  end


end
