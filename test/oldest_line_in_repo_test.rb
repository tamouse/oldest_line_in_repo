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

  def test_it_finds_a_repo
    refute_nil @ops.open_repo(@project_root)
  end

  def test_it_fails_without_a_repo
    assert_raises Rugged::RepositoryError do
      @ops.open_repo(@bogus_root)
    end
  end

  def test_git_files
    files = @ops.git_files
    assert_includes(files, @test_file)
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
    blame_data = @ops.blame(@test_file)
    assert_kind_of Rugged::Blame, blame_data, blame_data.inspect
  end

  def test_oldest_line_in_file
    blame_data = @ops.blame(@test_file)
    oldest = @ops.oldest_line_in_file(blame_data)
    assert_kind_of Hash, oldest, oldest.inspect
    assert_equal oldest[:final_signature][:time].strftime("%F-%H-%M"), "2017-08-23-09-07"
  end

  def test_oldest_lines_in_repo
    oldest = @ops.oldest_lines_in_repo
    assert_kind_of Array, oldest
    assert_equal oldest.count, @ops.git_files.count
  end

  def test_oldest_file_in_repo
    oldest = @ops.oldest_file_in_repo
    assert_kind_of Hash, oldest
    binding.pry
    assert_equal oldest[:final_signature][:time].strftime("%F-%H-%M"), "2017-08-23-09-07"
  end


end
