# encoding: utf-8
# copyright: 2018, Franklin Webber

class Git < Inspec.resource(1)
  name 'git'

  def initialize(path)
    @path = path
  end

  def branches
    inspec.command("git --git-dir #{@path} branch").stdout
  end

  def current_branch
    branch_name = inspec.command("git --git-dir #{@path} branch").stdout.strip.split("\n").find do |name|
      name.start_with?('*')
    end
    branch_name.gsub(/^\*/,'').strip
  end

  def commits
    commit_ids = inspec.command("git --git-dir #{@path} log --pretty=format:'%h'").stdout.strip.split("\n")
    CommitHistory.new commit_ids
  end

  class CommitHistory
    def initialize(commits)
      @commits = commits
    end

    def HEAD
      @commits[0]
    end

    def method_missing(name,*params,&block)

      if not name.to_s.upcase.start_with?('HEAD~')
        super
      end

      index = name.to_s.upcase.gsub('HEAD~','').to_i
      @commits[index]

    end
  end

end
