# monkey-patching MaRuKu to_s
module MaRuKu
  class MDElement
    def children_to_s
      @children.join(' ')
    end
  end
end