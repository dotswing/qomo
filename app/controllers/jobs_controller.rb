class JobsController < ApplicationController

  def summary
    tmps = hdfs.uls uid, '.tmp'

    all_success = true
    @summaries = JSON.parse(engine.job_status_user uid)
    @summaries.each do |j|
      j['units'].each do |u|
        u['title'] = Tool.find(u['tid']).title

        all_success = false unless u['status'] ==  'SUCCESS'
      end
    end

    #Clean up .tmp dir
    if all_success
      tmps.each do |e|
        hdfs.udelete uid, '.tmp', e['pathSuffix']
      end
    end

    render layout: nil
  end

end
