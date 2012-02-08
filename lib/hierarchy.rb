class HierarchySorter
  def initialize(il)
    @initial_list = il
    first_level = @initial_list.select{|a| a.parent_id == nil}.sort_by{|a| a.display_order }
    @final_array = subsort(first_level, 0)
  end

  def subsort(list, indent_level)
    result = []
    list.each do |item|
      result << [item, indent_level]
      result += subsort(@initial_list.select{|a| a.parent_id == item.id}.sort_by{|a| a.display_order }, indent_level + 1)
    end
    result
  end

  def sorted_array
    @final_array.map &:first
  end

  def indent_hash
    Hash[*@final_array.map{|a| [a.first.id, a.last]}.flatten]
  end
end
