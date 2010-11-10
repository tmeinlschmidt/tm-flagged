module FlaggedModel
  module Version
    MAJOR = 0
    MINOR = 0
    PATCH = 1
    BUILD = 'beta'

    STRING = [MAJOR, MINOR, PATCH, BUILD].compact.join('.')
  end
end
