require 'libraries/git'

describe Git do
  def load_resource(resource, *args)
    # initialize resource with backend and parameters
    @resource_class = Inspec::Resource.registry[resource]
    @resource = @resource_class.new(backend, resource, *args)
  end

  def backend
    @backend = Inspec::Backend.create({ backend: :mock, verbose: true })

    mock = @backend.backend
    empty = lambda { mock.mock_command('', '', '', 0) }

    mock.commands = {
      'git --git-dir path branch' => mock.mock_command('git --git-dir path branch', "extending-cookbook\n* master", '', 0)
    }

    @backend
  end

  it 'branches should not raise an error' do
    subject = load_resource('git','path')
    expect { subject.branches }.to_not raise_error
    expect(subject.branches).to eq "extending-cookbook\n* master"
  end
end
