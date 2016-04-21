class Differentiator
  attr_reader :constants, :multiplied_constants, :transformed_expressions, :displayable
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
    multiply_constants.transform_to_expresions.display
  end

  def multiply_constants
    @multiplied_constants ||=
    @constants.reverse.each_with_index.map do |pv,i|
      [pv * i,i - 1]
    end.reverse.reject do |const,i|
      const == 0 || i < 0
    end
    # returning self allows me to chain the method calls together and eliminate the need to return and store a value
    # and perform memoization at each major step
    self
  end

  def transform_to_expresions
    @transformed_expressions ||=
    @multiplied_constants.each_with_index.map do |(const,i),m_i|
      modifier = Modifier[@multiplied_constants[i - 1].first < 0 || m_i + 1 == @multiplied_constants.length]
      # by doing this you can eliminate relatively costly if conditions
      Selector.fetch(i,Selector[:else]).call(const,modifier,i)
    end
    self
  end

  def display
    @displayable ||=
    @transformed_expressions.flatten.join
  end


end
