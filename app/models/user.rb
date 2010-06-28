class User < ActiveRecord::Base
  unloadable
  acts_as_authentic
end