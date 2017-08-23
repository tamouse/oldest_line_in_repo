require "open3"

module OldestLineInRepo

  def self.find_files(with_dot: false)
    cmd = if with_dot
      'find . -type f'
    else
      'find . -type f|grep -Ev "^\./\."'
    end

    output, error, status = Open3.capture3(cmd)
    {
      output: output,
      error: error,
      status: status
    }
  end

  def self.git_blame(filename)
    cmd = 'git blame --date:format%Y%m%d "#{filename}"'
    output, error, status = Open3.capture3(cmd)
    {
      output: output,
      error: error
      status: status
    }
  end

end
