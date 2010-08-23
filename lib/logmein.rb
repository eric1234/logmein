module Logmein

  # We try to keep configuration to a minimum as we want this to be
  # a drop-in login that works well for like-minded apps. But the
  # one config that there is no easy solution to is where to go
  # after login. To solve this we check a few locations (in this order)
  #
  #   params[:return_to]  - This way a link can determine the location after login
  #   session[:return_to] - A bit like the params version but uses session so is more hidden
  #                         Also automatically used on authentication failure
  #   Logmein.return_to   - A nice way to provide a default if the above are not set.
  #   root_url            - Path of last resort
  mattr_accessor :return_to
end
