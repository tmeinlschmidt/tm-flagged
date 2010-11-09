module FlaggedModel
  module Version
    MAJOR = 0
    MINOR = 0
    PATCH = 1
    BUILD = 'alpha'

    STRING = [MAJOR, MINOR, PATCH, BUILD].compact.join('.')
  end
end
