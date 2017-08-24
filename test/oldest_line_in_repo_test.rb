require "test_helper"

class OldestLineInRepoTest < Minitest::Test
  def setup
    @test_file = 'oldest_line_in_repo.gemspec'
    @project_root = File.expand_path('../../', __FILE__)
    @bogus_root = File.expand_path(File.dirname(__FILE__))
    @ops = ::OldestLineInRepo::Ops.new(@project_root)
  end

  def test_that_it_has_a_version_number
    refute_nil ::OldestLineInRepo::VERSION
  end



end
