class Settings < Settingslogic
  source "#{Rails.root}/config/settings.yml"

  namespace Rails.env

  def self.tools
    File.join self.home, 'tools'
  end


  def self.lib_path(*path)
    File.join self.home, 'lib', path
  end

end
