class JobsController < ApplicationController

  def summary
    @summaries = JSON.parse(engine.job_status_user uid)
    @summaries.each do |j|
      j['units'].each do |u|
        u['title'] = Tool.find(u['tid']).title
      end

    end
    render layout: nil
  end

end
