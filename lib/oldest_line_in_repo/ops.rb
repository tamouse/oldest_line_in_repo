
module OldestLineInRepo
  class Ops
    attr_accessor :repo_root, :repo

    def initialize(repo_root='.')
      self.repo_root = repo_root
      self.repo = open_repo(repo_root)
    end

    def open_repo(repo_root)
      Rugged::Repository.new(repo_root)
    end

    def git_files
      Dir.chdir(repo_root) do |dir|
        cmd='git ls-files'
        o,e,s = Open3.capture3(cmd)
        unless s.success?
          $stderr.write "Error from #{cmd}:"
          $stderr.write e
          raise "Error running #{cmd}"
        end
        o.split("\n")
      end
    end

    def blame(file)
      Rugged::Blame.new(repo, file)
    end

    def oldest_line_in_file(blame_data)
      blame_data.min_by do |x|
        x[:final_signature][:time]
      end
    end

    def oldest_lines_in_repo
      git_files.map do |file|
        oldest_line_in_file(blame(file))
      end
    end

    def oldest_file_in_repo
      oldest_lines_in_repo.min_by do |x|
        x[:final_signature][:time]
      end
    end

  end
end
