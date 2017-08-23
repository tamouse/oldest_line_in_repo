require "open3"
require "rugged"
require "oldest_line_in_repo/version"

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
        o
      end
    end

    def blame(file)
      Rugged::Blame.new(repo, file)
    end

  end

end
