# encoding: utf-8
# copyright: 2018, Franklin Webber

describe git("/home/chef/apache/.git") do
  its('branches') { should include 'master' }
  its('branches') { should include 'extending-cookbook' }
  its('current_branch') { should cmp 'master' }
  its('commits.HEAD') { should match /48bf020/ }
  its('commits.HEAD~1') { should match /09e9064/ }
end
