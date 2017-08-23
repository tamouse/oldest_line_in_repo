require "test_helper"

class OldestLineInRepoTest < Minitest::Test
  def setup
    @project_root = File.expand_path('../../', __FILE__)
    @bogus_root = File.expand_path(File.dirname(__FILE__))
    @ops = ::OldestLineInRepo::Ops.new(@project_root)
  end

  def test_that_it_has_a_version_number
    refute_nil ::OldestLineInRepo::VERSION
  end

  def test_it_finds_a_repo
    refute_nil @ops.open_repo(@project_root)
  end

  def test_it_fails_without_a_repo
    assert_raises Rugged::RepositoryError do
      @ops.open_repo(@bogus_root)
    end
  end

  def test_git_files
    file_list = @ops.git_files
    refute_nil file_list
    files = file_list.split("\n")
    assert_includes(files, 'oldest_line_in_repo.gemspec')
  end

  def test_failing_git_files
    old_root = @ops.repo_root
    @ops.repo_root = 'xyzzy'
    assert_raises Errno::ENOENT do
      @ops.git_files
    end
    @ops.repo_root = old_root
  end

  def test_blame
    blame_data = @ops.blame('oldest_line_in_repo.gemspec')
    refute_nil blame_data
    require "byebug"; byebug
    assert_kind_of Hash, blame_data, blame_data.inspect
  end


end
